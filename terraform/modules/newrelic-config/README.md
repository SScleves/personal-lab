# module newrelic-config (Phase 4)

Free tier is forever but hard-stops at 100 GB/month (full platform lockout until month rollover).
This module therefore ships, in order of importance:
1. NRQL drop rules for chatty k8s namespaces/debug logs.
2. Ingest alert at 50 GB (email — the free notification channel).
3. Parity dashboards mirroring the Dynatrace SLO views for the vendor comparison doc.
