resource "harbor_retention_policy" "private" {
  for_each = harbor_project.private

  scope    = each.value.id
  schedule = "Daily"

  rule {
    most_recently_pushed = 10
    repo_matching        = "**"
    tag_matching         = "**"
    untagged_artifacts   = false
  }

  rule {
    n_days_since_last_pull = 30
    repo_matching          = "**"
    tag_matching           = "**"
    untagged_artifacts     = false
  }
}

resource "harbor_retention_policy" "proxy" {
  for_each = harbor_project.proxy

  scope    = each.value.id
  schedule = "Daily"

  rule {
    most_recently_pushed  = 5
    repo_matching          = "**"
    tag_matching           = "**"
    untagged_artifacts     = true
  }
}

resource "harbor_garbage_collection" "main" {
  schedule        = "Weekly"
  delete_untagged = true
  workers         = 2
}
