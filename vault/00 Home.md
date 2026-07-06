---
tags: [moc]
---

# 🏠 Personal Observability Lab

One repo, €0, every job-offer bullet demonstrable. The design lives in `ARCHITECTURE.md` (repo root);
this vault is the **how**. Open the graph view — every note links to what it touches.

## Phases (do them in order)

1. [[01 Phase 0 — Free Tiers and Architecture]] — ✅ done 2026-07-06
2. [[02 Phase 1 — Accounts, Repo, State]] — ⬅️ **you are here**
3. [[03 Phase 2 — Cluster and Agones]]
4. [[04 Phase 3 — OTel and Dynatrace]]
5. [[05 Phase 4 — New Relic and Comparison]]
6. [[06 Phase 5 — Databricks, Airflow, AI]]
7. [[07 Demo Script]] — the on-camera flow everything builds toward

## The stack, by layer

- **Code & CI**: [[Terraform]] · [[GitHub Actions]] · [[HCP Terraform]] (state) · [[Secrets Hygiene]]
- **Cloud & hosting**: [[OCI Always Free]] · [[GitHub Pages]] · ([[Azure Free Account]] — dropped) — limits: [[Free Tier Limits]]
- **Platform**: [[k3s]] · [[Agones]] · [[Game Servers]]
- **Telemetry**: [[OpenTelemetry]] · [[OTel Collector]] (the fan-out heart)
- **Backends**: [[Dynatrace]] ([[Dynatrace SLOs]] · [[Dynatrace Workflows]]) · [[New Relic]] · [[Grafana Cloud]] · [[Elastic Stack]]
- **Load & chaos**: [[k6]] · chaos CronJob (in [[03 Phase 2 — Cluster and Agones]])
- **Analytics & AI**: [[Databricks]] · [[Airflow and Astronomer]] · [[Gemini Chatbot]]
- **Optional second environment**: [[Home Server Docker Stack]] (Plex/*arr — real workloads, strict privacy rules)

## Standing rules

Personal accounts only · Santi pushes all commits · every phase ends with something visibly
monitored · secrets never enter the repo ([[Secrets Hygiene]]) · when a session ends mid-work,
update `HANDOFF-STATE.md` in the repo root.
