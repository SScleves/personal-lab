---
tags: [demo]
---

# 🎬 Demo Script — the on-camera flow

The five minutes everything in this lab exists for. Rehearse until boring.

1. **Cold open**: `terraform plan` shows 0 changes — "the entire estate, including every
   [[Dynatrace SLOs|SLO]] and [[Dynatrace Workflows|Workflow]], is this repo."
2. **Load**: launch the [[k6]] player swarm → [[Agones]] FleetAutoscaler scales the fleet up
   (`kubectl get fleet -w` on screen).
3. **Chaos**: kill an allocated gameserver pod mid-session (the chaos CronJob's command, run manually).
4. **Detection**: [[Dynatrace]] problem opens, SLO burn visible → Workflow fires: notification arrives,
   annotation lands, Agones allocation API called. Meanwhile Agones has replaced the pod — players reconnect.
5. **Recovery**: SLO recovers on screen. Flip to [[New Relic]] / [[Grafana Cloud]] / Kibana ([[Elastic Stack]]):
   same incident, four backends, one instrumentation ([[OTel Collector]]).
6. **Close**: the [[Databricks]] dashboard — "and every night this telemetry becomes business insight."

Props to prepare: split terminal (k9s + watch), four browser tabs pre-logged-in, phone showing the
alert email. Failure modes rehearsed: k6 from laptop if cluster job fails; recorded backup run.
