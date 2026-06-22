resource "harbor_interrogation_services" "main" {
  vulnerability_scan_policy = "Daily"
  default_scanner           = "Trivy"
}
