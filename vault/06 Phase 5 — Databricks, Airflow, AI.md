---
tags: [phase]
---

# Phase 5 — Databricks, Airflow, AI extras (effort: MEDIUM)

Goal: the three job-offer differentiators. Ends visibly monitored: a Databricks dashboard over
real lab telemetry, refreshed nightly by an Airflow DAG, and every chatbot LLM call traced.

## Steps

1. **[[Databricks]]** Free Edition signup (personal email, permanent) → create a Unity Catalog volume.
2. Export job: telemetry → Parquet (start dumb: a k8s CronJob on the cluster writing daily Parquet
   from the [[OTel Collector]]'s file exporter, uploaded via Databricks SDK).
3. **[[Airflow and Astronomer]]**: start the 14-day Astro trial → build the DAG properly there
   (the export from step 2 becomes the DAG) → before day 14 export config → continue on local Astro CLI.
4. Databricks SQL: player-count vs latency vs SLO-burn analysis; one dashboard. 📸
5. **[[Gemini Chatbot]]** on the Dutch-lessons site: wrap every LLM call in [[OpenTelemetry]] spans
   (model, tokens, latency, error) → the "AI observability" interview story with real traces to show.
