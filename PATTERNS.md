# PATTERNS.md — the lab's pattern, applied to everything you own

The lab isn't really about a game server. It's ONE reusable pattern:

> **workload → OpenTelemetry signals → one collector fanning out → backends → an SLO that
> means something → an alert that fires → config as code → a runbook with do→verify steps.**

Learn it once on the game; apply it to anything. Here's the mapping for everything in the estate —
and the checklist for whatever you build next.

## The same five questions, every time

1. **What's the workload?** (a process, a container, a website, a pipeline)
2. **What are its 2-3 signals that MEAN something?** (not "all metrics" — the ones a user feels)
3. **How do signals leave it?** (SDK spans/metrics · container/host stats · logs · or just an
   external probe if you can't touch it)
4. **What's the SLO sentence?** "95% of X under Y over Z days" — if you can't say it, you don't
   understand the workload yet.
5. **Where does its config-as-code live, and which runbook builds it?**

## Applied to the estate

| Workload | Signals that matter | How they leave | SLO sentence | Where |
|---|---|---|---|---|
| **Game fleet** (agar.io/Minecraft) | tick duration, WS RTT, players | OTel SDK in the server loop | p95 tick < 50 ms, 99%/7d | Runbooks R2-R3 |
| **Media stack** (Plex/*arr/qbit) | container restarts, disk %, transcode CPU | docker_stats + hostmetrics receivers — no code changes to the apps | disk < 85%, zero unnoticed restarts | HOME-SERVER-MISSION |
| **Websites** (thetruth, dutch-lessons) | availability, TTFB, JS errors | outside-in: NR ping synthetics + Browser RUM — you don't instrument static HTML, you observe around it | 99.9% availability/30d | R4 + vault/tech/Frontend RUM |
| **Notes app** (werkplek) | route-change latency, JS errors, (later) sync failures | Browser RUM; Supabase metrics when sync returns | p95 route change < 200 ms | vault/tech/Frontend RUM |
| **Pipelines** (Airflow DAG, chatbot LLM calls) | task duration, failure count, tokens, LLM p95 | OTel spans around each unit of work | nightly DAG success by 07:00, 95% | R5 |

The three columns that change per workload: signals, transport, SLO. The collector, the
backends, the as-code rule, and the runbook FORMAT never change. That's the transferable skill —
and the interview answer: *"same pattern, five very different workloads."*

## Adapting to something brand new (the 10-minute recipe)

1. Answer the five questions above in writing (a new `vault/tech/<thing>.md`).
2. Pick transport: can touch the code → OTel SDK · container only → docker_stats/filelog ·
   can't touch anything → synthetics/RUM from outside.
3. Add ONE exporter route in the existing collector (never a new pipeline stack per workload).
4. Write the SLO as Terraform in `dynatrace-config` (+ NR parity if it matters).
5. Copy a runbook's skeleton (pre-flight → micro-steps with verifies → failure table → Do NOT),
   fill it for the new thing. GUARDRAILS.md applies unchanged.
