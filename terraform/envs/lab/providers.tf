terraform {
  required_version = ">= 1.9.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    oci = {
      source  = "oracle/oci"
      version = "~> 6.0"
    }
    dynatrace = {
      source  = "dynatrace-oss/dynatrace"
      version = "~> 1.70"
    }
    # newrelic + grafana providers join in phases 3-4
  }
}

provider "azurerm" {
  features {}
}

# provider "oci" {}        # enabled in Phase 2 (needs ~/.oci config or env auth)
# provider "dynatrace" {}  # enabled in Phase 3 (DYNATRACE_ENV_URL + DYNATRACE_API_TOKEN env vars)
