resource "azurerm_resource_group" "state" {
  name     = "rg-lab-state"
  location = var.location
  tags     = local.tags
}

resource "azurerm_storage_account" "state" {
  name                            = var.storage_account_name
  resource_group_name             = azurerm_resource_group.state.name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS" # not GRS — the €0 rule
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  tags                            = local.tags
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.state.id
  container_access_type = "private"
}

locals {
  tags = {
    project = "personal-lab"
    env     = "lab"
    managed = "terraform"
  }
}
