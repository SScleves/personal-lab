---
tags: [tech]
---

# GitHub Actions

CI for the lab, mirroring the work pattern: **plan on PR, apply on main** (`.github/workflows/terraform.yml`)
plus gitleaks on every push (`gitleaks.yml` — [[Secrets Hygiene]]).

## Why the repo is public

Verified 2026-07-06 ([[Free Tier Limits]]): public repos get **unlimited** standard-runner minutes AND
branch protection on the free plan; private repos get 2,000 min/month and **no** branch protection.
Public also = portfolio. Consequence: secrets hygiene is non-negotiable from commit #1.

## Secrets needed (Settings → Secrets → Actions)

Phase 1: `ARM_CLIENT_ID/SECRET/TENANT_ID/SUBSCRIPTION_ID` (Azure service principal).
Phase 2: OCI auth. Phase 3+: `DYNATRACE_API_TOKEN`, `NEW_RELIC_API_KEY`, `GRAFANA_CLOUD_TOKEN`.
Add per phase, never earlier — least privilege, least standing surface.
