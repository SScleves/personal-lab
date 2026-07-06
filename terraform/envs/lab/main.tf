# One environment: lab. Modules light up phase by phase.

module "azure_state" {
  source = "../../modules/azure-state"
  # Phase 1 — resource group + storage account + tfstate container (free tier)
  location             = var.location
  storage_account_name = var.storage_account_name
}

# module "oci_cluster" {
#   source = "../../modules/oci-cluster"
#   # Phase 2 — always-free A1 VM + network + cloud-init that installs k3s
# }

# module "dynatrace_config" {
#   source = "../../modules/dynatrace-config"
#   # Phase 3 — SLOs (tick rate, latency), Workflows, alerting profiles.
#   # EVERYTHING as code: tenant dies in October → re-apply to a new one in minutes.
# }

# module "newrelic_config" {
#   source = "../../modules/newrelic-config"
#   # Phase 4 — ingest drop rule + 50 GB guard alert + parity dashboards
# }

# module "grafana_cloud" {
#   source = "../../modules/grafana-cloud"
#   # Phase 4 — OTLP datasource wiring, comparison dashboards
# }
