---
tags: [phase, done]
---

# Phase 0 — Free tiers & architecture ✅ (2026-07-06)

Every free tier was verified against live vendor pages — numbers and sources in [[Free Tier Limits]].
The architecture (components, data flow, what-dies-when, €0 proof) is `ARCHITECTURE.md` in the repo root.

## The three findings that shaped the design

1. **[[Dynatrace]] has no free tier** — but Santi's tenant is free until **2026-10**, so the lab has a
   3-month runway. Insurance: every tenant config is [[Terraform]] code, so a fresh trial tenant is a
   ~10-minute re-apply.
2. **[[Azure Free Account]] VMs are ~1 GiB RAM** — too small for [[k3s]] + [[Agones]] + [[Elastic Stack]].
   Hence [[OCI Always Free]] (4 vCPU / 24 GB, never expires) hosts the cluster; Azure keeps the
   work-mirror jobs: remote state, the Dutch-lessons site, a tiny probe VM.
3. **Trial-then-fallback is the pattern** for anything without a free tier: [[Airflow and Astronomer]]
   (14 days → local Astro CLI), Elastic Cloud (14 days → self-hosted Basic on the cluster).

## Decisions locked

Public GitHub repo · OCI for compute · Logstash demo-only ([[Elastic Stack]]) ·
[[Gemini Chatbot]] on Gemini free tier with Groq fallback · alerts that actually fire live in
[[Dynatrace]], [[New Relic]] (email) and [[Grafana Cloud]] IRM — not Kibana (free connectors can't notify).
