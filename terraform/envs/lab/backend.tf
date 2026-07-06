# Remote state in Azure blob — the same pattern as work, on the free tier.
# BOOTSTRAP ORDER (chicken & egg): the storage account is created FIRST with local state
# (see modules/azure-state/README.md), then this backend block is uncommented and
# `terraform init -migrate-state` moves the state in.
#
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "rg-lab-state"
#     storage_account_name = "stlabstate<uniq>"   # globally unique, lowercase
#     container_name       = "tfstate"
#     key                  = "lab.tfstate"
#   }
# }
