---
tags: [phase]
---

# Phase 2 — Cluster, game fleet, chaos (effort: MEDIUM/HIGH)

Goal: [[k3s]] on the [[OCI Always Free]] VM, [[Agones]] managing a [[Game Servers]] fleet,
a chaos CronJob killing gameservers on schedule. Ends visibly monitored: `kubectl get gameservers`
shows kills and respawns happening on their own.

## Steps

1. Fill `terraform/modules/oci-cluster`: A1.Flex VM (4 OCPU/24 GB), VCN, security list —
   22/tcp, 80/443/tcp, **7000-8000/udp** (Agones port range), 6443/tcp restricted to home IP.
2. cloud-init: install k3s single-node (`curl -sfL https://get.k3s.io | sh -`), copy kubeconfig
   → laptop (`~/.kube/config`, NEVER the repo — [[Secrets Hygiene]]).
3. PR → plan → merge → apply → `kubectl get nodes` from the laptop. 📸
4. Install [[Agones]] via Helm, version PINNED (arm64 is Alpha — see the ✅ verification section there).
5. Smoke test with the official `simple-game-server` Fleet (the one example guaranteed arm64) —
   kill a pod by hand, watch it respawn. Delete it.
6. Deploy the real fleet: **agar.io-clone** `Fleet` (2-3 replicas) + `FleetAutoscaler` —
   manifests and the Minecraft-Java option per [[Game Servers]].
7. Join the game from the laptop — prove a human can play. 📸
8. Chaos CronJob (`*/10 * * * *`): kill one allocated gameserver pod →
   watch Agones replace it. This loop is what [[Dynatrace SLOs]] will measure in Phase 3.
9. Also install the [[Elastic Stack]] (single-node ES + Kibana) now — it needs cluster RAM budgeted
   before anything else lands (~3 GB reserved).

## RAM budget (assume **12 GB** — the possibly-shrunk free shape, [[OCI Always Free]])

k3s+system ~1.5 · Agones ~0.75 · agar.io fleet 3×0.3 · ES 2 (limit) + Kibana 1 ·
[[OTel Collector]] 0.3 (memory_limiter) ≈ **6.5 GB** → ~5 GB headroom for [[k6]] jobs and Phase 3.
Minecraft Java (+2 GB) fits only as demo-day extra on 12 GB — or permanently if signup grants 24 GB.

Next: [[04 Phase 3 — OTel and Dynatrace]]
