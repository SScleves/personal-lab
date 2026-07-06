---
tags: [tech, analytics, cv-keyword]
---

# Databricks

The job-offer keyword made real: telemetry analytics on **Free Edition** (verified 2026-07-06 —
permanent, personal email OK, replaced Community Edition in 2025).

## What free gives / where it bites ([[Free Tier Limits]])

Serverless-only: 1 SQL warehouse (2X-Small), notebooks, dashboards, Unity Catalog **volumes**.
Daily fair-usage compute cutoff (exceed → compute off for the day). Ingest is **file-shaped** —
no streaming endpoint, DBFS unavailable: land Parquet files in a UC volume, then `COPY INTO`/Auto
Loader into Delta tables.

## The pipeline (Phase 5)

1. [[OTel Collector]] file exporter stages telemetry on the cluster.
2. Nightly DAG ([[Airflow and Astronomer]]): roll up → Parquet → upload via Databricks SDK → volume.
3. Delta table + SQL dashboard: player count vs latency vs SLO burn; incident table from
   [[Dynatrace Workflows]] step 4.

This also solves the retention problem — [[Grafana Cloud]] keeps 14 days, [[New Relic]] traces 8;
Databricks is the lab's long memory.
