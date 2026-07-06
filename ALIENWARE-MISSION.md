# ALIENWARE-MISSION.md — for the Claude running on the Alienware (games) laptop

You are Claude on Santi's **Windows gaming laptop** — the machine where his personal creations
live: the Dutch-lessons folder (static website + Obsidian vault) and **two self-made video games**.
Read `CLAUDE.md` in this repo first; its hard rules apply. Your three missions, in order, below.

## Extra rules for THIS machine

1. **The games and the Dutch content are Santi's personal creations.** Read, inventory, assess —
   but never refactor, "improve", or reorganize them without his explicit go.
2. **Sanitize before anything goes public.** The Dutch-lessons material may contain personal
   context (names, photos, notes). Nothing goes to a public repo before the sanitization
   checklist in Mission A passes and Santi approves the file list.
3. Santi creates repos and pushes, as always. You prepare everything push-ready.
4. Kubeconfig for the lab cluster lives on **one machine only** — ask Santi whether this is it
   before ever copying credentials here.

## Session protocol

1. `git pull` this repo → read `CLAUDE.md`, then `HANDOFF-STATE.md` (anything newer wins),
   then this file. `vault/08 Month Plan.md` shows where the lab currently stands.
2. Work the missions in order; one per session is fine.
3. End of session: update `HANDOFF-STATE.md` (generic progress, no personal paths beyond what's
   already public), rebuild `search.html` if docs changed, remind Santi to commit+push.

## Mission A — Dutch-lessons site → GitHub Pages (the lab's first public workload)

1. Locate the folder: expected at `%USERPROFILE%\Downloads\Dutch Lessons` — if not there, ask.
2. Inventory (read-only) and show Santi: what's site, what's vault, what's game, total size,
   and any file that looks personal (names/photos/tokens/exports).
3. **Sanitization checklist** — every item confirmed with Santi before staging:
   no real names beyond his own public handle · no photos he didn't approve · no API keys or
   tokens in JS/config · no Obsidian workspace files · vault stays PRIVATE (only the rendered
   site goes public) unless he says otherwise.
4. Stage a clean copy in a NEW folder (e.g. `%USERPROFILE%\repos\dutch-lessons`), `git init -b main`,
   **repo-local identity** (`git config user.name "SScleves"`,
   `git config user.email "santiagosanch@gmail.com"`) — same work-email trap we already hit once.
5. Santi: create the **public** repo `dutch-lessons` at https://github.com/new → push.
6. Enable Pages: https://github.com/SScleves/dutch-lessons/settings/pages → Deploy from branch →
   `main` / root → Save. Wait ~2 min → site live at `https://sscleves.github.io/dutch-lessons/`.
7. 📸 the live site. Record the URL in `HANDOFF-STATE.md` — it becomes the New Relic synthetics
   target and, later, the [[Gemini Chatbot]]'s home (chatbot = separate mission, needs the lab
   cluster to exist first; the API can't live on Pages, it's static-only).

## Mission B — assess the two games as future lab workloads (report, don't port)

For EACH of the two games, produce a short written assessment (add it to the vault as
`vault/tech/Game Assessment - <name>.md`, generic enough for the public repo):

- Engine/language, and does it have (or could it have) a **server component**?
- Can that server run **headless** (no GPU/window) on Linux? On **ARM64**? (The cluster is ARM —
  `vault/tech/Docker.md` explains why this gates everything.)
- What could it emit as telemetry: tick duration, player/entity count, frame budget, load time?
- Multiplayer or single-player? (Single-player games can still be workloads: a headless
  "simulation mode" run as a k8s Job is a legitimate observable batch workload.)
- Verdict: `fleet-candidate` (could join Agones like the agar.io clone) · `batch-candidate`
  (k8s Job/CronJob) · `client-only` (stays on this laptop as a demo prop).

No porting, no Dockerfiles yet — the assessments feed a go/no-go with Santi. If one is a
fleet-candidate, it becomes workload #2 in a later week ([[Game Servers]]).

## Mission C — set up the demo/player station (Week 4's on-camera machine)

This laptop plays the games and generates the load in [[07 Demo Script]] — from OUTSIDE the
cluster, over the real internet, which is exactly the point.

1. Tools (PowerShell, one line each):
   `winget install Git.Git` (if missing) · `winget install Obsidian.Obsidian` ·
   `winget install k6 --source winget` · `winget install OpenJS.NodeJS.LTS` (for WS bot scripts).
2. Open `vault/` from the repo clone in Obsidian → this laptop can read the whole plan.
3. When the game fleet exists (Week 2): join from two browser windows, confirm a human can play.
4. When Week 4 arrives: run the k6 WebSocket swarm from HERE (`vault/tech/k6.md`), watch the
   FleetAutoscaler react, and own the 📸/recording duties in the demo script.
5. Optional quality-of-life: OBS or the Xbox Game Bar for recording the backup demo run.

## What "done" looks like for this machine

Site live on Pages + URL recorded · two game assessments in the vault · k6/Node/Obsidian
installed and the vault opens · this laptop can join the game and swarm it on demand.
