# HANDOFF-STATE — read me first when resuming

*Last update: 2026-07-06 late evening (end of the Phase-0/1 session)*

## EXACT resume point

1. GitHub repo live + gitleaks green ✅. Zero-Azure rewire done in the working tree —
   **verify it was committed AND pushed** (`git status` must be clean, `git log origin/main -1`
   must show the rewire commit). If not: add/commit/push first.
2. HCP Terraform: account EXISTS. **Unconfirmed**: org creation (intended name `sscleves-lab`),
   workspace `lab` (CLI-driven), Execution Mode = Local, API token in GitHub secret `TF_API_TOKEN`.
   Verify all four, then uncomment the `cloud {}` block in `terraform/envs/lab/backend.tf`
   (set the real org name!) and run `terraform init`.
3. Azure: account exists but is BANKED — Phase 5 AI Foundry trial only, never infra (see
   `vault/tech/Azure Free Account.md`). Do not wire it into terraform.
4. OCI: **not signed up yet.** Region choice pending (eu-marseille-1 / eu-paris-1 preferred over
   Amsterdam). MUST note which A1 free shape is granted (4 OCPU/24 GB vs 2/12 — June-2026 cut,
   see `vault/tech/OCI Always Free.md`) — it decides the Phase 2 RAM layout.
5. Account usernames/emails live in Claude's auto-memory (career-target-and-personal-lab),
   deliberately NOT in this public file.
6. THE PLAN to follow: `vault/08 Month Plan.md` (week-by-week + exercises per tech) and
   `vault/09 Signup Checklist.md` (all accounts + status). New since the last commit:
   those two + `vault/tech/Docker.md` + `vault/tech/MongoDB Atlas.md` — **needs commit+push**.

## Where we are

- Phase 0 DONE: free tiers verified via live web research (table + sources in
  `vault/tech/Free Tier Limits.md`), architecture agreed (`ARCHITECTURE.md`).
- Repo skeleton + Obsidian vault created on the work machine at `C:\Repos\personal-lab`.
  NOT yet `git init`-ed / pushed — that is Santi's first manual step (see `vault/02 Phase 1*.md`).
- Agones-on-ARM64/k3s verification DONE — results baked into `vault/tech/Agones.md`,
  `Game Servers.md`, `k6.md`, `OCI Always Free.md` (incl. the possible June-2026 OCI free-tier cut
  to 2 OCPU/12 GB — MUST re-verify at OCI signup).
- Dynatrace: Santi has a tenant free until 2026-10 — use it, no trials needed before October.

## Decisions taken (flip only with Santi)

Public GitHub repo · OCI always-free A1 for k3s/Agones/ELK · Azure = state + site + probe only ·
Logstash demo-only · Gemini primary LLM, Groq fallback.

## Next actions (in order)

1. ✅ 2026-07-06: repo pushed to github.com/SScleves/personal-lab (public), gitleaks green.
   Commit identity = repo-local SScleves/santiagosanch@gmail.com (work email amended out pre-push).
   Dynatrace lab tenant: https://fjl36225.sprint.apps.dynatracelabs.com (free until 2026-10).
   NOTE: terraform workflow fails red until Azure account + ARM_* secrets exist — expected.
2. ⚠️ 2026-07-06 PIVOT: **Azure DROPPED** (signup loop — gmail/GitHub MS-identity tangle).
   Zero-Azure rewire done: state → HCP Terraform (backend.tf cloud block, TF_API_TOKEN secret),
   site → GitHub Pages, probes → New Relic synthetics. azure-state module deleted.
   HCP free-tier verification agent was in flight — result belongs in vault/tech/HCP Terraform.md.
3. See "EXACT resume point" at the top of this file — it supersedes anything below.
   Also still pending on the work machine: Python + pre-commit install (local gitleaks guard);
   laptop clone + Obsidian vault open; branch protection if not yet set.
4. NO GCP (adds nothing — Gemini needs only AI Studio). Azure = Phase 5 AI Foundry only.
5. After HCP init works: OCI → Phase 2 per `vault/03 Phase 2 — Cluster and Agones.md`.
