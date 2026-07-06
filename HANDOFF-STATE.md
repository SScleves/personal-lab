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

1. Santi: git init, create public GitHub repo, first push (gitleaks hook already configured).
2. Santi: OCI account signup (watch ARM capacity), Azure free account signup.
3. Terraform: fill `terraform/modules/azure-state` first (backend must exist before remote state).
4. Then Phase 2 per `vault/03 Phase 2 — Cluster and Agones.md`.
