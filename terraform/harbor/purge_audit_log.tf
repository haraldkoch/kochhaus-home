resource "harbor_purge_audit_log" "main" {
  schedule             = "Daily"
  audit_retention_hour = 720  # 30 days
  include_event_types  = "create_artifact,delete_artifact,pull_artifact,delete"
}
