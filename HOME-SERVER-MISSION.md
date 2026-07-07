# HOME-SERVER-MISSION.md — for the Claude running on the Linux home server

You are Claude, running on Santi's **Linux laptop/home server** that hosts a Docker media stack
(Plex, Jellyseerr, Radarr, Sonarr, Prowlarr, qBittorrent — verify, don't assume). Your mission:
make this stack **observable in Dynatrace and New Relic via OpenTelemetry**, so Santi learns
container observability on real workloads. Read `CLAUDE.md` in this repo first — its hard rules
apply here, plus the stricter ones below.

## Non-negotiable rules for THIS machine

1. **This repo is PUBLIC. Nothing host-specific ever gets committed**: no IPs, hostnames, MACs,
   compose files, volume paths, media library names. All work happens OUTSIDE the repo clone in
   `~/observability/` (local only, never a git remote unless Santi makes a private repo).
2. **Egress-only.** The collector pushes out. Open no inbound ports, change no router config.
3. **Do not touch the media containers themselves** (no restarts, no compose edits) without
   asking Santi first — this stack is in daily use. Adding NEW containers alongside is fine.
4. Secrets (API tokens) live in `~/observability/.env`, chmod 600, never echoed, never committed.
5. **Ingest caps are real**: New Relic free = 100 GB/month with full-platform lockout on breach.
   Start metrics-only; add logs with filters later. When in doubt, send less.

## Session protocol

1. `git pull` this repo; read `HANDOFF-STATE.md` for anything newer than this file.
2. Inventory (read-only): `docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}'`,
   `docker system df`, `df -h`, `free -h`, and locate (but do not edit) the compose file.
   Show Santi the inventory; confirm scope before building.
3. Execute the milestones below in order. One milestone per session is fine.
4. At the end: update `HANDOFF-STATE.md` with GENERIC progress only ("M1 done, both backends
   receiving") — no host details — and remind Santi to commit+push. Linux notes:
   - Do NOT try to rebuild `search.html` — the build script is PowerShell/Windows-only;
     the next Windows session will refresh it.
   - Before the FIRST commit from this box, set the repo-local identity
     (`git config user.name "SScleves"` / `git config user.email "santiagosanch@gmail.com"`)
     and verify with `git log --format='%an %ae' -1` after committing — the work-email
     trap has bitten once already.

## Credentials you must ask Santi for (never mint or guess)

- **Dynatrace**: tenant = `https://fjl36225.sprint.apps.dynatracelabs.com` (free until 2026-10).
  Ask for an API token with scopes: `metrics.ingest`, `logs.ingest`, `openTelemetryTrace.ingest`.
  Get the exact OTLP endpoint from the tenant UI (search "OpenTelemetry" in the tenant; sprint
  environments use a `…sprint.dynatracelabs.com/api/v2/otlp` form — **verify in the UI, do not
  guess the URL**).
- **New Relic**: if no account exists yet (check `vault/09 Signup Checklist.md`), walk Santi
  through https://newrelic.com/signup (free, no card) — **choose the EU data center**. Then ask
  for the license key (ingest type). EU OTLP endpoint: `https://otlp.eu01.nr-data.net:4318`
  (US accounts use `otlp.nr-data.net` — match the account region, this is the #1 silent failure).

## Milestone 1 — container + host metrics into BOTH backends (one evening)

In `~/observability/`, create three files.

`docker-compose.yml`:
```yaml
services:
  otelcol:
    image: otel/opentelemetry-collector-contrib:<PIN-CURRENT>   # check releases page, pin, never :latest
    restart: unless-stopped
    user: "0"                                    # docker_stats needs the socket
    command: ["--config=/etc/otelcol/config.yaml"]
    env_file: .env
    volumes:
      - ./config.yaml:/etc/otelcol/config.yaml:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - /:/hostfs:ro
```

`.env` (chmod 600):
```
DT_OTLP_ENDPOINT=<from tenant UI, ends in /api/v2/otlp>
DT_API_TOKEN=<Santi provides>
NR_OTLP_ENDPOINT=https://otlp.eu01.nr-data.net:4318
NR_LICENSE_KEY=<Santi provides>
```

`config.yaml` (collector):
```yaml
receivers:
  docker_stats:
    endpoint: unix:///var/run/docker.sock
    collection_interval: 30s
  hostmetrics:
    root_path: /hostfs
    collection_interval: 60s
    scrapers: { cpu: {}, memory: {}, disk: {}, filesystem: {}, network: {}, load: {} }
processors:
  memory_limiter: { check_interval: 5s, limit_mib: 256 }
  resourcedetection: { detectors: [system] }
  resource:
    attributes:
      - { key: deployment.environment, value: home-server, action: upsert }
  batch: {}
exporters:
  otlphttp/dynatrace:
    endpoint: ${env:DT_OTLP_ENDPOINT}
    headers: { Authorization: "Api-Token ${env:DT_API_TOKEN}" }
  otlphttp/newrelic:
    endpoint: ${env:NR_OTLP_ENDPOINT}
    headers: { api-key: "${env:NR_LICENSE_KEY}" }
service:
  pipelines:
    metrics:
      receivers: [docker_stats, hostmetrics]
      processors: [memory_limiter, resourcedetection, resource, batch]
      exporters: [otlphttp/dynatrace, otlphttp/newrelic]
```

Start: `docker compose up -d` (older Docker: `docker-compose up -d` — check which exists with
`docker compose version || docker-compose version`) → `docker logs otelcol` must show no export
errors after 2 minutes.
**Verify in both UIs** (Dynatrace: Metrics browser, search `container.`; New Relic: Metrics
explorer, filter `deployment.environment = home-server`). 📸 both. Milestone done = the same
per-container CPU/memory visible in two vendors.

## Milestone 2 — logs, with the safety filters ON from minute one

Add a `filelog` receiver on `/var/lib/docker/containers/*/*-json.log` (mount it :ro, add the
`json_parser` operator), a `filter` processor dropping severity < WARN for the chatty *arr
containers, and a `logs` pipeline to both exporters. Before enabling: estimate volume with
`docker logs --since 24h <noisiest> | wc -c` × containers × 30 — if the projection exceeds
~1.5 GB/day, filter harder. After 48 h, check actual ingest in both UIs and record the number
in the vendor-comparison notes.

## Milestone 3 — the alerts that make it observability (not just dashboards)

1. **Disk pressure** (the realistic failure: qBittorrent fills the disk): alert at 85% filesystem
   used — build it in BOTH vendors, compare the experience. Dynatrace side goes in
   `terraform/modules/dynatrace-config` (it's tenant config — as code, always).
2. **Container down**: `docker stop` a low-stakes container (ask Santi which) → both vendors must
   show it → restart it. Time-to-detect goes in the comparison notes.
3. **Transcode spike**: play something that forces a Plex transcode → find the CPU spike in both.

## Milestone 4 (stretch) — OneAgent vs OTel

Deploy the Dynatrace OneAgent container alongside (tenant UI → Deploy → Docker). Compare against
the OTel view: what does OneAgent see that OTel doesn't (process-level, auto-topology), what does
it cost in resources, which would you deploy at a client? One page of notes → interview gold.
Remove it after if the laptop feels it.

## Troubleshooting order

`docker logs otelcol` → add a `debug` exporter temporarily → check the endpoint region (EU vs US
is the classic) → check token scopes → `curl -v` the OTLP endpoint from the host. Never debug by
pasting tokens into chat or commits.
