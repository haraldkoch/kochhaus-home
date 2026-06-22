resource "harbor_config_system" "main" {
  project_creation_restriction = "adminonly"
  robot_token_expiration       = 30
  notification_enable          = true
}
