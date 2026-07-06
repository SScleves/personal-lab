---
tags: [phase]
---

# Phase 4 — New Relic parallel + vendor comparison (setup LOW, comparison doc HIGH)

Goal: same incident visible in [[Dynatrace]], [[New Relic]], [[Grafana Cloud]] and Kibana —
then write the comparison doc (interview gold). Ends visibly monitored: New Relic emails an alert
for the same kill Dynatrace caught.

## Steps

1. New Relic signup (free forever, no card) → OTLP license key → add exporter to the [[OTel Collector]]. Done —
   that's the whole "setup" (the fan-out design pays off here).
2. `terraform/modules/newrelic-config` FIRST JOB: drop rules + **ingest alert at 50 GB** —
   free tier hard-locks the whole UI if 100 GB is crossed ([[Free Tier Limits]]).
3. Parity dashboards: rebuild the two SLO views in New Relic and [[Grafana Cloud]].
4. Run [[07 Demo Script]] once; screenshot the same problem in all four backends
   (New Relic keeps traces only ~8 days — screenshot immediately).
5. The comparison doc: detection speed, problem-correlation quality, query language ergonomics
   (DQL vs NRQL vs LogQL/PromQL vs KQL), SLO modeling, alert routing, pricing model. One page per theme.
