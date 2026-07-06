---
tags: [tech, telemetry, frontends]
---

# Frontend RUM — agents on the personal apps

Santi's own frontends all get real-user monitoring — the same fan-out philosophy as the cluster,
applied to browsers. The fleet:

| App | Repo | What RUM sees |
|---|---|---|
| **werkplek** (React PWA, the flagship) | github.com/SScleves/werkplek | SPA route changes, JS errors, IndexedDB-heavy interactions, Supabase fetch timing |
| **The Truth + the book** | github.com/SScleves/thetruth | Reading behavior per chapter, page-load on image-heavy pages |
| **Dutch-lessons site** | (Alienware Mission A) | Availability + TTFB baseline, later chatbot UX timing |

## The plan (wire when the New Relic account exists — Week 4 or earlier)

1. **New Relic Browser** (free tier, standing): create one Browser app per site → copy the loader
   snippet → werkplek: into `index.html` head (template) · thetruth/book: the
   `<!-- RUM snippet slot -->` comments already mark the spot in `_build/build-book.ps1` templates.
2. **Dynatrace RUM** as the learning exercise (agentless RUM needs the tenant's JS tag): add to ONE
   app (werkplek), compare session view vs New Relic — vendor-comparison material. Tenant dies in
   October: RUM config lives in `dynatrace-config` Terraform where possible.
3. Watch PII: RUM captures URLs and user actions — these are personal-use apps, fine, but no
   session replay on werkplek (it contains his notes/journal text in the DOM).

## Terraform angle (the "manage it as code" story)

The **github provider** can manage the repos themselves — Pages settings, branch protection,
topics — from `terraform/`: real IaC over the whole SScleves estate. Nice Phase-5+ exercise;
the RUM snippets stay in the HTML templates (content, not infra).

## Supabase note (werkplek)

The committed anon key is Supabase's intended public model **only if Row Level Security is
enabled on every table** — Santi: verify once in Supabase dashboard → Table editor → RLS badges.
