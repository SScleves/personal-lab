---
tags: [tech, backend, learning-target]
---

# Dynatrace SLOs

Learning target #1. Game servers make SLOs visceral: latency isn't an abstract number,
it's whether the game feels playable.

## The lab's SLOs (defined as code in `dynatrace-config` — [[Terraform]])

| SLO | SLI source | Target | Why it's a good story |
|---|---|---|---|
| Game tick health | `game.tick.duration` p95 < 50 ms ([[OpenTelemetry]]) | 99% | Server-side quality — degrades under load BEFORE players notice |
| Connect latency | `game.ws.rtt` p95 < 150 ms | 99.5% | The player-facing promise |
| Chatbot latency | [[Gemini Chatbot]] span p95 < 3 s | 95% | The AI-observability SLO |
| Site availability | probe VM checks ([[Azure Free Account]]) | 99.9% | Classic uptime, cheap to keep |

## The demo mechanic ([[07 Demo Script]])

Chaos kill → connected players drop → error budget burns visibly → problem opens →
[[Dynatrace Workflows|Workflow]] fires → [[Agones]] replacement absorbs players → burn stops.
Screenshot the burn-down curve: that picture IS the interview answer to "explain error budgets."

Design notes: choose evaluation windows short enough to see burn during a 5-min demo
(fast-burn rate alert), long enough to be honest (7-day budget).
