variable "onepassword_connect_token" {
  type        = string
  description = "1Password Connect token (from tofu-controller varsFrom)"
  sensitive   = true
}

variable "onepassword_connect_url" {
  type        = string
  description = "1Password Connect URL (from tofu-controller varsFrom)"
  sensitive   = true
}

variable "onepassword_vault_id" {
  type        = string
  description = "1Password vault id (from tofu-controller varsFrom)"
}

variable "harbor_url" {
  type        = string
  description = "Harbor external URL"
  default     = "https://harbor.kochhaus.dev"
}
