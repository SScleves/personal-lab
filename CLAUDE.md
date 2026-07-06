# CLAUDE.md — read this first, every session, on every machine

This is **Santi's personal observability lab**: Terraform + k3s + Agones game servers on OCI
free tier, observed by Dynatrace/New Relic/Grafana/ELK via OpenTelemetry, for €0, to make every
bullet of an Observability-Specialist job offer demonstrable. You (Claude) assist; Santi operates.

## Session start protocol (in order, before doing anything)

0. **If you are running on the Linux home server** (Docker media stack on the host):
   your brief is `HOME-SERVER-MISSION.md` — read it after this file, it overrides the phase plan.
1. Read `HANDOFF-STATE.md` — the exact resume point. It supersedes anything else that looks like a plan.
2. Read `vault/08 Month Plan.md` — the week-by-week schedule with exercises. `vault/00 Home.md` maps the rest.
3. Check `vault/09 Signup Checklist.md` before asking Santi to sign up for anything — it may be done already.
4. End every session by updating `HANDOFF-STATE.md` and reminding Santi to commit+push it.

## Hard rules (violations have burned us — do not bend these)

- **€0, hard.** Before relying on any free-tier number, verify it against a live vendor page and
  record the date (`vault/tech/Free Tier Limits.md` shows the format). Do NOT trust training data.
- **This repo is PUBLIC.** No secrets, no tokens, no `terraform.tfvars`, no kubeconfigs, no
  personal emails, no home-network details (IPs/hostnames), ever. Gitleaks runs pre-commit and
  in CI; account usernames/emails deliberately live only in Santi's private session memory.
- **Zero connection to his employer.** Never reference work tenants, repos, pipelines, or
  incidents. Personal accounts only.
- **Santi does all signups and all `git push`** — give him exact copy-paste commands and full
  URLs; browser steps stay his.
- **Everything as code.** The Dynatrace tenant (`fjl36225.sprint.apps.dynatracelabs.com`, free
  until 2026-10) is mortal — every SLO/Workflow/token must be re-applicable via
  `terraform/modules/dynatrace-config` in minutes. Never configure the tenant only in the UI.
- **The server is ARM64** (OCI Ampere A1). Every container image must be linux/arm64 —
  see `vault/tech/Docker.md` before building anything.

## Decisions already made (don't re-litigate)

- State backend = HCP Terraform (org `sscleves-lab`, workspace `lab`, LOCAL execution mode,
  CI secret `TF_API_TOKEN`). Azure was dropped for infra (signup loop) — the Azure account that
  now exists is **banked exclusively for a Phase 5 Azure AI Foundry trial**. No GCP (adds nothing;
  Gemini = AI Studio with a plain Google account). Site hosting = GitHub Pages. Uptime probes =
  New Relic free **ping** synthetics (never browser/scripted — 500-check/month trap).
- Game fleet MVP = agar.io-clone (WebSocket → k6-testable); Minecraft **Java** as extra;
  Bedrock and Xonotic examples rejected (ARM). Agones version pinned — arm64 is Alpha-tier.
- Logstash = demo-days only (RAM); Kibana alerting can't notify on free (index/server-log
  connectors only) — alerts that fire live in Dynatrace/New Relic/Grafana IRM.

## How Santi works (match this or the session drags)

- **Ridiculously Small steps**: one action per step, exact commands with `cd`, full URLs for
  every browser step, say which button to click. He'll paste terminal output back — read it.
- Every phase/week must end with something **visibly monitored** (screenshot-able).
- Effort dial: signups/boilerplate = fast and dumb; architecture/SLO design = think hard.
  When a phase changes character mid-way, say so and re-dial.
- Docs he keeps: new files over edits to his files; plain language; no sprint vocabulary.

## Repo map

`ARCHITECTURE.md` = the design + job-offer mapping + what-dies-when. `vault/` = Obsidian guide
(open the folder as a vault; `00 Home` → phases → `tech/` notes). `terraform/envs/lab` = the one
environment; modules light up per phase. CI = gitleaks always, terraform plan on PR / apply on main.
`search.html` = offline doc search; **rebuild it after any doc change**
(`powershell _build\build-search.ps1`) so the committed copy stays fresh.
