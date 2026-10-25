# AGENTS.md — Longdrop

Orientation for any AI coding agent working in this repo. Read this first.

> ## ⚠️ OWNERSHIP SPLIT — READ BEFORE WRITING ANY CODE
>
> **Backend / crypto / networking code is written BY HAND by the project owner. The AI assistant MUST NOT write or modify it.**
>
> This covers: key generation, encryption, chunking, WebRTC, and signaling-client logic — i.e. everything under `lib/backend/` and any other code that does crypto or networking.
>
> - ❌ Do **not** implement, "fill in", or refactor the stubs in `lib/backend/`.
> - ✅ You may **advise or review** that code, only if the owner asks.
> - ✅ **Frontend** (Flutter UI, screens, navigation, widgets) is built collaboratively — you may write code there.
> - The **signaling server** is a separate codebase/repo and is **not part of this repo**.
>
> This is a learning project; the owner writing the backend is the point. If a task seems to require backend changes, stop and say so instead of doing it.

## What it is

**Longdrop** is an end-to-end encrypted (E2EE), cross-platform file-sharing app built with Flutter. It works across the internet via WebRTC peer-to-peer connections — not just on the local network like LocalSend. Files go phone-to-phone with no account and no server-side storage.

## Objectives

Fill the real gap: **E2EE, full-quality, no-account file transfer that works cross-border.** (LocalSend is LAN-only; WhatsApp/Signal compress media and cap sizes.) See [docs/scope.md](docs/scope.md).

## Architecture summary

Two separate codebases:

1. **The App (this repo, Flutter, phone)**
   - Frontend: screens, buttons, progress bar.
   - In-app backend logic: key generation, encryption, chunking, WebRTC (owner-written).
2. **The Server (separate repo, VPS, not here)**
   - Signaling API (WebSocket): register, find-peer, pass connection info.
   - TURN relay: backup path only, when direct P2P fails.

Identity: a key pair is generated locally on install; the public key is the permanent user ID. Reinstalling generates a new ID; no recovery in v1.

Known v1 limitation: sender and receiver must both keep the app open and online for the whole transfer; otherwise it fails and must restart.

Details: [docs/architecture.md](docs/architecture.md).

## V1 scope (decided 2026-10-24)

- P2P only; no server-side file storage.
- Open source: both the app and the signaling server.
- Self-hosted signaling server.
- Web is out of scope for this repo (a separate future Next.js project).
- Pages: Home, My ID, Send File, Receive File. No accounts, no history, no settings beyond a "keep app open" banner during transfer. See [docs/pages.md](docs/pages.md).

## Current state

- Flutter project scaffolded: the 4 screens exist as placeholder UI with navigation (`lib/screens/`, `lib/widgets/`).
- `lib/backend/` contains **only stubs and a README**. Zero real crypto/networking implementation exists yet.
- Signaling server: not started; separate repo, not yet created.

## Docs

- [docs/architecture.md](docs/architecture.md) — codebases, identity, transfer flow, v1 limitation
- [docs/pages.md](docs/pages.md) — screens and navigation flow
- [docs/scope.md](docs/scope.md) — v1 scope and rationale

Don't invent new scope or decisions; if something isn't in these docs, ask the owner.
