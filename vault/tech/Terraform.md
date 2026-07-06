---
tags: [tech]
---

# Terraform

The spine of the lab: clouds, cluster bootstrap, AND all observability config
([[Dynatrace]], [[New Relic]], [[Grafana Cloud]]) are code. Same discipline as work, personal scale.

## Layout (repo `terraform/`)

- `envs/lab/` — the single environment; modules enabled phase by phase in `main.tf`.
- `modules/oci-cluster` · `dynatrace-config` · `newrelic-config` · `grafana-cloud`
  — each README says what belongs in it and its gotchas.

## State backend: [[HCP Terraform]] (no bootstrap chicken-and-egg)

Create org + workspace `lab` in the HCP UI (Phase 1 step B), set Local execution mode,
uncomment the `cloud {}` block in `envs/lab/backend.tf`, `terraform init` — done.
No storage infra to pre-create (this replaced the Azure blob design, 2026-07-06).

## Rules

- Providers pinned in `providers.tf`; bump deliberately.
- No secrets in `.tf` or state-committed values echoed — tokens via env vars / CI secrets ([[Secrets Hygiene]]).
- LRS not GRS, versioning off (the €0 rule); `terraform fmt` enforced pre-commit and in [[GitHub Actions]].
- **The October drill**: `dynatrace-config` must fully rebuild a fresh tenant. Practice once before 2026-10.
