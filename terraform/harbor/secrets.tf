resource "onepassword_item" "harbor_containers_ci" {
  vault = var.onepassword_vault_id
  title = "harbor-containers-ci"
  category = "secure_note"

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

resource "onepassword_item" "harbor_homeops_ci" {
  vault = var.onepassword_vault_id
  title = "harbor-homeops-ci"
  category = "secure_note"

  section_map = {
    "robots" = {
      field_map = {
        "username" = {
          type = "STRING"
          value = harbor_robot_account.homeops_ci.full_name
        }
        "password" = {
          type = "CONCEALED"
          value = harbor_robot_account.homeops_ci.secret
        }
      }
    }
  }
}

resource "onepassword_item" "harbor_cluster_puller" {
  vault = var.onepassword_vault_id
  title = "harbor-cluster-puller"
  category = "secure_note"

  section_map = {
    "robots" = {
      field_map = {
        "username" = {
          type = "STRING"
          value = harbor_robot_account.cluster_puller.full_name
        }
        "password" = {
          type = "CONCEALED"
          value = harbor_robot_account.cluster_puller.secret
        }
      }
    }
  }
}

resource "onepassword_item" "harbor_kochhaus_ci" {
  vault = var.onepassword_vault_id
  title = "harbor-kochhaus-ci"
  category = "secure_note"

  section_map = {
    "robots" = {
      field_map = {
        "username" = {
          type = "STRING"
          value = harbor_robot_account.kochhaus_ci.full_name
        }
        "password" = {
          type = "CONCEALED"
          value = harbor_robot_account.kochhaus_ci.secret
        }
      }
    }
  }
}
