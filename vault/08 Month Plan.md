---
tags: [plan, moc]
---

# 🗓️ The Month Plan — 4 weeks + stretch, every tech with exercises

Each week ends with something **visibly monitored** (the standing rule). Effort dial per week noted.
This is the schedule + exercises; **execution happens via the micro-step runbooks** —
[[R1 Week 1 — OCI account, server, k3s|R1]] · [[R2 Week 2 — Docker, Agones, chaos|R2]] ·
[[R3 Week 3 — OTel fan-out, Dynatrace SLOs, Workflow|R3]] · [[R4 Week 4 — New Relic, Grafana, the comparison|R4]] ·
[[R5 Stretch — Databricks, Airflow, Gemini, AI Foundry|R5]] — under the rules in `GUARDRAILS.md`.
Signups: [[09 Signup Checklist]].

## Week 1 — Foundations: accounts, state, THE SERVER (effort: low, one design evening)

**Goal:** `terraform apply` creates the OCI VM; k3s answers `kubectl get nodes` from the laptop.

1. Finish [[HCP Terraform]] (org `sscleves-lab`, workspace `lab`, **Local** mode, token →
   `TF_API_TOKEN`) → uncomment `cloud {}` in `backend.tf` → `terraform init` ✅ green.
2. OCI signup ([[OCI Always Free]] — quiet region, note the A1 shape granted!).
3. Write + apply `terraform/modules/oci-cluster`: VCN, security list (22/tcp home-IP,
   80/443/tcp, 7000-8000/udp, 6443/tcp home-IP), A1 VM, cloud-init installs [[k3s]].
4. Server bring-up drill: SSH in → `sudo systemctl status k3s` → copy kubeconfig to laptop
   (NEVER the repo) → `kubectl get nodes` → 📸.
5. Dutch-lessons site → [[GitHub Pages]] (Phase 1 step D) — first workload live.

**Exercises** — [[Terraform]]: `terraform state list/show`, then the confidence drill:
`terraform destroy` the VM and re-apply it (cattle, not pets — same drill the October
Dynatrace swap needs). [[k3s]]: deploy nginx, expose it, curl it from home, delete it.

## Week 2 — Kubernetes for real: Docker, Agones, chaos (effort: medium/high — the build week)

**Goal:** the agar.io fleet self-heals on camera; chaos runs on a schedule. ([[03 Phase 2 — Cluster and Agones]])

1. [[Docker]] exercises FIRST (they gate everything): build the agar.io-clone image **arm64**
   via buildx, push to GHCR, run it on the cluster as a plain pod.
2. Install [[Agones]] (Helm, pinned) → `simple-game-server` smoke test → real Fleet +
   FleetAutoscaler ([[Game Servers]]).
3. Chaos CronJob live. Play the game from two browsers while it kills a pod. 📸
4. [[Elastic Stack]] onto the cluster (ES + Kibana, RAM-budgeted).

**Exercises** — [[Agones]]: scale Fleet 2→5→2 by editing the manifest via PR (pipeline does it);
`kubectl delete pod` an ALLOCATED gameserver vs a READY one — observe the difference. [[k3s]]:
drain/uncordon the node; find where k3s logs live. [[Docker]]: shrink the game image (multi-stage,
alpine) — measure before/after.

## Week 3 — Telemetry + Dynatrace: the learning heart (effort: HIGH, don't rush it)

**Goal:** kill a gameserver → Dynatrace problem → Workflow fires → SLO burn visible. ([[04 Phase 3 — OTel and Dynatrace]])

1. [[OTel Collector]] gateway with fan-out (Dynatrace + [[Grafana Cloud]] first; New Relic joins W4).
2. Instrument the game ([[OpenTelemetry]]): tick duration, WS RTT, player count.
3. `dynatrace-config` module: SLOs + alerting profile + the Workflow ([[Dynatrace SLOs]],
   [[Dynatrace Workflows]]).
4. The full loop on camera, alert on the phone. 📸📸

**Exercises** — [[Dynatrace]]: write 5 DQL queries (worst tick p99 per pod; players vs latency
correlation…); break the SLO on purpose with [[k6]], watch the burn rate; the **October drill**:
delete one SLO in the UI, re-apply from Terraform, confirm drift-free plan. [[Elastic Stack]]:
same incident found via Kibana query; one Lens dashboard. [[OTel Collector]]: add the `debug`
exporter, watch a span leave the game and arrive in two backends.

## Week 4 — The comparison + load: New Relic, k6, the demo (setup low, comparison-doc high)

**Goal:** same incident in 4 backends; [[07 Demo Script]] rehearsed start-to-finish. ([[05 Phase 4 — New Relic and Comparison]])

1. [[New Relic]] signup + OTLP exporter + **50 GB guard first** + synthetics pings on the site.
2. [[k6]] player swarm (WS script, ramping VUs) → FleetAutoscaler scales on camera; results → Grafana.
3. Parity dashboards; write the vendor-comparison doc (DQL vs NRQL vs PromQL/LogQL vs KQL).
4. Full demo rehearsal. Record a backup run.

**Exercises** — [[New Relic]]: rebuild 3 of your DQL queries in NRQL; force a drop rule and prove
data stops. [[k6]]: find the fleet's breaking point — the VU count where tick p95 crosses the SLO;
that number goes in the comparison doc. [[Grafana Cloud]]: annotate the chaos kill from the
Dynatrace Workflow webhook.

## Stretch week(s) — analytics, AI, and the extras ([[06 Phase 5 — Databricks, Airflow, AI]])

- [[Databricks]]: telemetry Parquet → volume → Delta → SQL dashboard (exercise: player-count vs
  latency vs SLO-burn in one query).
- [[Airflow and Astronomer]]: DAG locally → Astro trial 14 days → back to local (exercise:
  make the DAG idempotent — rerun yesterday safely).
- [[Gemini Chatbot]] on the site + OTel spans per LLM call (exercise: a token-per-day metric and
  an SLO on p95 latency). Then the **Azure AI Foundry trial** on the banked account — same bot,
  second AI platform, comparison notes ([[Azure Free Account]]).
- [[MongoDB Atlas]]: leaderboard for the game on M0 free (exercise: monitor Atlas metrics into
  the fan-out — database observability story).
- [[Home Server Docker Stack]]: one collector container in the compose stack → Plex/*arr metrics
  in the same dashboards (exercise: alert on disk pressure before the disk fills).
- Your two laptop games + website ideas: if either game can run headless in a container, it can
  join the fleet as workload #2 — same pattern, zero new concepts ([[Game Servers]]).

## Definition of done for the month

The [[07 Demo Script]] runs end-to-end without improvisation · every [[Dynatrace SLOs|SLO]] and
[[Dynatrace Workflows|Workflow]] is Terraform · the comparison doc exists with real screenshots ·
`terraform destroy && terraform apply` rebuilds the estate · every job-offer bullet has its
artifact (mapping table in `ARCHITECTURE.md`).
