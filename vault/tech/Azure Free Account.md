---
tags: [tech, cloud, dropped]
---

# Azure Free Account — DROPPED 2026-07-06

Azure was designed in as the "work-mirror" (state blob, static site, probe VM) but the free-account
signup proved impossible from Santi's identities: the gmail address is entangled with a
GitHub-created Microsoft identity, and the signup loops forever on credential creation
(a known failure mode of the "Sign in with GitHub" flow; even the pre-created-MSA path looped).

## What replaced it

| Azure job | Replacement |
|---|---|
| Terraform remote state | [[HCP Terraform]] (free, no card, state + locking) |
| Dutch-lessons site | [[GitHub Pages]] |
| Probe VM | [[New Relic]] free synthetics (unlimited ping monitors) |

Net effect: one less account, one less card, no month-13 billing trap — the design got simpler.

## Plot twist (same day): account created after all — but the design stays zero-Azure

A fresh outlook.com identity (created clean, never via GitHub) broke the signup loop and the
account now EXISTS. Decision: keep the simpler zero-Azure wiring ([[HCP Terraform]] state,
[[GitHub Pages]], [[New Relic]] synthetics) and **reserve the Azure account for Phase 5:
an Azure AI Foundry trial on the [[Gemini Chatbot]]** — the one job only Azure can do here
(AI Foundry is the literal job-offer keyword). The Phase 0 Azure research in [[Free Tier Limits]]
applies whenever that day comes. If the account is ever used for real resources: the month-13
billing trap and free-services-flow rules in the history of this note apply.
