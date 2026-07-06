# module dynatrace-config (Phase 3)

Everything the tenant knows lives here, because the tenant is mortal (free until 2026-10):
SLOs (game tick rate, connect latency, chatbot p95), Workflows (problem → notify + annotate +
Agones allocation call), alerting profiles, management-zone/tag rules, OTLP ingest tokens (as
`sensitive` outputs, never state-committed values echoed).

Provider: dynatrace-oss/dynatrace. Auth via env vars DYNATRACE_ENV_URL / DYNATRACE_API_TOKEN.
Prefer "simple" workflows where possible — on paid DPS a standing standard workflow ≈ $22/mo.
Tenant re-apply drill: new tenant → new token → `terraform apply` → done in ~10 min. Practice it once.
