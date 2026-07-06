variable "location" {
  type        = string
  description = "Azure region"
  default     = "westeurope"
}

variable "storage_account_name" {
  type        = string
  description = "Globally unique tfstate storage account name (see example.tfvars)"
}
