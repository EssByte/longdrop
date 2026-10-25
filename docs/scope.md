# Scope

## Why Longdrop (vs existing tools)

- **LocalSend:** local network only, no internet mode.
- **WhatsApp / Signal:** compress media, impose size caps, and aren't built for clean one-off file transfer.
- **The real gap:** E2EE, full-quality, no-account file transfer that works cross-border.

## Project nature

A learning project: the backend is written by hand by the project owner; the frontend is built collaboratively with an AI assistant.

## V1 scope (decided 2026-10-24)

- **P2P only.** No server-side file storage (avoids legal/compliance exposure).
- **Open source:** both the app and the signaling server.
- **Self-hosted signaling server.** Cheap, since it only relays short connection messages and never touches file data.
- **Web is out of scope for this repo.** It's a separate future Next.js project, connected later via the same signaling API.
- **No accounts, no history**, and no settings beyond a "keep app open" warning banner during transfer.

## Deferred (v2 considerations)

Resume support and/or async transfer (server-stored encrypted blob). See the v1 limitation in [architecture.md](architecture.md).
