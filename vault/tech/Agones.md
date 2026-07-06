---
tags: [tech, platform, cv-keyword]
---

# Agones

Google's open-source game-server orchestration for Kubernetes — real CV keyword, used by actual
studios. Manages `GameServer` pods, `Fleet`s, and autoscaling. The self-heal star of [[07 Demo Script]]:
when the chaos job kills a gameserver, Agones replaces it while [[Dynatrace]] proves the detection.

## ✅ Verified 2026-07-06 (web, sources checked live)

- Current stable **v1.59.0** (2026-06-30), ~6-week cadence, k8s 1.33–1.35.
- **linux/arm64 images exist since v1.23 but arm64 is officially ALPHA** (only amd64 is Stable) —
  matters because [[OCI Always Free]] is ARM. Mitigation: pin the version, smoke-test with
  `simple-game-server` (the one example image guaranteed arm64), upgrade deliberately.
- **k3s: known-working, unofficial** (supported list is GKE/AKS/EKS/Minikube; Linode published a
  k3s+Agones+Xonotic guide). Fine for a lab.
- GameServers use **hostPort UDP 7000-8000** by default → open in VCN security list AND host
  iptables ([[k3s]]). Port range also caps concurrent servers on one node.
- **FleetAutoscaler**: Buffer, Webhook, Chain, Schedule policies plus **Counter/List (Beta, on by
  default)** — true player-count scaling works, but the game must call the SDK counter APIs.
  On one node, over-scale just yields Pending pods (fine: that's a visible autoscaling story anyway).

## Install (Phase 2)

```bash
helm repo add agones https://agones.dev/chart/stable
helm install agones agones/agones --namespace agones-system --create-namespace \
  --version 1.59.0   # pinned; arm64 = alpha, upgrade deliberately
```

Smoke test: deploy the official `simple-game-server` Fleet before any real game — [[Game Servers]].
