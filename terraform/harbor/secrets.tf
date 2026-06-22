resource "onepassword_item" "harbor_containers_ci" {
  vault = var.onepassword_vault_id
  title = "harbor-containers-ci"

  section_map = {
    "robots" = {
      field_map = {
        "username" = {
          type = "STRING"
          value = harbor_robot_account.containers_ci.full_name
        }
        "password" = {
          type = "CONCEALED"
          value = harbor_robot_account.containers_ci.secret
        }
      }
    }
  }
}

# resource "infisical_secret" "homeops_ci_name" {
#   name         = "HARBOR_ROBOT_NAME"
#   value        = harbor_robot_account.homeops_ci.full_name
#   env_slug     = "prod"
#   workspace_id = var.infisical_workspace_id
#   folder_path  = "/kubernetes/harbor/robots/home-ops"

#   depends_on = [infisical_secret_folder.robot]
# }

# resource "infisical_secret" "homeops_ci_token" {
#   name         = "HARBOR_ROBOT_TOKEN"
#   value        = harbor_robot_account.homeops_ci.secret
#   env_slug     = "prod"
#   workspace_id = var.infisical_workspace_id
#   folder_path  = "/kubernetes/harbor/robots/home-ops"

#   depends_on = [infisical_secret_folder.robot]
# }

# resource "infisical_secret" "cluster_puller_name" {
#   name         = "HARBOR_ROBOT_NAME"
#   value        = harbor_robot_account.cluster_puller.full_name
#   env_slug     = "prod"
#   workspace_id = var.infisical_workspace_id
#   folder_path  = "/kubernetes/harbor/robots/cluster-puller"

#   depends_on = [infisical_secret_folder.robot]
# }

# resource "infisical_secret" "cluster_puller_token" {
#   name         = "HARBOR_ROBOT_TOKEN"
#   value        = harbor_robot_account.cluster_puller.secret
#   env_slug     = "prod"
#   workspace_id = var.infisical_workspace_id
#   folder_path  = "/kubernetes/harbor/robots/cluster-puller"

#   depends_on = [infisical_secret_folder.robot]
# }

# resource "infisical_secret" "kochhaus_ci_name" {
#   name         = "HARBOR_ROBOT_NAME"
#   value        = harbor_robot_account.kochhaus_ci.full_name
#   env_slug     = "prod"
#   workspace_id = var.infisical_workspace_id
#   folder_path  = "/kubernetes/harbor/robots/kochhaus"

#   depends_on = [infisical_secret_folder.robot]
# }

# resource "infisical_secret" "kochhaus_ci_token" {
#   name         = "HARBOR_ROBOT_TOKEN"
#   value        = harbor_robot_account.kochhaus_ci.secret
#   env_slug     = "prod"
#   workspace_id = var.infisical_workspace_id
#   folder_path  = "/kubernetes/harbor/robots/kochhaus"

#   depends_on = [infisical_secret_folder.robot]
# }
