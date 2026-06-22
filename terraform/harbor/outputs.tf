output "harbor_url" {
  value = var.harbor_url
}

# output "private_projects" {
#   value = [for p in harbor_project.private : p.name]
# }

# output "proxy_projects" {
#   value = {
#     for k, p in harbor_project.proxy :
#     k => "${trimprefix(var.harbor_url, "https://")}/${p.name}"
#   }
# }

# output "robot_paths" {
#   value = {
#     containers     = "/kubernetes/harbor/robots/containers"
#     home_ops       = "/kubernetes/harbor/robots/home-ops"
#     cluster_puller = "/kubernetes/harbor/robots/cluster-puller"
#     vroxide        = "/kubernetes/harbor/robots/vroxide"
#   }
# }
