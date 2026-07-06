---
tags: [tech, workload]
---

# Game Servers

What the lab observes and auto-heals. Verified 2026-07-06 for ARM64 (the [[OCI Always Free]] constraint).

## The line-up (in deployment order)

1. **simple-game-server** (Agones official example) — guaranteed arm64, UDP echo. Pure smoke test
   for [[Agones]]; deploy first, delete after.
2. **agar.io-clone** (owenashurst/agar.io-clone, MIT, Node.js + Socket.IO) — **the MVP fleet**.
   Node is arm64-native, Dockerfile included, WebSocket transport means [[k6]] load-tests it
   NATIVELY (k6 has no UDP). Instrument the server loop ourselves with [[OpenTelemetry]]:
   **tick duration** + **WS round-trip latency** → the two [[Dynatrace SLOs]]. Bots = simple WS scripts.
3. **Minecraft Java** (`itzg/minecraft-server`, multi-arch arm64) — the recognizable demo piece.
   ~2 GB RAM vanilla; run as a second, smaller Fleet or demo-days only if RAM is tight
   (see budget in [[03 Phase 2 — Cluster and Agones]]). Load: Minecraft bot library, not k6.
   Player-count autoscaling needs a small sidecar calling the Agones SDK counter API.

## Avoid (verified)

- **Minecraft Bedrock** on ARM: x86-only binaries, runs via box64 emulation with known
  illegal-instruction bugs. Java only.
- **Xonotic / SuperTuxKart example images**: arm64 manifests unverified — assume amd64-only unless
  `docker manifest inspect` proves otherwise.
- `saulmaldonado/agones-minecraft`: abandoned (2021, GKE-specific) — reference architecture only.

## Also observed (non-game workloads)

- Dutch-lessons site + [[Gemini Chatbot]] (Azure static hosting).
- Optional: the home [[Home Server Docker Stack]] (Plex/*arr) as a second real environment.
