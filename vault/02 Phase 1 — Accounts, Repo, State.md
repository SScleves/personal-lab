---
tags: [phase, next]
---

# Phase 1 — Accounts, repo, state (effort: LOW — signups and boilerplate)

Goal: repo live on GitHub ✅, OCI account exists, Terraform remote state works (HCP Terraform).
**Azure was dropped 2026-07-06** — signup impossible (gmail/GitHub Microsoft-identity loop);
replacements: [[HCP Terraform]] (state), [[GitHub Pages]] (site), [[New Relic]] synthetics (probes).

## Steps

### A. Repo — ✅ DONE 2026-07-06
Pushed to https://github.com/SScleves/personal-lab (public), gitleaks green, branch protection on,
commit identity = personal (repo-local config). Laptop clone + Obsidian vault = step 7 if not done.
Still pending on the work machine: `winget install Python.Python.3.12` → `pip install pre-commit` →
`pre-commit install` ([[Secrets Hygiene]] local guard).

### B. HCP Terraform (state backend) — [[HCP Terraform]]
1. https://app.terraform.io/public/signup/account → sign up with gmail (no card).
2. Create organization (e.g. `sscleves-lab`) → create workspace `lab` (CLI-driven workflow).
3. Workspace → Settings → Execution Mode → **Local** (HCP holds state+locks; CI runs terraform).
4. User Settings → Tokens → create API token → GitHub secret `TF_API_TOKEN`
   (https://github.com/SScleves/personal-lab/settings/secrets/actions); locally: `terraform login`.
5. Uncomment the `cloud {}` block in `terraform/envs/lab/backend.tf`, set the org name,
   `terraform init` — remote state live. 📸

### C. OCI (compute account) — [[OCI Always Free]]
6. Pick home region BEFORE signup (permanent; from NL: eu-marseille-1/eu-paris-1 quieter than
   eu-amsterdam-1). https://www.oracle.com/cloud/free/ — card for verification only.
7. **Note which A1 free shape you get (4 OCPU/24 GB or 2/12)** — it decides the Phase 2 layout.

### D. Site to GitHub Pages — [[GitHub Pages]]
8. Copy the Dutch-lessons site into a `site/` folder (or its own repo) → Settings → Pages →
   deploy from branch (or the Pages action). URL live = the probe target for Phase 4 synthetics.

Ends visibly monitored: gitleaks green ✅ + terraform plan/apply green against HCP state.
Next: [[03 Phase 2 — Cluster and Agones]]
