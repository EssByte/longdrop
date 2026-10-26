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

- On install, the phone generates a key pair locally. The private key never leaves the device.
- The public key is the permanent user ID, shared like a phone number/contact.
- Delete + reinstall = old private key gone forever and a new ID is generated. There is no recovery in v1 (accepted tradeoff).

## How a file transfer works (no middleman for the file)

1. Each phone asks a STUN server "what's my real public address?" (NAT traversal).
2. Both phones send their address to each other via the signaling server. Only addresses pass through the server, never the file.
3. The phones connect directly; the file flows phone-to-phone, end-to-end encrypted.
4. If the direct connection fails (strict NAT/firewall), it falls back to the TURN relay, which passes the encrypted data through blind (it cannot read it).

## Known v1 limitation

Both sender and receiver must keep the app open and online for the whole transfer. Closing the app, losing connection, or the OS killing the app in the background makes the transfer fail, and it must be restarted.

Accepted for v1. The app shows a "keep app open" warning during transfer. Resume support and/or async transfer (server-stored encrypted blob) are considered for v2.

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
