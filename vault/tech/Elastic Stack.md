---
tags: [tech, backend]
---

# Elastic Stack (self-hosted, free Basic)

The "I ran my own pipeline" story: ES + Kibana on the [[k3s]] cluster, fed by the
[[OTel Collector]]. Verified 2026-07-06: free Basic license covers ES, Kibana, OTLP/APM ingest,
and basic alerting — self-hosted, forever (Elastic is AGPL-optioned open source again since 2024).

## RAM reality (why this took design work)

ES 2 GB container/1 GB heap floor + Kibana ~1 GB. Fits the OCI budget only because it was
reserved in [[03 Phase 2 — Cluster and Agones]]. **Logstash JVM wants 4-8 GB → demo-days only**:
spin it up, learn pipelines, tear down. Daily log shipping = Filebeat or the collector's
elasticsearch exporter.

## Known free-tier limits (don't fight them, document them)

- Alert **connectors** on free = write-to-index + server-log only — no email/Slack. The alerts
  that fire live in [[Dynatrace]]/[[New Relic]]/[[Grafana Cloud]]; Kibana shows detection parity instead.
- No ML anomaly detection (paid). OpenSearch alternative has free alerting but same RAM appetite —
  noted, not chosen (Elastic is the CV keyword).

## Elastic Cloud trial (optional familiarization)

14 days, no card, data deleted ~day 44 — the trial-then-self-host pattern:
use it to learn Fleet/managed UX, never depend on it.
