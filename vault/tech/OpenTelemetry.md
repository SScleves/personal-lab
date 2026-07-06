---
tags: [tech, telemetry]
---

# OpenTelemetry

The vendor-neutral instrumentation layer — the reason four backends cost one integration effort.
SDKs in the workloads emit OTLP → the [[OTel Collector]] fans out.

## What gets instrumented (Phase 3)

| Workload | Signals | The metrics that matter |
|---|---|---|
| agar.io-clone server ([[Game Servers]]) | traces, metrics, logs | `game.tick.duration`, `game.ws.rtt`, `game.players.active` |
| [[Gemini Chatbot]] | traces (span per LLM call), metrics | model, token counts, latency, error class — the AI-observability story |
| [[k3s]] cluster | k8s events, kubelet/host metrics | pod restarts (the chaos signal), node saturation |
| Dutch-lessons site ([[GitHub Pages]]) | HTTP probes | availability, TTFB ([[New Relic]] synthetic pings) |

## Conventions (the "standards" job bullet — decide once, enforce in code review)

- Resource attributes on everything: `service.name`, `service.version`, `deployment.environment=lab`.
- Metric names: `game.*` namespace, seconds/base units, low-cardinality labels
  (a runaway label blows [[Grafana Cloud]]'s 10k-series cap first).
- Node SDK for the game (auto-instrumentation + manual spans around the tick loop).

Backends: [[Dynatrace]] · [[New Relic]] · [[Grafana Cloud]] · [[Elastic Stack]] — all take OTLP.
