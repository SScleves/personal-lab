---
tags: [tech]
---

# Terraform

The spine of the lab: clouds, cluster bootstrap, AND all observability config
([[Dynatrace]], [[New Relic]], [[Grafana Cloud]]) are code. Same discipline as work, personal scale.

## Layout (repo `terraform/`)

- `envs/lab/` — the single environment; modules enabled phase by phase in `main.tf`.
- `modules/azure-state` · `oci-cluster` · `dynatrace-config` · `newrelic-config` · `grafana-cloud`
  — each README says what belongs in it and its gotchas.

## Bootstrap order (chicken & egg)

1. Apply `azure-state` with **local** state → storage account exists.
2. Uncomment `envs/lab/backend.tf` → `terraform init -migrate-state`.
3. Everything after lives in remote state ([[Azure Free Account]] blob, ~free forever).

## Rules

- Providers pinned in `providers.tf`; bump deliberately.
- No secrets in `.tf` or state-committed values echoed — tokens via env vars / CI secrets ([[Secrets Hygiene]]).
- LRS not GRS, versioning off (the €0 rule); `terraform fmt` enforced pre-commit and in [[GitHub Actions]].
- **The October drill**: `dynatrace-config` must fully rebuild a fresh tenant. Practice once before 2026-10.
