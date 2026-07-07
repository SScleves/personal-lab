# GUARDRAILS.md — hard rules. Non-negotiable. Read before ANY work session.

Violations of these have burned us (or will). If a rule blocks you, STOP and ask Santi —
never work around a guardrail.

1. **€0 is a hard ceiling.** Before creating ANY cloud resource, confirm it's inside a
   free tier verified in `vault/tech/Free Tier Limits.md`. If the verification is older than
   ~3 months, re-verify against a live vendor page first.
2. **Never trust training data for limits, prices, UI labels, or API endpoints.** Verify live
   (web or the actual UI/API) or mark the step VERIFY-FIRST and do that before executing.
3. **This repo is PUBLIC.** No secrets, tokens, tfvars, kubeconfigs, personal emails, home IPs,
   hostnames, or employer references — ever. Account identities live in Claude auto-memory, not here.
4. **Santi does all signups and all pushes** unless he explicitly hands you a push in the moment.
   Prepare everything push-ready; give exact copy-paste commands and full URLs.
5. **Repo-local git identity** (`SScleves / santiagosanch@gmail.com`) on every clone, every
   machine, BEFORE the first commit. Verify with `git log --format='%an %ae' -1`. No `--global`.
6. **Small steps, verified steps.** No step proceeds until the previous one's verify command
   passed. If a runbook step fails twice, STOP — diagnose, don't improvise forward.
7. **Plan before apply, always.** `terraform plan` output gets READ (adds/changes/destroys
   counted and explained to Santi) before any `apply`. A destroy count > 0 needs Santi's
   explicit OK, every time.
8. **The Dynatrace tenant is mortal** (free until 2026-10). Any config not in
   `terraform/modules/dynatrace-config` will die with it. UI-only configuration is forbidden
   except for reading/exploring.
9. **Ingest caps are protective walls**: New Relic hard-locks at 100 GB/month. The 50 GB
   guard alert + drop rules are built BEFORE any dashboard work. When in doubt, send less.
10. **ARM64 everywhere on the cluster.** Every image gets `--platform linux/arm64` or a
    verified multi-arch manifest before deploy. `exec format error` = you skipped this.
11. **Never rename werkplek's internal identifiers** (`flowdeck` DB name, storage keys,
    backup `app` field) — renaming orphans Santi's data. Display strings only.
12. **Don't rewrite Santi's creative content** (the book, the games, Dutch lesson content,
    his About text) — additive help only, and only when asked.
13. **Don't re-litigate decided decisions** (list in `CLAUDE.md`). Zero-Azure infra, OCI compute,
    public repos, agar.io+Minecraft-Java, ping-only synthetics — decided. Reopen only if Santi does.
14. **Update `HANDOFF-STATE.md` before ending any session**, and rebuild `search.html`
    (Windows machines only) when docs changed. The repo IS the memory.
15. **When a fact and this repo disagree, verify live and fix the repo** — never silently
    proceed on either version. (This is how the Alienware/Dutch mix-up got fixed.)
