#!/usr/bin/env bash
set -Eeuo pipefail

export ROOT_DIR="$(git rev-parse --show-toplevel)"

readonly CLUSTER="${1:?}"

# Log messages with structured output
function log() {
    local lvl="${1:?}" msg="${2:?}"
    shift 2
    gum log --time=rfc3339 --structured --level "${lvl}" "[${FUNCNAME[1]}] ${msg}" "$@"
}

# Apply the Talos configuration to all the nodes
function install_talos() {
    log info "Installing Talos configuration"

    local machineconfig_file="${ROOT_DIR}/talos/${CLUSTER}/machineconfig.yaml.j2"

    if [[ ! -f ${machineconfig_file} ]]; then
        log fatal "No Talos machine files found for machineconfig" "file" "${machineconfig_file}"
    fi

    # Check if Talos nodes are present
    if ! nodes=$(talosctl config info --output yaml | yq --exit-status '.nodes | join (" ")') || [[ -z "${nodes}" ]]; then
        log fatal "No Talos nodes found"
    fi

    # Check that all nodes have a Talos configuration file
    for node in ${nodes}; do
        local node_file="${ROOT_DIR}/talos/${CLUSTER}/nodes/${node}.yaml.j2"

        if [[ ! -f "${node_file}" ]]; then
            log fatal "No Talos machine files found for node" "node" "${node}" "file" "${node_file}"
        fi
    done

    # Apply the Talos configuration to the nodes
    for node in ${nodes}; do
        local node_file="${ROOT_DIR}/talos/${CLUSTER}/nodes/${node}.yaml.j2"

        log info "Applying Talos node configuration" "node" "${node}"

        if ! machine_config=$(bash "${ROOT_DIR}/scripts/render-machine-config.sh" "${machineconfig_file}" "${node_file}" 2>/dev/null) || [[ -z "${machine_config}" ]]; then
            log fatal "Failed to render Talos node configuration" "node" "${node}" "file" "${node_file}"
        fi

        log debug "Talos node configuration rendered successfully" "node" "${node}"

        if ! output=$(echo "${machine_config}" | talosctl --nodes "${node}" apply-config --insecure --file /dev/stdin 2>&1); then
            if [[ "${output}" == *"certificate required"* ]]; then
                log warn "Talos node is already configured, skipping apply of config" "node" "${node}"
                continue
            fi
            log fatal "Failed to apply Talos node configuration" "node" "${node}" "output" "${output}"
        fi

        log info "Talos node configuration applied successfully" "node" "${node}"
    done
}

# Bootstrap Talos on a controller node
function install_kubernetes() {
    log info "Installing Kubernetes"

    if ! controller=$(talosctl config info --output yaml | yq --exit-status '.endpoints[0]') || [[ -z "${controller}" ]]; then
        log fatal "No Talos controller found"
    fi

    log debug "Talos controller discovered" "controller" "${controller}"

    until output=$(talosctl --nodes "${controller}" bootstrap 2>&1 || true) && [[ "${output}" == *"AlreadyExists"* ]]; do
        log info "Talos bootstrap in progress, waiting 5 seconds..." "controller" "${controller}"
        sleep 5
    done

    log info "Kubernetes installed successfully" "controller" "${controller}"
}

# Fetch the kubeconfig to local machine
function fetch_kubeconfig() {
    log info "Fetching kubeconfig"

    if ! controller=$(talosctl config info --output yaml | yq --exit-status '.endpoints[0]') || [[ -z "${controller}" ]]; then
        log fatal "No Talos controller found"
    fi

    if ! talosctl kubeconfig --nodes "${controller}" --force --force-context-name ${CLUSTER} kubernetes/${CLUSTER} &>/dev/null; then
        log fatal "Failed to fetch kubeconfig"
    fi

    log info "Kubeconfig fetched successfully"
}

function main() {
    install_talos
    install_kubernetes
    fetch_kubeconfig
}

main "$@"
