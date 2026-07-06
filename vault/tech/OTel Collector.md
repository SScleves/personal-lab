---
tags: [tech, telemetry]
---

# OTel Collector

The fan-out heart: one deployment on [[k3s]], receiving everything, exporting everywhere.
Kill this pod and ALL backends go dark — which is itself a good demo of pipeline observability
(monitor the collector's own metrics).

## Pipeline sketch (Phase 3, contrib distribution — arm64 images exist)

```yaml
receivers:  otlp (grpc+http) · k8s_events · kubeletstats · hostmetrics · filelog (game logs)
processors: memory_limiter · k8sattributes · resource (env=lab) · batch
exporters:  otlphttp/dynatrace   → [[Dynatrace]]  (token via k8s secret)
            otlphttp/newrelic    → [[New Relic]]
            otlphttp/grafana     → [[Grafana Cloud]]
            elasticsearch        → [[Elastic Stack]] (local, free Basic)
            file/parquet-staging → nightly [[Databricks]] export ([[Airflow and Astronomer]])
```

## Rules

- `memory_limiter` FIRST in every pipeline (~300 MB cap — the RAM budget in
  [[03 Phase 2 — Cluster and Agones]] depends on it).
- Backend tokens live in k8s secrets created by [[Terraform]], never in the committed collector
  config ([[Secrets Hygiene]]).
- One backend down must not block the others: per-exporter sending queues + retry on their own.
