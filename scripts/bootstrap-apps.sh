#!/usr/bin/env bash
set -Eeuo pipefail

source "$(dirname "${0}")/lib/common.sh"

export LOG_LEVEL="debug"
export ROOT_DIR="$(git rev-parse --show-toplevel)"

readonly CLUSTER="${1:?}"
#FIXME validate cluster

# Talos requires the nodes to be 'Ready=False' before applying resources
function wait_for_nodes() {
    log debug "Waiting for nodes to be available"

    # Skip waiting if all nodes are 'Ready=True'
    if kubectl --context ${CLUSTER} wait nodes --for=condition=Ready=True --all --timeout=10s &>/dev/null; then
        log info "Nodes are available and ready, skipping wait for nodes"
        return
    fi

    # Wait for all nodes to be 'Ready=False'
    until kubectl --context ${CLUSTER} wait nodes --for=condition=Ready=False --all --timeout=10s &>/dev/null; do
        log info "Nodes are not available, waiting for nodes to be available. Retrying in 10 seconds..."
        sleep 10
    done
}

# Namespaces to be applied before the SOPS secrets are installed
function apply_namespaces() {
    log debug "Applying namespaces"

    local -r apps_dir="${ROOT_DIR}/kubernetes/${CLUSTER}/apps"

    if [[ ! -d "${apps_dir}" ]]; then
        log error "Directory does not exist" "directory=${apps_dir}"
    fi

    for app in "${apps_dir}"/*/; do
        namespace=$(basename "${app}")

        # Check if the namespace resources are up-to-date
        if kubectl --context ${CLUSTER} get namespace "${namespace}" &>/dev/null; then
            log info "Namespace resource is up-to-date" "resource=${namespace}"
            continue
        fi

        # Apply the namespace resources
        if kustomize build --context ${CLUSTER} ${app} | yq ea -e 'select(.kind == "Namespace")' \
            | kubectl --context ${CLUSTER} apply --server-side --field-manager bootstrap --force-conflicts --filename - &>/dev/null;
        then
            log info "Namespace resource applied" "resource=${namespace}"
        else
            log error "Failed to apply namespace resource" "resource=${namespace}"
        fi
    done
}

# ConfigMaps to be applied before the helmfile charts are installed
function apply_configmaps() {
    log debug "Applying ConfigMaps"

    local -r configmaps=(
        "${ROOT_DIR}/kubernetes/${CLUSTER}/components/common/cluster-settings.yaml"
    )

    for configmap in "${configmaps[@]}"; do
        if [ ! -f "${configmap}" ]; then
            log warn "File does not exist" file "${configmap}"
            continue
        fi

        # Check if the configmap resources are up-to-date
        if kubectl --context ${CLUSTER} --namespace flux-system diff --filename "${configmap}" &>/dev/null; then
            log info "ConfigMap resource is up-to-date" "resource=$(basename "${configmap}" ".yaml")"
            continue
        fi

        # Apply configmap resources
        if kubectl --context ${CLUSTER} --namespace flux-system apply --server-side --filename "${configmap}" &>/dev/null; then
            log info "ConfigMap resource applied successfully" "resource=$(basename "${configmap}" ".yaml")"
        else
            log error "Failed to apply ConfigMap resource" "resource=$(basename "${configmap}" ".yaml")"
        fi
    done
}

# SOPS secrets to be applied before the helmfile charts are installed
function apply_sops_secrets() {
    log debug "Applying secrets"

    local -r secrets=(
        "${ROOT_DIR}/bootstrap/${CLUSTER}/github-deploy-key.sops.yaml"
        "${ROOT_DIR}/kubernetes/${CLUSTER}/components/common/sops/cluster-secrets.sops.yaml"
        "${ROOT_DIR}/kubernetes/${CLUSTER}/components/common/sops/secret.sops.yaml"
    )

    for secret in "${secrets[@]}"; do
        if [ ! -f "${secret}" ]; then
            log warn "File does not exist" "file=${secret}"
            continue
        fi

        # Check if the secret resources are up-to-date
        if sops exec-file "${secret}" "kubectl --context ${CLUSTER} --namespace flux-system diff --filename {}" &>/dev/null; then
            log info "Secret resource is up-to-date" "resource=$(basename "${secret}" ".sops.yaml")"
            continue
        fi

        # Apply secret resources
        if sops exec-file "${secret}" "kubectl --context ${CLUSTER} --namespace flux-system apply --server-side --filename {}" &>/dev/null; then
            log info "Secret resource applied successfully" "resource=$(basename "${secret}" ".sops.yaml")"
        else
            log error "Failed to apply secret resource" "resource=$(basename "${secret}" ".sops.yaml")"
        fi
    done
}

# CRDs to be applied before the helmfile charts are installed
function apply_crds() {
    log debug "Applying CRDs"

    local -r helmfile_file="${ROOT_DIR}/bootstrap/${CLUSTER}/00-crds.yaml"

    if [[ ! -f "${helmfile_file}" ]]; then
        log error "File does not exist" "file=${helmfile_file}"
    fi

    if ! helmfile --kube-context ${CLUSTER} --file "${helmfile_file}" template -q | kubectl --context ${CLUSTER} apply --server-side -f -; then
        log error "Failed to apply CRDs"
    fi

    log info "CRDs applied successfully"
}

# Apply Helm releases using helmfile
function apply_helm_releases() {
    log debug "Applying Helm releases with helmfile"

    local -r helmfile_file="${ROOT_DIR}/bootstrap/${CLUSTER}/01-apps.yaml"

    if [[ ! -f "${helmfile_file}" ]]; then
        log error "File does not exist" "file=${helmfile_file}"
    fi

    if ! helmfile --kube-context ${CLUSTER} --file "${helmfile_file}" sync --hide-notes; then
        log error "Failed to apply Helm releases"
    fi

    log info "Helm releases applied successfully"
}

function main() {
    check_cli helmfile kubectl kustomize sops

    # Apply resources and Helm releases
    wait_for_nodes
    apply_namespaces
    apply_configmaps
    apply_sops_secrets
    apply_crds
    apply_helm_releases

    log info "Congrats! The cluster ${CLUSTER} is bootstrapped and Flux is syncing the Git repository"
}

main "$@"
