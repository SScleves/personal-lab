# HANDOFF-STATE — read me first when resuming

*Last update: 2026-07-06*

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
3. Santi: branch protection on main; clone on laptop + open vault/ in Obsidian; commit+push the rewire.
4. Santi: HCP Terraform signup (vault/02 step B), OCI signup (quiet home region FIRST; report
   which A1 shape granted — 4/24 vs 2/12). NO GCP — adds nothing (Gemini needs only AI Studio).
5. Then terraform init against HCP, then Phase 2 per `vault/03 Phase 2 — Cluster and Agones.md`.
