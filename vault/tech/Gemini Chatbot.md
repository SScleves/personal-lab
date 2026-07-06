---
tags: [tech, ai, cv-keyword]
---

# Gemini Chatbot — the AI-observability story

A small Dutch-lessons chatbot (practice-sentence generator / vocab quizzer) on the existing site,
backed by a free-tier LLM, instrumented end-to-end. This is the "AI observability / AI Foundry"
interview material: real traces of real LLM calls.

## LLM choice (verified 2026-07-06 — [[Free Tier Limits]])

- **Primary: Gemini Flash class** — free tier, Google account only, no card, no expiry.
  Exact RPM/RPD now live only in the AI Studio dashboard — check after signup.
  Free-tier prompts may train Google models: fine for Dutch grammar, never paste anything personal.
- **Fallback: Groq** (llama-3.1-8b: 30 RPM / 14.4k req-day, published limits, OpenAI-compatible —
  the [[OpenTelemetry]] wrapper stays identical).
- No Anthropic free tier exists; Mistral's limits are unpublished — both rejected in Phase 0.

## Instrumentation (Phase 5, the point of the exercise)

Span per LLM call: model, prompt/completion tokens, latency, error class, (opt-in) truncated prompt.
Metrics: `llm.request.duration` p95 → its own SLO ([[Dynatrace SLOs]]), token counts per day
(a cost-shaped metric even at €0 — that's the FinOps-flavored talking point).
[[k6]] gives it gentle load for the demo. API key: serverless env var, never the repo ([[Secrets Hygiene]]).
