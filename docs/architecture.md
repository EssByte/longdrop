# Architecture

Longdrop is made of **two separate codebases**.

## 1. The App (this repo)

Flutter, runs on the phone. Contains both:

- **Frontend** — screens, buttons, progress bar.
- **Backend logic (in-app)** — key generation, encryption, chunking, WebRTC.

> The in-app backend logic (`lib/backend/`) is written by hand by the project owner. AI assistants should not write or modify it. See [AGENTS.md](../AGENTS.md).

## 2. The Server (separate repo, runs on a VPS)

- **Signaling API (WebSocket)** — register, find-peer, pass connection info.
- **TURN relay** — backup path only, used when a direct P2P connection fails (~10–20% of real-world cases).

The server never stores or reads file data.

## Identity model

- On install, the phone generates a key pair locally from a random 128-bit seed. The private key never leaves the device.
- The public key is the permanent user ID, shared like a phone number/contact.
- **Recovery (added 2026-10-25):** the seed is also encoded as a 12-word BIP39 backup phrase, shown once at first launch. The user must write it down. On reinstall, entering the phrase regenerates the exact same seed, keys, and ID — contacts don't need to be re-shared. Losing the phrase AND the device still means permanent loss of that ID (no server-side recovery, by design).

### Process 1 diagram — Registration

Color key: 🟡 UI/app state · 🔴 Crypto (owner-written backend) · 🔵 Network/signaling · 🟢 Local storage · ⚪ Decision point

```mermaid
flowchart TD
    classDef uiStep fill:#fde68a,stroke:#b45309,stroke-width:2px,color:#1f2937
    classDef cryptoStep fill:#fca5a5,stroke:#991b1b,stroke-width:2px,color:#1f2937
    classDef networkStep fill:#93c5fd,stroke:#1d4ed8,stroke-width:2px,color:#1f2937
    classDef storageStep fill:#86efac,stroke:#15803d,stroke-width:2px,color:#1f2937
    classDef decision fill:#e5e7eb,stroke:#374151,stroke-width:2px,color:#1f2937

    A[App installed, first launch]:::uiStep --> B{Does a key pair already exist on this device?}:::decision

    B -- No, first time --> B2{User has a backup phrase to restore?}:::decision
    B2 -- No, brand new identity --> C[Generate 128-bit random seed]:::cryptoStep
    B2 -- Yes, restoring --> RC[User types in their 12-word backup phrase]:::uiStep
    RC --> RD[Convert phrase back to the same 128-bit seed - BIP39 standard]:::cryptoStep
    RD --> C2[Seed recovered - same as original]:::cryptoStep

    C --> C3[Encode seed as 12-word backup phrase - BIP39 wordlist]:::cryptoStep
    C3 --> C4[Show phrase once: 'Write this down, it is the ONLY way to recover your ID']:::uiStep
    C4 --> C5[User confirms they saved it]:::uiStep
    C5 --> D

    C2 --> D[Derive X25519 encryption key pair + Ed25519 signing key pair from seed]:::cryptoStep
    D --> E[Store private keys in device secure storage - Android Keystore / iOS Keychain]:::storageStep
    E --> F[Derive public key from private key]:::cryptoStep
    F --> G[Public key encoded as the permanent user ID - e.g. base58 string]:::cryptoStep
    G --> H[Save public key ID + metadata to local app database]:::storageStep

    B -- Yes, returning user, keys already on this device --> H2[Load existing key pair from secure storage]:::storageStep
    H2 --> H3[Load existing public key ID]:::storageStep

    H --> J[Open WebSocket connection to Signaling Server URL]:::networkStep
    H3 --> J

    J --> K{WebSocket connects?}:::decision
    K -- No --> L[Show 'Cannot reach server' banner, retry with backoff]:::uiStep
    L --> J

    K -- Yes --> M[Send REGISTER message: my public key ID]:::networkStep
    M --> N{Server responds within timeout?}:::decision

    N -- Timeout / no response --> O[Show 'Server not responding' banner, retry]:::uiStep
    O --> M

    N -- Server sends REGISTER_OK --> P[Mark app state as Registered]:::uiStep
    N -- Server sends REGISTER_ERROR --> Q[Show specific error from server]:::uiStep

    P --> R[Show Home screen: My ID, Send File, Receive File all enabled]:::uiStep
    P --> S[Keep WebSocket alive with periodic ping/heartbeat]:::networkStep

    S --> T{Connection drops?}:::decision
    T -- Yes --> U[Show 'Reconnecting...' banner]:::uiStep
    U --> J
    T -- No --> S
```

## How a file transfer works (no middleman for the file)

1. Each phone asks a STUN server "what's my real public address?" (NAT traversal).
2. Both phones send their address to each other via the signaling server. Only addresses pass through the server, never the file.
3. The phones connect directly; the file flows phone-to-phone, end-to-end encrypted.
4. If the direct connection fails (strict NAT/firewall), it falls back to the TURN relay, which passes the encrypted data through blind (it cannot read it).

### Process 2 diagram — Connection Setup

Same color key as above. This runs after both sender and receiver have completed Process 1 (Registration).

```mermaid
flowchart TD
    classDef uiStep fill:#fde68a,stroke:#b45309,stroke-width:2px,color:#1f2937
    classDef cryptoStep fill:#fca5a5,stroke:#991b1b,stroke-width:2px,color:#1f2937
    classDef networkStep fill:#93c5fd,stroke:#1d4ed8,stroke-width:2px,color:#1f2937
    classDef storageStep fill:#86efac,stroke:#15803d,stroke-width:2px,color:#1f2937
    classDef decision fill:#e5e7eb,stroke:#374151,stroke-width:2px,color:#1f2937

    A[Sender opens 'Send File' screen]:::uiStep --> B[Sender picks a file from device storage]:::uiStep
    B --> C[Sender enters or scans Receiver's public ID]:::uiStep
    C --> D[App sends CONNECT_REQUEST to Signaling Server: from=my ID, to=Receiver ID, file name + size]:::networkStep

    D --> E{Server looks up Receiver ID in its registered table}:::decision
    E -- Not found / offline --> F[Server sends PEER_OFFLINE back to Sender]:::networkStep
    F --> G[Show 'Receiver is not online right now' message]:::uiStep

    E -- Found, Receiver connection is live --> H[Server forwards INCOMING_REQUEST to Receiver's connection: from=Sender ID, file name + size]:::networkStep
    H --> I[Receiver app shows popup: 'longdrop_user_9f3a wants to send you photo.jpg - 4.2 MB. Accept?']:::uiStep

    I --> J{Receiver taps Accept or Decline}:::decision
    J -- Decline --> K[Receiver sends DECLINE to Server]:::networkStep
    K --> L[Server forwards DECLINED to Sender]:::networkStep
    L --> M[Show 'Receiver declined the transfer' on Sender's screen]:::uiStep

    J -- Accept --> N[Receiver sends ACCEPT to Server]:::networkStep
    N --> O[Server forwards ACCEPTED to Sender]:::networkStep
    O --> P[Both apps show 'Connecting...' and move to Process 3: Path Selection]:::uiStep

    D --> Q{Server responds within timeout - e.g. 10s?}:::decision
    Q -- No response --> R[Show 'Could not reach server, try again' on Sender]:::uiStep
```

## Known v1 limitation

Both sender and receiver must keep the app open and online for the whole transfer. Closing the app, losing connection, or the OS killing the app in the background makes the transfer fail, and it must be restarted.

Accepted for v1. Resume support and/or async transfer (server-stored encrypted blob) are considered for v2.

## Staying alive during a transfer (added 2026-10-25)

Mobile OSes aggressively suspend or kill backgrounded apps to save battery, which would silently drop the signaling WebSocket and any active WebRTC transfer. To prevent this during an active transfer:

- **Android:** run a foreground service with a persistent notification (e.g. "Longdrop: sending photo.jpg — 45%") while a transfer is in progress. This is the same mechanism apps like WhatsApp/Signal use to survive calls in the background.
- **iOS:** equivalent background task/VoIP-style entitlement as needed (details TBD when iOS build is tackled — Android is first).
- Outside of an active transfer, the app does NOT hold a foreground service — only while sending or receiving.

## Reconnection behavior

The "online" state is not a flag the app sets — it is simply whether the signaling WebSocket to the server is currently open. If the connection drops (backgrounding without the foreground service, network loss, server restart, etc.), the server removes the user from its live-connections table immediately.

On resume (app foregrounded again, or foreground service keeps it alive), the app must:
1. Detect the WebSocket is closed.
2. Reconnect and re-send the REGISTER message automatically, with no user action needed.
3. If this happens mid-transfer and the foreground service did NOT keep the connection alive, the transfer is lost per the v1 limitation above and must restart from Process 2 (Connection Setup).

## Code structure / state management

The app uses [Riverpod](https://riverpod.dev) (`flutter_riverpod`) as the state-management layer between the backend and the UI.

```
lib/
├── backend/     # owner-written logic: crypto, signaling, WebRTC (plain Dart)
├── providers/   # Riverpod seam: wraps backend services, exposes watchable state
├── screens/     # full-page UI (Home, My ID, Send, Receive)
├── widgets/     # reusable UI pieces
└── main.dart    # app root, wrapped in ProviderScope
```

- **`lib/backend/`** — the project owner's own code. Plain Dart with zero Flutter/UI imports. Owns all crypto, signaling and WebRTC logic. AI assistants must not touch this layer's logic (see [AGENTS.md](../AGENTS.md)); only the provider wiring that wraps it lives elsewhere.
- **`lib/providers/`** — the Riverpod seam. Wraps backend services as providers and exposes state that screens can watch.
- **`lib/screens/` and `lib/widgets/`** — UI. They only ever import `lib/providers/`, never `lib/backend/` directly.
