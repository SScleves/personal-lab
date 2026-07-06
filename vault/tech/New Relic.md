---
tags: [tech, backend]
---

# New Relic

The standing free backend (forever, no card) and the vendor-comparison counterpart to [[Dynatrace]].

## Verified 2026-07-06 ([[Free Tier Limits]])

- 100 GB ingest/month + 1 Full Platform user + unlimited basic users. APM, logs, k8s, dashboards,
  synthetics, email alerts all included.
- **Overage = hard lockout** of the whole platform until the 1st of next month (no bill — no card
  on file). A runaway debug-log loop locks you out mid-demo-prep.
- Trace retention ~8 days → screenshot demo evidence immediately.

## Setup order (Phase 4 — deliberately after the guard rails exist)

1. OTLP exporter in the [[OTel Collector]] (`otlp.nr-data.net`, license key via k8s secret).
2. `newrelic-config` module ([[Terraform]]): NRQL drop rules for chatty k8s namespaces +
   **ingest alert at 50 GB** — before any dashboard work.
3. Parity dashboards mirroring the [[Dynatrace SLOs]] views → raw material for the comparison doc
   ([[05 Phase 4 — New Relic and Comparison]]).
