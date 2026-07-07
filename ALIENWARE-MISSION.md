# ALIENWARE-MISSION.md — for the Claude running on the Alienware (games) laptop

You are Claude on Santi's **Windows gaming laptop** — the machine where his **two self-made
video games** live. That's this machine's identity: games and play. (The Dutch-lessons site
does NOT live here — it was published from the main machine and is already live at
https://sscleves.github.io/dutch-lessons/.) Read `CLAUDE.md` in this repo first; its hard
rules apply. Two missions.

## Extra rules for THIS machine

1. **The games are Santi's personal creations.** Read, inventory, assess — but never refactor,
   "improve", or reorganize them without his explicit go.
2. Santi creates repos and pushes, as always. You prepare everything push-ready.
3. Kubeconfig for the lab cluster lives on **one machine only** — ask Santi whether this is it
   before ever copying credentials here.

## Session protocol

1. `git pull` this repo → read `CLAUDE.md`, then `HANDOFF-STATE.md` (anything newer wins),
   then this file. `vault/08 Month Plan.md` shows where the lab currently stands.
2. Work the missions in order; one per session is fine.
3. End of session: update `HANDOFF-STATE.md` (generic progress only), rebuild `search.html`
   if docs changed, remind Santi to commit+push.

## Mission A — assess the two games as future lab workloads (report, don't port)

Find the games first (ask Santi where they live on this machine). For EACH, produce a short
written assessment (add it to the vault as `vault/tech/Game Assessment - <name>.md`, generic
enough for the public repo — no local paths):

- Engine/language, and does it have (or could it have) a **server component**?
- Can that server run **headless** (no GPU/window) on Linux? On **ARM64**? (The cluster is ARM —
  `vault/tech/Docker.md` explains why this gates everything.)
- What could it emit as telemetry: tick duration, player/entity count, frame budget, load time?
- Multiplayer or single-player? (Single-player still works as a workload: a headless
  "simulation mode" run as a k8s Job is a legitimate observable batch workload.)
- Verdict: `fleet-candidate` (could join Agones like the agar.io clone) · `batch-candidate`
  (k8s Job/CronJob) · `client-only` (stays here as a demo prop).

No porting, no Dockerfiles yet — the assessments feed a go/no-go with Santi. If one is a
fleet-candidate, it becomes workload #2 in a later week ([[Game Servers]]).

## Mission B — set up the demo/player station (Week 4's on-camera machine)

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

Two game assessments in the vault · k6/Node/Obsidian installed and the vault opens ·
this laptop can join the game and swarm it on demand.
