# Architecture — personal observability lab

*Written 2026-07-06. Free-tier numbers verified against live vendor pages that day (details + sources: `vault/tech/Free Tier Limits.md`). Cost target: €0, hard.*

## Purpose

Every bullet of the target job offer (Observability Specialist — Dynatrace, AI observability, Databricks,
AI Foundry, dashboards/alerting/standards) maps to a demonstrable artifact in this lab. See "Job-offer
mapping" below.

## Components

```
            GitHub (PUBLIC repo · Actions: gitleaks always, tf plan on PR, tf apply on main)
                                        │ terraform
              ┌─────────────────────────┴──────────────────────────┐
              ▼                                                    ▼
┌─ No-cloud services (all free forever) ──────┐   ┌─ OCI always-free ARM (the muscle) ─────────┐
│ · HCP Terraform → remote state + locking    │   │ 1× Ampere A1 VM (design assumes 2/12,      │
│ · GitHub Pages → Dutch-lessons site         │   │   hope for 4 OCPU/24 GB — verify at signup)│
│    └ chatbot API → Gemini free (Groq fbk)   │   │ └ k3s single node                          │
│ · New Relic synthetics → uptime probes      │   │    ├ Agones (controller + fleet CRDs)      │
│   (site + game endpoints, ping monitors)    │   │    │  └ GameServer fleet (agar.io / MC)    │
└─────────────────────────────────────────────┘   │    ├ chaos CronJob (kill gameserver pods)  │
                                                  │    ├ OTel Collector gateway (fan-out)      │
                                                  │    ├ Elasticsearch + Kibana (free Basic)   │
                                                  │    └ k6 jobs (player-swarm load tests)     │
                                                  └───────────────┬────────────────────────────┘
                     OTel Collector fan-out — same data, four backends:
                     ├─→ Dynatrace tenant       (free until 2026-10 · SLOs on tick/latency ·
                     │                           Workflows · ALL config in Terraform)
                     ├─→ New Relic free         (standing APM/logs/k8s · email alert · 50 GB guard)
                     ├─→ Grafana Cloud free     (standing OTLP backend · k6 cloud results · IRM)
                     └─→ Elasticsearch (local)  (self-run log/trace pipeline story)

                     Nightly Airflow DAG (Astronomer 14-day trial → local Astro CLI):
                     telemetry → Parquet → Databricks Free Edition volume → SQL dashboards
```

## The demo storyline (what runs on camera)

1. `terraform apply` provisions cluster, Agones fleet, and every Dynatrace SLO/Workflow — config as code.
2. k6 swarm joins as fake players → FleetAutoscaler scales the lobby fleet up.
3. Chaos job kills a game-server pod mid-session.
4. Dynatrace SLO (tick rate / latency) burns → problem opens → **Workflow fires** (notify + annotate + call
   the Agones allocation API). Agones has already replaced the pod; the workflow proves detection-to-action.
5. Players reconnect, SLO recovers. Same incident visible side-by-side in New Relic, Grafana, Kibana.

## Key design decisions

| Decision | Choice | Why |
|---|---|---|
| Compute home | **OCI always-free A1** | Only €0 host big enough for Agones + game server + ELK. Never expires. |
| Azure | **DROPPED 2026-07-06** | Signup impossible (gmail/GitHub Microsoft-identity loop). Replaced by: HCP Terraform (state), GitHub Pages (site), New Relic synthetics (probes). Cost of the drop: the hands-on-Azure garnish for the AI Foundry bullet — recoverable later via a standalone Azure AI Foundry trial if an account ever works. |
| Kubernetes | k3s, not AKS | AKS control plane is free but nodes are paid VMs. k3s on the free VM = only true €0 k8s. |
| Repo visibility | **Public** | Unlimited Actions minutes, branch protection on free plan, portfolio piece. Gitleaks from commit #1. |
| Dynatrace | Existing tenant (free until **2026-10**) | 3-month runway, no trial churn. All config via Terraform provider so a future tenant is a ~10-min re-apply. |
| Log pipeline | ES + Kibana + Filebeat/OTel; Logstash demo-only | Logstash JVM wants 4–8 GB — runs only for short familiarization demos. |
| Alerts that fire | Dynatrace, New Relic (email), Grafana IRM | Kibana free connectors are index/server-log only — known limit, documented not fought. |
| LLM | Gemini Flash free tier (Groq fallback) | No card, no expiry; OpenAI-compatible fallback keeps OTel instrumentation identical. |

## What dies when — and the fallback

| Date | What expires | Fallback |
|---|---|---|
| Day 14 (Astronomer signup +14) | Astro trial ($20 credit likely first) | Local Astro CLI (free, Docker) — export deployment config before day 14; hard-deleted day ~17 |
| **2026-10** | Dynatrace tenant | New 15-day trials (config re-applied by Terraform in minutes) or Playground for UI-only practice |
| Never | OCI A1, New Relic 100 GB, Grafana Cloud, Databricks Free Edition, Elastic Basic self-hosted, GitHub + Pages, HCP Terraform free, Gemini free | — |

## €0 verification

OCI: single A1 within the always-free shape; no paid services enabled. New Relic: hard-stops (no card
on file, cannot bill); drop-rule + alert at 50 GB. HCP Terraform: free tier, no card (lab is a handful of
resources, nowhere near the cap). GitHub Pages: free on the public repo. Grafana/Databricks/Gemini/Groq:
no card required at all. Astronomer trial: no card — expiry = deletion, not billing. Elastic: self-hosted
Basic license, $0. The only card anywhere is OCI's signup verification — the account stays inside
always-free boundaries.

## Job-offer mapping

| Job bullet | Lab artifact |
|---|---|
| 5+ yrs Dynatrace hands-on, SLOs, alerting | SLOs on tick rate/latency, Workflows, problem detection — all as Terraform |
| AI observability / AI Foundry | Gemini chatbot on Dutch-lessons site, every LLM call wrapped in OTel spans (tokens, latency, errors) |
| Databricks | Telemetry Parquet → UC volume → SQL dashboards on Free Edition |
| Cloud-native, Kubernetes | k3s + **Agones** fleet orchestration + FleetAutoscaler |
| Standards for monitoring/tagging/logging | The Terraform modules themselves — naming, tagging, one pattern per backend |
| Dashboards, telemetry → business insight | New Relic + Grafana + Kibana on identical data; player-count vs latency analysis |
| Vendor breadth | Four-backend comparison doc from one instrumentation |

## Open risks (updated after Agones/OCI verification, 2026-07-06)

- **OCI free tier may have shrunk (June 2026, unofficial)**: always-free A1 reportedly cut from
  4 OCPU/24 GB to 2 OCPU/12 GB; PAYG-upgraded accounts reportedly keep 4/24 + priority capacity.
  Design assumes **12 GB**; verify at signup. Capacity scarcity persists — quiet home region, retries,
  or PAYG upgrade (still €0 within free shapes).
- **Agones on arm64 is Alpha-tier** (amd64 is Stable): pin v1.59.0, smoke-test with the
  simple-game-server example (guaranteed arm64), upgrade deliberately. k3s is community-proven
  but unofficial.
- **Game choice locked by verification**: agar.io-clone (Node/WebSocket) = MVP fleet — arm64-native
  and k6 can swarm it natively; Minecraft **Java** (itzg multi-arch) = recognizable demo extra;
  Bedrock (x86-only) and the Xonotic/STK example images (arm64 unverified) are out.
- k6 has no UDP: WebSocket game = native k6; Minecraft load = bot library, k6 probes its TCP status port.
- UDP 7000-8000 must be opened in BOTH the OCI security list and host iptables (Oracle images ship
  restrictive rules) — the #1 reported Agones-on-cloud failure.
- Dynatrace re-trial eligibility after October is community lore, not published policy.
- Optional extension: the home Docker media stack (Plex/*arr) as a second observed environment —
  egress-only telemetry, nothing about the home network in this public repo.
