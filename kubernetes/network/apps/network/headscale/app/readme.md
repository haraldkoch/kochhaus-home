# Headscale

My configuration is encrypted, so here's a sanitized version:

    server_url: https://hs.${SECRET_DOMAIN}
    listen_addr: 0.0.0.0:8080
    metrics_listen_addr: 0.0.0.0:9090
    # disable TLS - nginx handles it
    tls_cert_path: ""
    tls_key_path: ""
    private_key_path: /var/lib/headscale/private.key
    noise:
      private_key_path: /var/lib/headscale/noise_private.key
    prefixes:
      v6: fd7a:115c:a1e0::/48
      v4: 100.64.0.0/10
    derp:
      server:
        enabled: false
      urls:
        - https://controlplane.tailscale.com/derpmap/default
      auto_update_enabled: true
      update_frequency: 24h
    disable_check_updates: false
    ephemeral_node_inactivity_timeout: 30m
    database:
      type: sqlite
      sqlite:
        path: /var/lib/headscale/db.sqlite
    # TODO: Remove after 0.23.0
    db_type: sqlite3
    db_path: /var/lib/headscale/db.sqlite
    dns_config:
      # Whether to prefer using Headscale provided DNS or use local.
      override_local_dns: true
      # List of DNS servers to expose to clients.
      nameservers:
        - 192.168.20.1
      domains: []
      magic_dns: true
      base_domain: ${SECRET_DOMAIN}
    log:
      level: info
    oidc:
      only_start_if_oidc_is_available: true
      issuer: https://auth.${SECRET_DOMAIN}
      client_id: ${HEADSCALE_OIDC_CLIENT_ID}
      client_secret: ${HEADSCALE_OIDC_CLIENT_SECRET}
      scope: ["openid", "profile", "email", "groups"]
      allowed_groups:
        - headscale
      strip_email_domain: true
