---
tags: [tech, hosting]
---

# GitHub Pages

Hosts the Dutch-lessons site (static) — replaced Azure static hosting in the zero-Azure rewire
(2026-07-06). Free on public repos, custom domains supported, ~100 GB/month soft bandwidth cap —
a language-lessons site won't scratch it.

## Setup (Phase 1 step D)

Site files → repo (own repo or `site/` folder) → Settings → Pages → deploy from branch,
or the `actions/deploy-pages` workflow for build steps. The published URL becomes:

- the [[Gemini Chatbot]]'s home (chatbot calls its API endpoint — note: Pages is static-only,
  so the chatbot API itself runs elsewhere: a tiny endpoint on the [[k3s]] cluster behind HTTPS).
- the target for [[New Relic]] free synthetic ping monitors (Phase 4) — the site-availability SLO
  ([[Dynatrace SLOs]]) gets its data without any probe VM.
