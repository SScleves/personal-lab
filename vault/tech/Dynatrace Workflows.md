---
tags: [tech, backend, learning-target]
---

# Dynatrace Workflows

Learning target #2: problem → automated action. The honest version of the lab's "self-healing" story:
[[Agones]] replaces killed gameservers on its own — the Workflow's job is everything around that:
detect, notify, annotate, and prove closed-loop automation.

## The lab workflow (as code in `dynatrace-config`)

Trigger: problem event matching the game SLO alerting profile ([[Dynatrace SLOs]]).
Steps:
1. Notify (email/webhook → phone on camera — [[07 Demo Script]]).
2. Annotate: push a deployment/incident marker to [[Grafana Cloud]] so the comparison
   dashboards show the same moment.
3. Act: call the Agones allocation API / `kubectl` webhook to pre-warm a replacement gameserver —
   the closed loop.
4. (Stretch) Open a ticket-shaped record in a Databricks table — incident analytics later ([[Databricks]]).

## Cost/design rules (verified 2026-07-06)

- Free inside the current tenant window ([[Dynatrace]]). On paid DPS: standing **standard**
  workflow ≈ $22/mo just existing; **simple** workflows (1 trigger + 1 action) ≈ free.
- Keep the lab's always-on workflow SIMPLE-class if possible; standard ones get created for
  demo days and destroyed after — trivial because they're Terraform resources.
