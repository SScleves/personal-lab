---
tags: [runbook, week3]
---

# R3 · Week 3 — one instrumentation, Dynatrace SLOs that burn, a Workflow that fires

The learning heart. Slow is fine; skipping verifies is not. Pre-flight: R2 green
(fleet self-heals) · Dynatrace tenant reachable **[SANTI]** (fjl36225…dynatracelabs.com).

## A. Tenant credentials, scoped — never full-access

1. **[SANTI]** In the tenant: search "Access tokens" → Generate new token → name `lab-otel-ingest`,
   scopes EXACTLY: `metrics.ingest`, `logs.ingest`, `openTelemetryTrace.ingest` → copy once.
2. **[SANTI]** Hand it over the standard way: save to `$env:TEMP\dt_lab_token.txt`; Claude reads
   it into a k8s secret, never echoes it, deletes the file after.
3. **[VERIFY-FIRST]** The OTLP endpoint: in the tenant, search "OpenTelemetry" / open the
   OTLP ingest docs page INSIDE the tenant UI — copy the exact endpoint it shows for this
   sprint-class environment. Do not guess the URL shape.
4. `kubectl create secret generic dt-ingest --from-literal=endpoint=<…> --from-literal=token=<…>`
   → verify `kubectl get secret dt-ingest` → delete the temp file.

## B. Collector gateway, debug-first

5. Claude writes `k8s/otel-collector.yaml` (contrib image, **[VERIFY-FIRST]** current version
   tag + confirm arm64 manifest): receivers otlp(grpc+http) + k8s_events + kubeletstats;
   processors memory_limiter(256Mi) → k8sattributes → resource(env=lab) → batch;
   exporters: **debug only** for now.
6. Apply → `kubectl logs deploy/otel-collector` clean start, no errors.
7. Add the Dynatrace exporter (otlphttp, endpoint+token from the secret via env) → apply →
   logs show export success (no 401/404 — if 401: token scopes; if 404: endpoint shape, step 3).
8. Verify in tenant **[SANTI]**: Metrics browser → search `k8s.` — kubeletstats metrics arriving. 📸

## C. Instrument the game (the real skill)

9. In the agario-lab fork: `npm install @opentelemetry/sdk-node @opentelemetry/auto-instrumentations-node @opentelemetry/exporter-trace-otlp-http @opentelemetry/exporter-metrics-otlp-http`
   (**[VERIFY-FIRST]** current package names/majors — the JS SDK renames things).
10. Add `tracing.js` (NodeSDK, OTLP → collector service DNS `http://otel-collector:4318`),
    require it first in the start command.
11. Manual metrics in the server loop — the two that matter:
    `game_tick_duration_ms` (histogram, per tick) and `game_players_active` (gauge) +
    `game_ws_rtt_ms` if the clone exposes ping handling. Resource attrs: `service.name=agario`.
12. Rebuild image 0.2.0 (arm64!, R2 step 3 pattern) → bump Fleet → verify in tenant:
    Metrics browser → `game_tick_duration_ms` exists. 📸 **[GATE]** — no SLOs until this is real data.

## D. SLOs + alerting, as code only

13. Claude writes in `terraform/modules/dynatrace-config`: provider auth via env
    (`DYNATRACE_ENV_URL`, `DYNATRACE_API_TOKEN` — **[SANTI]** mint a second token
    `lab-terraform` with settings/SLO write scopes — **[VERIFY-FIRST]** exact scope names the
    provider docs require for `dynatrace_slo_v2` + workflows).
14. Resources: SLO "Game tick health" (p95 tick < 50ms, 99% over 7d) + SLO "Players can
    connect" + alerting profile + a **simple-class** workflow: problem → email **[SANTI's
    address as tfvar, gitignored]**.
15. `terraform plan` → adds only → apply → **[SANTI]** see both SLOs in the tenant UI. 📸
16. The drill that makes October safe: delete ONE SLO in the UI → `terraform plan` shows
    1 add (drift detected) → `apply` restores it. Config-as-code proven.

## E. Make it burn, make it fire

17. k6 from the laptop (`k6 run swarm.js` — Claude writes a WS script ramping 0→50 VUs) while
    the chaos CronJob kills a gameserver mid-swarm.
18. Watch: SLO error budget burns → problem opens → workflow fires → email lands on the phone.
    📸📸 (SLO burn-down + the notification). **Week 3 done.**
19. Close-out per protocol. Also: export/screenshot evidence NOW (trace retention is short).

**Do NOT**: create standing "standard"-class workflows (cost trap on paid DPS — [[Dynatrace Workflows]]) ·
configure ANYTHING in the tenant UI except tokens (rule 8 of GUARDRAILS) · let the collector
run without memory_limiter · add high-cardinality labels (player-id!) to metrics.
