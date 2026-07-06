---
tags: [tech, orchestration]
---

# Airflow & Astronomer

Reuses what Santi already knows from work (Airflow 3) on a personal stage. One real DAG with a
real purpose: the nightly telemetry → Parquet → [[Databricks]] load.

## Verified 2026-07-06 ([[Free Tier Limits]])

- Astro trial: **14 days AND $20 credit** — the $20 is the real ceiling (~57 h of the smallest
  always-on deployment). No card. **Deployment hard-deleted ~day 17** — export config before day 14.
- No free hosted tier exists. Long-term path: **local Astro CLI** (free, Apache-2.0+Commons-Clause,
  `astro dev start` runs full Airflow in Docker — laptop or the home box, [[Home Server Docker Stack]]).

## Plan (Phase 5)

1. Build the DAG locally first (Astro CLI) — it must not depend on Astro-hosted features.
2. Start the trial → deploy the same DAG → screenshot the hosted experience (that's the
   familiarization goal) → export → back to local before day 14.
3. Instrument the DAG itself with [[OpenTelemetry]] (task duration, failure alerts via
   [[Dynatrace]]) — observing the orchestrator is its own job-offer bullet.
