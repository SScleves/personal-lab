---
tags: [tech, backend]
---

# Grafana Cloud

The backend that survives everything — free forever, native OTLP, and the eventual home of the
lab's long-running dashboards (it outlives the [[Dynatrace]] October cliff).

## Verified 2026-07-06 ([[Free Tier Limits]])

- 10k active metric series · 50 GB logs · 50 GB traces · 3 users · **14-day retention** · IRM
  (alerting/on-call) included · **500 [[k6]] cloud VUh/month**.
- The cap that bites first: **10k series** — one over-labeled exporter blows it
  (cardinality rules in [[OpenTelemetry]]).
- 14-day retention = no long-term trends; the long-memory story lives in [[Databricks]] instead.

## Setup (Phase 3 exporter, Phase 4 dashboards)

OTLP gateway endpoint + token from the stack's "OpenTelemetry" connection page → k8s secret →
exporter in [[OTel Collector]]. `grafana-cloud` Terraform module manages dashboards-as-code and
one IRM alert route. k6 results stream here for the on-camera load graphs ([[07 Demo Script]]).
