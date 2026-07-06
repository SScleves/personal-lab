---
tags: [reference, accounts]
---

# ✅ Signup Checklist — every account, one table

Personal accounts ONLY. Card column = whether a credit card is ever seen. Usernames/emails are
deliberately NOT in this public file (they live in the private session memory).

| # | Service | URL | Needed for | Card? | Status 2026-07-06 |
|---|---|---|---|---|---|
| 1 | GitHub (SScleves) | github.com | Repo, CI, Pages, GHCR images | No | ✅ done, repo live |
| 2 | HCP Terraform | app.terraform.io | Remote state + locking | No | 🟡 account made — finish org `sscleves-lab`, workspace `lab`, **Local mode**, token→`TF_API_TOKEN` |
| 3 | OCI | signup.cloud.oracle.com | THE server (A1 ARM, k3s) | Verify-only | ⬜ **next** — quiet region! note A1 shape granted |
| 4 | Dynatrace | (tenant exists) | SLOs, Workflows | No | ✅ free until 2026-10 |
| 5 | Grafana Cloud | grafana.com → free | OTLP backend, k6 results, IRM | No | ⬜ week 3 |
| 6 | New Relic | newrelic.com/signup | Parallel backend, synthetics | No | ⬜ week 4 — set 50 GB guard on day one |
| 7 | Google AI Studio | aistudio.google.com | Gemini free API key (chatbot) | No | ⬜ stretch — plain Google login |
| 8 | Databricks Free Edition | databricks.com/learn/free-edition | Telemetry analytics | No | ⬜ stretch |
| 9 | Astronomer trial | astronomer.io | 14-day managed Airflow taste | No | ⬜ stretch — deleted day ~17, export first |
| 10 | MongoDB Atlas | mongodb.com/cloud/atlas | Game leaderboard (M0 free) | No | ⬜ stretch — ⚠️ verify M0 terms at signup |
| 11 | Groq | console.groq.com | Fallback LLM | No | ⬜ only if Gemini misbehaves |
| 12 | Azure | (account exists) | **Phase 5 AI Foundry trial ONLY** | Yes (done) | ✅ banked — never for infra |
| — | ~~GCP~~ | — | Nothing (Gemini = AI Studio) | — | ❌ rejected |
| — | ~~Elastic Cloud~~ | elastic.co | Optional 14-day familiarization | No | Optional; self-hosted is the real path |

Rule: sign up when the week needs it, not before — fewer live tokens, less standing surface
([[Secrets Hygiene]]). Every service's limits + where-they-bite: [[Free Tier Limits]].
