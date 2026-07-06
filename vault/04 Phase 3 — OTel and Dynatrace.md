---
tags: [phase]
---

# Phase 3 — Telemetry + Dynatrace SLOs/Workflows (effort: HIGH — the learning heart)

Goal: one instrumentation, four backends. [[Dynatrace SLOs]] burn when the chaos job kills a
gameserver; a [[Dynatrace Workflows|Workflow]] fires. Ends visibly monitored: a real alert lands
during a real kill.

## Steps

1. Deploy the [[OTel Collector]] as the gateway: receivers (OTLP, k8s events, hostmetrics,
   filelog for game logs) → processors (k8sattributes, batch, memory_limiter) → exporters:
   Dynatrace OTLP, [[New Relic]] OTLP, [[Grafana Cloud]] OTLP, Elasticsearch.
2. Instrument the game wrapper + Dutch-site chatbot with [[OpenTelemetry]] SDKs; emit the two
   golden game metrics: **tick duration** and **connect latency** (see [[Game Servers]]).
3. `terraform/modules/dynatrace-config`: ingest token, SLOs (tick ≥ target, p95 connect < target,
   chatbot p95), alerting profile, the Workflow (problem → notify + annotate + Agones allocation call).
   All code — the October tenant swap must be a re-apply, nothing manual ([[Dynatrace]]).
4. Trigger: let the chaos CronJob kill during a [[k6]] swarm → SLO burns → problem → Workflow fires. 📸📸
5. Baseline dashboards in Kibana off the same data ([[Elastic Stack]]) for the pipeline-ownership story.

Next: [[05 Phase 4 — New Relic and Comparison]]
