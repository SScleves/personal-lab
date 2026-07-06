---
tags: [tech, backend]
---

# Dynatrace

The primary backend and the primary learning target: [[Dynatrace SLOs]] + [[Dynatrace Workflows]].

## Tenant situation (the fact that shapes everything)

- Santi's personal tenant is **free until 2026-10** — the whole build window fits inside it.
- Verified 2026-07-06: after any tenant expires, UI/ingest block immediately and the tenant is
  **permanently deleted 30 days later**. No free tier, no self-serve cheap plan exists for individuals.
- Therefore: **the tenant is cattle, not a pet.** Every SLO, workflow, alerting profile, tag rule
  and token lives in `terraform/modules/dynatrace-config` ([[Terraform]]). Post-October: new 15-day
  trial → re-apply → back in ~10 minutes. Rehearse the drill once before October.

## Ingest (Phase 3)

OTLP from the [[OTel Collector]]: `https://<env>.live.dynatrace.com/api/v2/otlp` — token with
`openTelemetryTrace.ingest`, `metrics.ingest`, `logs.ingest` scopes, minted in the tenant,
stored as k8s secret via Terraform ([[Secrets Hygiene]]).
Optional later: OneAgent-operator for the deep k8s view — heavier; start OTLP-only.

## Cost awareness (matters post-October or on any paid tenant)

On paid DPS a **standing "standard" workflow bills ~$22/month just for existing**; "simple"
workflows (single trigger+action) are free apart from per-invocation pennies. Design lab
workflows as simple where possible; create/delete standard ones around demos.
