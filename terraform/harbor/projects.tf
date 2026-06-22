locals {
  private_projects = {
    "cache" = {
      public                      = true
      vulnerability_scanning      = false
      enable_content_trust_cosign = false
      auto_sbom_generation        = false
      storage_quota               = 30
    }
    "containers" = {
      public                      = true
      vulnerability_scanning      = true
      enable_content_trust_cosign = true
      auto_sbom_generation        = true
      storage_quota               = 50
    }
    "home-ops" = {
      public                      = false
      vulnerability_scanning      = true
      enable_content_trust_cosign = true
      auto_sbom_generation        = true
      storage_quota               = 10
    }
    "kochhaus" = {
      public                      = true
      vulnerability_scanning      = true
      enable_content_trust_cosign = true
      auto_sbom_generation        = true
      storage_quota               = 10
    }
  }

  # URL pattern: registry.${CLUSTER_DOMAIN}/proxy-<name>/<original-path>
  proxy_registries = {
    # ── Common ────────────────────────────────────────────────────────
    "dockerhub"  = { endpoint_url = "https://hub.docker.com",      provider_name = "docker-hub" }
    "ghcr"       = { endpoint_url = "https://ghcr.io",             provider_name = "github" }
    "quay"       = { endpoint_url = "https://quay.io",             provider_name = "docker-registry" }
    "gcr"        = { endpoint_url = "https://gcr.io",              provider_name = "docker-registry" }
    "mirror-gcr" = { endpoint_url = "https://mirror.gcr.io",       provider_name = "docker-registry" }  # Trivy / CoreDNS / Envoy live here
    "k8s"        = { endpoint_url = "https://registry.k8s.io",     provider_name = "docker-registry" }
    "ecr-public" = { endpoint_url = "https://public.ecr.aws",      provider_name = "docker-registry" }
    "mcr"        = { endpoint_url = "https://mcr.microsoft.com",   provider_name = "docker-registry" }
    "nvcr"       = { endpoint_url = "https://nvcr.io",             provider_name = "docker-registry" }
    "cgr"        = { endpoint_url = "https://cgr.dev",             provider_name = "docker-registry" }

    # ── Forgejo / dev / VCS-hosted images ─────────────────────────────
    "forgejo"    = { endpoint_url = "https://code.forgejo.org",    provider_name = "docker-registry" }  # forgejo server image
    "codeberg"   = { endpoint_url = "https://codeberg.org",        provider_name = "docker-registry" }  # towonel-agent
    # "eleboucher" = { endpoint_url = "https://git.erwanleboucher.dev", provider_name = "docker-registry" }  # 3rd-party forgejo-runner-k8s-plugin

    # ── App-specific upstreams ────────────────────────────────────────
    "fluentbit"  = { endpoint_url = "https://cr.fluentbit.io",     provider_name = "docker-registry" }  # fluent-bit official
    "redhat"     = { endpoint_url = "https://registry.access.redhat.com", provider_name = "docker-registry" }  # UBI minimal base
    "gsoci"      = { endpoint_url = "https://gsoci.azurecr.io",    provider_name = "docker-registry" }  # giantswarm/silence-operator
  }
}

resource "harbor_project" "private" {
  for_each = local.private_projects

  name                        = each.key
  public                      = each.value.public
  vulnerability_scanning      = each.value.vulnerability_scanning
  enable_content_trust_cosign = each.value.enable_content_trust_cosign
  auto_sbom_generation        = each.value.auto_sbom_generation
  storage_quota               = each.value.storage_quota
}

resource "harbor_registry" "upstream" {
  for_each = local.proxy_registries

  name          = "upstream-${each.key}"
  endpoint_url  = each.value.endpoint_url
  provider_name = each.value.provider_name
}

resource "harbor_project" "proxy" {
  for_each = local.proxy_registries

  name                   = "proxy-${each.key}"
  public                 = true
  registry_id            = harbor_registry.upstream[each.key].registry_id
  vulnerability_scanning = false
  storage_quota          = 50
}
