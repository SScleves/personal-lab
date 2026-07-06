---
tags: [tech, reference]
---

# Free Tier Limits — verified 2026-07-06 via live vendor pages

The Phase 0 research table. Re-verify anything here before relying on it after ~2026-Q4.

| Service | Free offer | Expiry | Where it bites |
|---|---|---|---|
| [[Azure Free Account]] | ~~$200/30d + 12-mo + always-free~~ **DROPPED** (signup loop) | — | Research kept for a possible future AI Foundry trial |
| [[HCP Terraform]] | 500 managed resources, state+locking, no card (✅ verified) | Never | Over-cap = blocked runs, not a bill; 1 concurrent run (irrelevant solo) |
| [[GitHub Pages]] | Free static hosting on public repos (✅ verified) | Never | 100 GB/mo soft bandwidth, 1 GB site; static only (chatbot API lives on the cluster) |
| [[OCI Always Free]] | ARM A1: 4 OCPU/24 GB — **possibly cut to 2/12 June 2026 (unofficial)** | Never | Verify shape at signup; capacity scarcity; home region permanent; PAYG upgrade = priority + maybe 4/24 |
| [[Dynatrace]] | Santi's tenant to 2026-10; else 15-day trials | 2026-10 | Tenant deleted 30d post-expiry → all config as [[Terraform]] code; paid standing std workflow ≈$22/mo |
| [[New Relic]] | 100 GB/mo + 1 full user, no card | Never | Overage = full lockout till month end → 50 GB guard; traces ~8d retention |
| [[Grafana Cloud]] | 10k series, 50 GB logs, 50 GB traces, OTLP, IRM, 500 k6 VUh | Never | 14-day retention; series-cap blowouts |
| [[Elastic Stack]] self-hosted | Basic license: ES+Kibana+APM/OTLP+basic alerting | Never | ~8 GB RAM realistic floor; free connectors can't email/Slack; Logstash JVM 4-8 GB |
| Elastic Cloud | 14-day trial, no card | d14; data gone d~44 | Eval only; cheapest paid ~$99/mo |
| [[Databricks]] Free Edition | Permanent, personal email, 2X-Small WH, UC volumes | Never | Daily fair-use compute cutoff; file-shaped ingest only |
| [[Airflow and Astronomer]] | 14 days AND $20 credit | ~d14; deleted d~17 | $20 ≈ 57 h always-on smallest deployment; export before expiry → local Astro CLI |
| [[GitHub Actions]] | Public repos: unlimited minutes + branch protection | Never | Private: 2,000 min/mo, no branch protection on free |
| [[Gemini Chatbot|Gemini API]] | Flash models free, no card | Never | Exact RPM/RPD now dashboard-only (AI Studio); free data may train Google models |
| Groq (fallback LLM) | 30 RPM / 14.4k RPD (8B model), no card | Never | TPM caps on long prompts; model lineup churns |

Flagged as unverified at research time: OCI exact terms (verify at signup) · Dynatrace re-trial
eligibility (community lore) · Azure itemized always-free list (marketing pages fetch-blocked;
Learn pages confirmed the load-bearing numbers).
