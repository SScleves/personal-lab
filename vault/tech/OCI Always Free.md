---
tags: [tech, cloud]
---

# OCI Always Free

Role in the lab: **the muscle** — one Ampere A1 ARM VM (up to 4 OCPU / 24 GB / 200 GB boot volume,
free forever) hosting [[k3s]] + [[Agones]] + [[Game Servers]] + [[Elastic Stack]] + [[OTel Collector]].
Chosen because it's the only €0 host with enough RAM ([[01 Phase 0 — Free Tiers and Architecture]]).

## Gotchas

- **Home region is permanent** — choose before signup; quieter regions have better free-ARM availability.
- **"Out of host capacity"** for free A1 instances is a known 2026 issue in busy regions: retry
  (script it), or upgrade the account to PAYG *while staying inside always-free shapes* — reportedly
  improves placement priority. Card required at signup either way (verification only).
- **Everything is ARM64** — every container image on the cluster must be linux/arm64
  (see the verification section in [[Agones]] and [[Game Servers]]).
- Terraform module: `terraform/modules/oci-cluster` — ports 22, 80/443, 7000-8000/udp, 6443 (home IP only).
- Retry helper if capacity blocks: hitrov/oci-arm-host-capacity (script the instance-create loop).

## ⚠️ Verified 2026-07-06 — the free tier may have SHRUNK

A June-2026 change (reported by users, **silently edited docs, no official announcement**) cuts
always-free A1 from 4 OCPU/24 GB to **2 OCPU/12 GB**; PAYG-upgraded accounts reportedly keep 4/24
plus priority capacity. Single-source + inconsistent Oracle support answers — **check
docs.oracle.com/iaas/Content/FreeTier at signup and correct this note.**
Design consequence: the lab's RAM budget assumes **12 GB** ([[03 Phase 2 — Cluster and Agones]]);
if signup shows 24 GB, everything gets roomier, not tighter. PAYG upgrade (card already on file,
still €0 within free shapes) is the sanctioned fix for both capacity and the bigger shape.
