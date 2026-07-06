# personal-lab — observability lab, everything-as-code

One repo = the whole project: architecture, step-by-step guides (an Obsidian vault), Terraform, and CI.
Personal accounts only (github.com, gmail, Azure free, OCI free). Nothing here touches work systems.

## How to read this from any machine

1. Santi pushes this repo to **github.com/SScleves/personal-lab** (public).
2. On the laptop: `git clone https://github.com/SScleves/personal-lab.git`
3. Open the `vault/` folder in Obsidian (**Open folder as vault**) → the full guide with the graph view.

## Map

| Path | What |
|---|---|
| `ARCHITECTURE.md` | The design: components, data flows, free-tier limits, what dies when, €0 proof |
| `vault/` | Obsidian guide — phases, per-technology notes, demo script. Start at `00 Home` |
| `terraform/` | All infrastructure as code. `envs/lab` is the only environment |
| `.github/workflows/` | CI: gitleaks on every push, terraform plan on PR, apply on main |
| `HANDOFF-STATE.md` | Where work stopped last session — read this first when resuming |

## The one-line pitch

Terraform provisions a k3s cluster (OCI free ARM) running **Agones** game-server fleets; a chaos job kills
game servers mid-session; **OpenTelemetry** fans the same telemetry out to **Dynatrace** (SLOs + Workflows),
**New Relic**, **Grafana Cloud**, and self-hosted **Elasticsearch**; **k6** swarms simulate players;
a nightly **Airflow** DAG lands telemetry in **Databricks**; a Gemini-backed chatbot on the Dutch-lessons
site provides the AI-observability story. Total cost: €0.

## Rules (from day one)

- Secrets never enter this repo: gitleaks runs pre-commit and in CI. `.tfvars`, tokens, kubeconfigs are gitignored.
- Only Santi creates accounts and pushes commits.
- Every phase ends with something visibly monitored.
