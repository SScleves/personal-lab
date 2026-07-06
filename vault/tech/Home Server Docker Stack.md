---
tags: [tech, workload, optional]
---

# Home Server Docker Stack (Plex / *arr / qBittorrent)

Santi's existing Linux Docker host: Plex, Jellyseerr, Radarr, Sonarr, Prowlarr, qBittorrent.
**Optional lab extension** — a second, REAL environment to observe with zero new cost.

## Why it earns a place

- Real workloads with real failure modes (disk pressure, container restarts, transcode CPU spikes) —
  better war stories than synthetic chaos.
- One more [[OTel Collector]] (or Grafana Alloy) as a container in the existing compose stack:
  container metrics (cAdvisor/docker stats), host metrics, app logs → the same backends.
  Demonstrates multi-environment fleet observability — a genuine job-offer bullet.
- Could also host local [[Airflow and Astronomer|Astro CLI]] Airflow if the laptop shouldn't run Docker 24/7.

## Rules (stricter than the rest — this is the home network)

- **Nothing about this box in the public repo**: no IPs, no hostnames, no compose files with
  paths/ports. Keep its config in a PRIVATE repo or local-only ([[Secrets Hygiene]]).
- Egress-only telemetry (collector pushes out); zero inbound ports opened for the lab.
- Watch ingest volume: Plex + *arr logs are chatty — [[New Relic]]'s 100 GB and the 50 GB guard
  apply here too. Sample/filter at the collector.

## When

Anytime — it's independent of the OCI cluster and can run as a parallel track from the laptop.

## How

**The laptop's Claude follows `HOME-SERVER-MISSION.md` (repo root)** — 4 milestones: metrics to
both backends → filtered logs → alerts (disk pressure, container down, transcode spike) →
OneAgent-vs-OTel comparison. All host-specific files stay in `~/observability/`, outside this repo.
