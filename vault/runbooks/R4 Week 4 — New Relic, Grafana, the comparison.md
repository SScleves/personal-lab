---
tags: [runbook, week4]
---

# R4 · Week 4 — same telemetry, three more backends, the comparison doc

Pre-flight: R3 green (Dynatrace SLO burned and recovered on camera).

## A. New Relic — guard rails BEFORE data

1. **[SANTI]** https://newrelic.com/signup — free, no card, **choose EU data center** (the
   region mismatch is the #1 silent failure — [[New Relic]]).
2. **[SANTI]** Copy the **license key** (ingest) → temp-file handover → k8s secret `nr-ingest`.
3. Collector: add exporter otlphttp/newrelic → endpoint `https://otlp.eu01.nr-data.net:4318`
   (**[VERIFY-FIRST]** confirm this endpoint on the account's own OTLP setup page — match region),
   header `api-key` → apply → collector logs clean.
4. Verify data **[SANTI]**: NR → Metrics explorer → `game_tick_duration_ms` filtered by
   `deployment.environment = lab`. 📸
5. **THE GUARD, before anything else**: `terraform/modules/newrelic-config` —
   (**[VERIFY-FIRST]** current newrelic provider resource names) NRQL drop rule for chatty
   k8s debug logs + alert condition on daily ingest ≈ >1.6 GB/day (≈50 GB/mo pace) → email.
   Plan → apply → see both in UI. **[GATE]** — no dashboards until the guard exists.
6. Synthetics: ping monitors (ping ONLY — 500 non-ping checks/mo trap) on the three live
   sites + the game's TCP status endpoint if exposed.

## B. Grafana Cloud

7. **[SANTI]** grafana.com → free account → stack → "OpenTelemetry" connection page →
   copy OTLP endpoint + instance-id + token → k8s secret.
8. Collector: exporter #3 (otlphttp, basic-auth header per their page) → apply → verify in
   Grafana Explore (`game_tick_duration_ms`). 📸
9. Watch the series count for a day: Billing/Usage → active series must stay ≪10k
   (cardinality guardrail).
10. k6 → Grafana: rerun the R3 swarm with `-o experimental-prometheus-rw` or k6 cloud output
    (**[VERIFY-FIRST]** current flag; 500 VUh/mo included) → load graphs land in Grafana.

## C. Elastic on-cluster (already installed in R2 world? if not: single-node ES+Kibana now)

11. Collector exporter #4: elasticsearch (logs) → Kibana Discover shows game + chaos logs.
    Free-tier reality check: alert CONNECTORS can't email ([[Elastic Stack]]) — detection
    parity only, and that's the honest comparison point.

## D. The comparison doc (the deliverable interviews love)

12. Run [[07 Demo Script]] once end-to-end; capture the SAME incident in all four UIs. 📸×4
13. Write `vault/Vendor Comparison.md`, one page per theme: time-to-detect (measured!) ·
    problem correlation quality · query languages (DQL vs NRQL vs PromQL/LogQL vs KQL — the
    same three questions answered in each) · SLO modelling · alert routing · pricing model +
    where each free tier bites ([[Free Tier Limits]]) · "which would I deploy at a client and why".
14. **Week 4 done** = demo rehearsed + comparison doc committed. Close-out per protocol.

**Do NOT**: browser/scripted synthetics (500/mo trap) · dashboards before the NR ingest guard ·
high-cardinality labels (10k series wall) · trust any endpoint region without checking the
account's own setup page.
