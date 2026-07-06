---
tags: [tech, backend-state]
---

# HCP Terraform (Terraform Cloud)

The lab's remote-state backend — replaced Azure blob storage when the Azure signup proved
impossible (2026-07-06). Arguably the better outcome: HCP Terraform is itself CV-relevant,
and state + locking + a web UI for run history come free.

## Setup (Phase 1 step B — full clicks in [[02 Phase 1 — Accounts, Repo, State]])

Org + workspace `lab` + **Local execution mode** (HCP stores state and locks; GitHub Actions and
the laptop run terraform). Auth: user API token → `TF_API_TOKEN` GitHub secret + `terraform login`
locally. The `cloud {}` block lives in `terraform/envs/lab/backend.tf`.

## Free tier — ✅ verified 2026-07-06 (live docs)

- **500 managed resources free** (resources in state; data sources/null_resource don't count),
  unlimited users/workspaces, 1 concurrent run, remote state + locking + VCS integration included.
  No time expiry. (The *legacy* free plan hit EOL 2026-03-31; new signups land on the current
  500-resource free tier directly.)
- **No card at signup** (email or GitHub identity; card only enters if you actively activate
  pay-as-you-go). Over 500 resources with no card = blocked runs, **not a bill**.
- Local execution mode confirmed: Settings → General → Execution Mode → Local — HCP stores
  state/locks only. CI token needs state read/write; `cloud {}` block is the current syntax
  (Terraform ≥ 1.1), `backend "remote"` is legacy.
- Ignore the "$500 HCP trial credits" banner at signup — that's a separate 6-month HCP-platform
  trial; the 500-resource free allowance is the permanent thing the lab uses.

The lab is a handful of resources — ~1% of the cap. This limit will never bite.

## Why local execution mode

Remote execution would run terraform on HCP's runners — then OCI/Dynatrace credentials would have
to live in HCP too. Local mode keeps all credentials in one place (GitHub Actions secrets)
and HCP touches only state. One secret store, smaller surface ([[Secrets Hygiene]]).
