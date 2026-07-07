---
tags: [runbook, stretch]
---

# R5 · Stretch — analytics + AI: Databricks, Airflow, Gemini chatbot, (Azure AI Foundry)

Independent blocks — do them in any order after R3. Each ends visibly demonstrable.

## Block 1 — Databricks Free Edition (telemetry analytics)

1. **[SANTI]** databricks.com/learn/free-edition → sign up (personal email/Google — no card).
2. **[VERIFY-FIRST]** Free Edition limits page (fair-use compute cutoff still daily? volumes
   still the ingest path? DBFS still absent?) — re-verify, it changed once already (CE→Free).
3. Collector: add file exporter writing rolling JSON to a hostPath on the VM (staging dir).
4. Nightly export job (k8s CronJob first, Airflow later): roll up yesterday's file →
   Parquet (tiny Python + pyarrow container, arm64) → upload via Databricks SDK
   (**[SANTI]** PAT from Free Edition → k8s secret).
5. In Databricks: UC Volume `lab/telemetry` → `COPY INTO` a Delta table → one SQL dashboard:
   players vs tick p95 vs SLO burns per day. 📸 — the job-offer keyword, demonstrated.

## Block 2 — Airflow via Astronomer trial → local Astro CLI

6. Build the DAG LOCALLY first (astro CLI, free): `winget install Astronomer.Astro` **[VERIFY-FIRST]**
   winget id — else the curl install per astronomer docs → `astro dev init/start` → port the
   step-4 export into a DAG (extract → parquet → upload), make it idempotent (rerun yesterday safely).
7. **[SANTI]** THEN the 14-day trial (astronomer.io — no card): deploy the same DAG, taste the
   hosted product, 📸 the deployment. **Export config before day 14 — hard deletion ~day 17.**
8. Instrument the DAG (OTel or at minimum task-duration → Dynatrace via API) — observing the
   orchestrator is its own bullet.

## Block 3 — Gemini chatbot on the Dutch site (the AI-observability story)

9. **[SANTI]** aistudio.google.com → API key (plain Google account) → check the live rate
   limits in the AI Studio dashboard (they're not published anymore — record what YOURS says).
10. Tiny API: one FastAPI/Express pod on the cluster `POST /chat` → Gemini Flash
    (**[VERIFY-FIRST]** current flash model id from the AI Studio docs page), key via k8s secret.
    NEVER the key in the static site — Pages is public source.
11. OTel spans around every LLM call: model, prompt/completion tokens (from the response
    usage block), latency, error class. Metric `llm_tokens_total` per day.
12. Dutch site: swap the BYOK Anthropic box to ALSO offer "Santi's tutor" → calls the pod
    endpoint (CORS: allow the Pages origin only).
13. SLO in Dynatrace: chatbot p95 < 3s / 95%. Gentle k6 (respect the free RPM!) to demo it. 📸
14. Groq fallback (same OpenAI-shape call) behind an env flag — vendor failover as config.

## Block 4 — Azure AI Foundry (the banked account's ONLY job)

15. **[GATE + VERIFY-FIRST]** Only if Santi wants the extra bullet: verify CURRENT AI Foundry
    free/trial terms live (never from memory), then: same chatbot, second provider via
    AI Foundry's endpoint → the comparison paragraph ("AI Studio vs AI Foundry — same bot,
    what each gives you") in the comparison doc. The Azure account does NOTHING else (GUARDRAILS 13).

**Do NOT**: exceed Databricks fair-use with sustained queries (daily cutoff) · leave the
Astro trial deployment undeleted past day 14 · put ANY API key in a public repo or the
static site · let the chatbot log full prompts with personal content into four backends.
