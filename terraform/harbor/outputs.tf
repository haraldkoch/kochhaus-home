output "harbor_url" {
  value = var.harbor_url
}

output "private_projects" {
  value = [for p in harbor_project.private : p.name]
}

output "proxy_projects" {
  value = {
    for k, p in harbor_project.proxy :
    k => "${trimprefix(var.harbor_url, "https://")}/${p.name}"
  }
}
