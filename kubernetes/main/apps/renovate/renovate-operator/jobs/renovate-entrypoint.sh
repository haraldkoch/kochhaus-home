#!/usr/bin/env bash
set -euo pipefail

curl -fsSL https://deb.nodesource.com/setup_24.x | bash -
apt install -y nodejs

node -v
npm -v

# helm-docs + helm-schema so chart repos can regenerate the committed README.md
# and values.schema.json from a Renovate postUpgrade task (mise run helm-docs /
# generate). Without this, a values.yaml bump in a Renovate PR leaves the chart
# docs stale and the Helm Lint (helm-docs-check) job fails.
# renovate: datasource=github-releases depName=norwoodj/helm-docs
HELM_DOCS_VERSION=1.14.2
# renovate: datasource=github-releases depName=dadav/helm-schema
HELM_SCHEMA_VERSION=0.23.4

curl -fsSL "https://github.com/norwoodj/helm-docs/releases/download/v${HELM_DOCS_VERSION#v}/helm-docs_${HELM_DOCS_VERSION#v}_Linux_x86_64.tar.gz" \
  | tar -xz -C /usr/local/bin helm-docs
curl -fsSL "https://github.com/dadav/helm-schema/releases/download/${HELM_SCHEMA_VERSION#v}/helm-schema_${HELM_SCHEMA_VERSION#v}_Linux_x86_64.tar.gz" \
  | tar -xz -C /usr/local/bin helm-schema

helm-docs --version
helm-schema --version

runuser -u ubuntu renovate
