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
┌─ AZURE free account (work-mirror) ──────────┐   ┌─ OCI always-free ARM (the muscle) ─────────┐
│ · Blob container → Terraform remote state   │   │ 1× Ampere A1 VM (4 vCPU / 24 GB / 200 GB)  │
│ · Static hosting → Dutch-lessons site       │   │ └ k3s single node                          │
│    └ chatbot API → Gemini free (Groq fbk)   │   │    ├ Agones (controller + fleet CRDs)      │
│ · 1× free B-series VM (1 GiB): synthetic    │   │    │  └ GameServer fleet (Minecraft-class) │
│   probe box pinging the game + site         │   │    ├ chaos CronJob (kill gameserver pods)  │
└─────────────────────────────────────────────┘   │    ├ OTel Collector gateway (fan-out)      │
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
| Compute home | **OCI always-free A1** (24 GB) | Only €0 host big enough for Agones + game server + ELK. Azure free VMs are ~1 GiB. Never expires. |
| Azure's role | State, static site, probe VM | Mirrors the work pattern (remote state, RG structure) — the pedagogy — without needing RAM. |
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
| Azure month 12 | Free VM hours, blob free quota | tfstate costs <$0.05/mo; probe VM off; site → GitHub Pages. **Calendar reminder month 11 — after PAYG upgrade the VM bills silently in month 13.** |
| Never | OCI A1, New Relic 100 GB, Grafana Cloud, Databricks Free Edition, Elastic Basic self-hosted, GitHub, Gemini free | — |

## €0 verification

Azure: only free-eligible SKUs, created via the portal "Free services" flow, `smalldisk` image, one VM ≤750 h.
OCI: single A1 within 4 OCPU/24 GB always-free shape; no paid services enabled. New Relic: hard-stops (no card
on file, cannot bill); drop-rule + alert at 50 GB. Grafana/Databricks/Gemini/Groq: no card required at all.
Astronomer trial: no card — expiry = deletion, not billing. Elastic: self-hosted Basic license, $0.
The only card that exists anywhere is the Azure/OCI signup verification — both accounts stay inside
always-free/free-tier boundaries and Azure does not auto-charge until explicitly upgraded to PAYG.

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
