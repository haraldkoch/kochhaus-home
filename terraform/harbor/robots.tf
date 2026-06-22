resource "harbor_robot_account" "containers_ci" {
  name        = "containers-ci"
  description = "CI push token for 'containers' + shared 'cache' projects"
  level       = "system"
  duration    = -1

  permissions {
    access {
      action   = "push"
      resource = "repository"
    }
    access {
      action   = "pull"
      resource = "repository"
    }
    kind      = "project"
    namespace = harbor_project.private["cache"].name
  }

  permissions {
    access {
      action   = "push"
      resource = "repository"
    }
    access {
      action   = "pull"
      resource = "repository"
    }
    kind      = "project"
    namespace = harbor_project.private["containers"].name
  }
}

# resource "harbor_robot_account" "homeops_ci" {
#   name        = "home-ops-ci"
#   description = "CI push token for project 'home-ops' (Flux OCI sync)"
#   level       = "project"
#   duration    = -1

#   permissions {
#     access {
#       action   = "push"
#       resource = "repository"
#     }
#     access {
#       action   = "pull"
#       resource = "repository"
#     }
#     kind      = "project"
#     namespace = harbor_project.private["home-ops"].name
#   }
# }

# resource "harbor_robot_account" "cluster_puller" {
#   name        = "cluster-puller"
#   description = "Cluster-wide pull token for Flux OCIRepository and pod imagePullSecrets"
#   level       = "system"
#   duration    = -1

#   permissions {
#     access {
#       action   = "pull"
#       resource = "repository"
#     }
#     kind      = "project"
#     namespace = "*"
#   }
# }

# resource "harbor_robot_account" "kochhaus_ci" {
#   name        = "kochhaus-ci"
#   description = "CI push token for project 'kochhaus' (signed OCI release artifacts: binaries + SBOM)"
#   level       = "system"
#   duration    = -1

#   permissions {
#     access {
#       action   = "push"
#       resource = "repository"
#     }
#     access {
#       action   = "pull"
#       resource = "repository"
#     }
#     kind      = "project"
#     namespace = harbor_project.private["kochhaus"].name
#   }
# }
