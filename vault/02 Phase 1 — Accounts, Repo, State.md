---
tags: [phase, next]
---

# Phase 1 — Accounts, repo, state (effort: LOW — signups and boilerplate)

Goal: repo live on GitHub, both cloud accounts exist, Terraform remote state works.
Ends visibly monitored: the gitleaks Action runs green on the first push.

## Steps (each < 1 minute unless marked)

### A. Repo (do this first — everything else hangs off it)
1. Terminal: `cd C:\Repos\personal-lab` → `git init -b main`
2. `pip install pre-commit` then `pre-commit install` ([[Secrets Hygiene]] — the hook is already configured)
3. `git add . && git commit -m "lab skeleton: architecture, vault, terraform, CI"`
4. Browser: github.com → New repository → name `personal-lab` → **Public** → no README (we have one) → Create
5. Follow GitHub's "push an existing repository" two commands. Refresh → Actions tab → gitleaks runs green. 📸
6. Settings → Branches → protect `main` (require PR). Works on free because the repo is public — [[GitHub Actions]].
7. **Laptop**: `git clone https://github.com/SScleves/personal-lab.git`, open `vault/` in Obsidian → this guide travels.

### B. Azure (work-mirror account) — [[Azure Free Account]]
8. azure.microsoft.com/free → Start free → personal Microsoft account (gmail works via MSA) —
   needs credit card (verification only, ~$1 hold) + phone. *(~10 min)*
9. **Set the calendar reminder NOW**: "+11 months: Azure free VMs start billing after PAYG upgrade — review".
10. Portal → note subscription ID. Create the state module vars later — [[Terraform]] has the bootstrap order.

### C. OCI (compute account) — [[OCI Always Free]]
11. Pick the home region BEFORE signup (it's permanent) — quieter region = better free-ARM availability.
12. oracle.com/cloud/free → sign up (card for verification, stays $0). *(~10 min)*

### D. First terraform apply *(~15 min)*
13. `cd terraform\envs\lab` → fill `modules/azure-state` (RG + storage account, **LRS**, versioning off)
14. `terraform init && terraform apply` with LOCAL state → uncomment `backend.tf` →
    `terraform init -migrate-state` → remote state lives in the free blob. 📸 the container in the portal.
15. Repo → add the ARM_* secrets (Settings → Secrets → Actions) so the [[GitHub Actions]] plan/apply pipeline works.
16. Update `HANDOFF-STATE.md`, commit via PR — watch plan-on-PR run. Phase 1 done.

Next: [[03 Phase 2 — Cluster and Agones]]
