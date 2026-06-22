terraform {
  backend "s3" {
    bucket = "terraform-state"
    key    = "harbor/harbor.tfstate"
    region = "garage"

    endpoints = {
      s3 = "http://mnemosyne:3900"
    }

    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    use_path_style              = true
    use_lockfile                = true
  }
}
