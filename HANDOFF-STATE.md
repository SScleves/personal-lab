# HANDOFF-STATE — read me first when resuming

*Last update: 2026-07-07 (end of the Phase-0/1 session). Any Claude on any machine: read
`CLAUDE.md` first — session protocol and hard rules — then this file top to bottom.*

## EXACT resume point

0. NEW (2026-07-07 night): **GUARDRAILS.md** (15 hard rules) + execution protocol in CLAUDE.md +
   **five micro-step runbooks** in `vault/runbooks/` (R1 OCI/k3s · R2 Agones · R3 OTel/Dynatrace ·
   R4 New Relic/Grafana/comparison · R5 Databricks/Airflow/Gemini/AI-Foundry). ALL build work
   follows a runbook, step-by-verify-step. [VERIFY-FIRST] markers = check live before executing.

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
   those two + `vault/tech/Docker.md` + `vault/tech/MongoDB Atlas.md` + `CLAUDE.md` +
   doc search (`search.html` + `_build/`) — **needs commit+push**.
7. Doc-search convention: after changing any .md, rerun `powershell _build\build-search.ps1`
   and commit the regenerated `search.html` alongside.
8. PARALLEL TRACKS (machine briefs at repo root, dispatched by CLAUDE.md step 0):
   - `HOME-SERVER-MISSION.md` — Linux box: Docker media stack → Dynatrace + New Relic via OTel
     (4 milestones). Independent of the cluster; can start immediately.
   - `ALIENWARE-MISSION.md` — games laptop, GAMES ONLY (corrected 2026-07-07: Dutch folder is
     on the MAIN machine, site already live): assess the 2 games as workloads (report only),
     set up as demo/player + k6 station.
   Both: host-specific/personal files stay OUT of this public repo.
9. 2026-07-07: SScleves estate expanded — werkplek (naming aligned, RUM candidate #1; Santi must
   verify Supabase RLS once), thetruth (hygiene + Santi's BOOK "Something Doesn't Fit" built as a
   site: book/source.txt → _build/build-book.ps1 → book/*.html; enable Pages on that repo).
   RUM plan for all frontends: vault/tech/Frontend RUM.md. Commits made locally — Santi pushes.
10. 2026-07-07: thetruth WEBSITE reworked in the book's tone (new index/about/contact + css/site.css;
    template lorem-ipsum pages + demo posts deleted — recoverable from git history). Full GitHub
    how-to: vault/tech/GitHub Estate Guide.md ⭐. Terraform reconciliation skeleton:
    terraform/modules/github-estate (import-first, commented until PAT exists).
    PENDING SANTI: enable Pages on thetruth (Settings→Pages→main→root) — book 404s until then.
11. 2026-07-07 later: thetruth got the visionary design (mandala/aurora/scanlines) + POSTS system
    (posts-src/*.md → _build/build-posts.ps1 → live; guide = UPDATING.md). werkplek branding
    finished (data identifiers kept as 'flowdeck' for compat — NEVER rename those). numbers +
    my-awesome-website repos: Santi deleting (dupes/empty). dutch-lessons staged+committed at
    C:\Repos\SScleves\dutch-lessons (sanitized: BYOK Anthropic key input only, no secrets) —
    Alienware Mission A completed from the work machine; PENDING SANTI: create repo + push +
    enable Pages. Launch card added to vault/tech/GitHub Estate Guide.md §2b.

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
