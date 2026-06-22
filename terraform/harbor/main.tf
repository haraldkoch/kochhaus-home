terraform {
  required_version = ">= 1.0"

  required_providers {
    onepassword = {
      source = "1Password/onepassword"
      version = "3.3.1"
    }

    harbor = {
      source  = "goharbor/harbor"
      version = "3.12.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.9.0"
    }
  }
}

provider "onepassword" {
  connect_token = var.onepassword_connect_token
  connect_url   = var.onepassword_connect_url
}

data "onepassword_item" "harbor_admin" {
  vault = var.onepassword_vault_id
  title = "harbor"
}

provider "harbor" {
  url      = var.harbor_url
  username = "admin"
  password = data.onepassword_item.harbor_admin.section_map[""].field_map["admin_password"].value
}
