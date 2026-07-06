variable "location" {
  type        = string
  description = "Azure region for the state resources"
  default     = "westeurope"
}

variable "storage_account_name" {
  type        = string
  description = "Globally unique, lowercase, 3-24 chars, e.g. stlabstatesscleves"

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "Lowercase letters and digits only, 3-24 characters."
  }
}
