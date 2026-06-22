resource "harbor_config_auth" "oidc" {
  auth_mode          = "oidc_auth"
  primary_auth_mode  = true
  oidc_name          = "Authelia"
  oidc_endpoint      = "https://auth.kochhaus.dev"
  oidc_client_id     = data.onepassword_item.harbor_admin.section_map["oidc"].field_map["client_id"].value
  oidc_client_secret = data.onepassword_item.harbor_admin.section_map["oidc"].field_map["client_secret"].value
  oidc_scope         = "openid,profile,email,groups"
  oidc_verify_cert   = true
  oidc_auto_onboard  = true
  oidc_user_claim    = "preferred_username"
  oidc_groups_claim  = "groups"
  oidc_admin_group   = "admins"
  oidc_logout        = true
}
