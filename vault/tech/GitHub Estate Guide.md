---
tags: [tech, guide, learning-target]
---

# GitHub Estate Guide — how everything you own is managed

The one guide for "how do I run my stuff on GitHub." Everything below is what we actually do —
including the mistakes already made, so they don't repeat.

## 1. The mental model (30 seconds)

A **repo** is a folder with a memory (every change, forever). **GitHub** holds the shared copy;
every machine (work PC, Alienware, Linux server) syncs against it. Your loop on any machine:

```powershell
git pull                     # get what other machines pushed — ALWAYS first
# ...edit files...
git add -A
git commit -m "what changed and why"
git push                     # publish; until you push, only your machine has it
```

If push says `rejected (non-fast-forward)` → you forgot `git pull` first.

## 2. Your estate — every repo and its job

| Repo | What it is | How it publishes |
|---|---|---|
| **personal-lab** | The lab: this vault, missions, Terraform, CI | Not a website; `search.html` from any clone |
| **thetruth** | The site + the book *Something Doesn't Fit* | Pages, deploy-from-branch (`main` /root) |
| **werkplek** | The notes/productivity PWA ("the notes like this") | Pages via Actions build (push = auto-deploy) |
| **dutch-lessons** | the Dutch study site (single self-contained index.html) | Pages, deploy-from-branch |
| ~~my-awesome-website, numbers~~ | deleted 2026-07 (empty shell + duplicate template) | — |
| **Docker/Plex box** | deliberately has NO repo — configs stay in `~/observability/` on the box | reads the missions from personal-lab ([[Home Server Docker Stack]]) |

## 2b. Launch card — every app: where it runs + how to run it locally

| App | Live URL | Run locally | Update guide |
|---|---|---|---|
| The Truth + book | https://sscleves.github.io/thetruth/ | double-click `index.html` | `UPDATING.md` in that repo |
| werkplek | https://sscleves.github.io/werkplek/ | `npm install` then `npm run dev` (needs Node) | its `README.md` |
| Dutch site | https://sscleves.github.io/dutch-lessons/ | double-click `index.html` | its `README.md` (add-a-lesson recipe included) |
| This vault | not a website | Obsidian → open `vault/` folder | [[00 Home]] |
| Lab infra | not a website | `terraform plan` in `envs/lab` | [[08 Month Plan]] |

## 3. Websites = GitHub Pages, two flavors you own

**Flavor A — deploy from branch** (thetruth, dutch-lessons): repo Settings →
https://github.com/SScleves/thetruth/settings/pages → Source: Deploy from a branch → `main` +
`/ (root)` → Save. GitHub runs "pages build and deployment" (watch the Actions tab), then the
site is at `https://sscleves.github.io/<repo>/`.
⚠️ **Today's lesson: pushing is NOT publishing.** The book 404'd because Pages was never enabled —
`has_pages: false`. Enabling it is a one-time manual click (until Terraform owns it — section 6).

**Flavor B — build via Actions** (werkplek): `.github/workflows/deploy.yml` compiles the React
app and deploys `dist/`. You never click anything: **push to main = live site** ~2 min later.
Check state: repo → Actions tab → newest run green?

## 4. The content workflows

- **The book**: edit `book/source.txt` in thetruth → `powershell _build\build-book.ps1` →
  commit source + generated `book/*.html` together → push. Site updates itself (flavor A).
- **The site pages** (index/about/contact): plain HTML in the book's tone — edit, push, live.
  Topic ideas go in `TOPICS.md` first.
- **Notes (werkplek)**: the app's *code* is the repo; your *notes data* lives in the browser
  (IndexedDB) — NOT on GitHub. Back it up via Settings → Data → Export inside the app.
- **This vault**: edit `.md` in `personal-lab/vault/`, rebuild `search.html`
  (`powershell _build\build-search.ps1`), push. Every machine's Obsidian sees it after `git pull`.

## 5. Solo-dev process rules

- **personal-lab** (has CI that changes infra): branch + PR → plan runs → merge → apply runs.
- **thetruth / werkplek / dutch-lessons** (content): pushing straight to `main` is fine — you're
  the only author and Pages is the only consumer.
- Identity per repo: personal repos must commit as `SScleves / santiagosanch@gmail.com` —
  set with repo-local `git config user.name/user.email` (NEVER `--global` on the work machine).
  We already leaked a work email into a commit once and amended it out pre-push.
- Secrets: only in Actions secrets (repo Settings → Secrets) — never in files. Gitleaks guards
  every push ([[Secrets Hygiene]]).

## 6. Terraform reconciliation — the estate as code

The endgame: `terraform/modules/github-estate` in personal-lab manages the repos THEMSELVES —
Pages settings, descriptions, branch protection — via the **GitHub provider**, import-first
(the exact philosophy from work: import existing things, plan to zero, then manage as code).
The module skeleton + import example exists; needs a PAT (`repo` scope) as `GITHUB_TOKEN`.
Content (book text, notes, HTML) stays in git as files — Terraform manages *settings*, not words.

## 7. Troubleshooting — today's greatest hits

| Symptom | Cause → fix |
|---|---|
| `Repository not found` on push | Repo never created on github.com → create at github.com/new, then push |
| Site 404 after push | Pages not enabled → Settings → Pages → deploy from branch |
| Commit shows work email | Repo-local identity not set → set it, `git commit --amend --reset-author` BEFORE pushing |
| `rejected (non-fast-forward)` | Another machine pushed first → `git pull`, then push |
| Actions tab shows red | Open the run, read the first failing step — usually a missing secret |
