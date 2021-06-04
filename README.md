<img src="https://raw.githubusercontent.com/kubernetes/kubernetes/master/logo/logo.svg" align="left" width="144px" height="144px">

#### kochhaus-home - Home Cloud via Flux v2 | GitOps Toolkit
> GitOps state for my cluster using flux v2

[![k8s](https://img.shields.io/badge/k8s-v1.20.5%2Bk3s1-green?style=flat-square)](https://k8s.io/)
[![GitHub last commit](https://img.shields.io/github/last-commit/haraldkoch/kochhaus-home?style=flat-square)](https://github.com/haraldkoch/kochhaus-home/main)
[![Renovate](https://github.com/haraldkoch/kochhaus-home/actions/workflows/renovate.yaml/badge.svg)](https://github.com/haraldkoch/kochhaus-home/actions/workflows/renovate.yaml)
[![Update Flux](https://github.com/haraldkoch/kochhaus-home/actions/workflows/flux-schedule.yaml/badge.svg)](https://github.com/haraldkoch/kochhaus-home/actions/workflows/flux-schedule.yaml)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-green?logo=pre-commit&logoColor=white&style=flat-square)](https://github.com/pre-commit/pre-commit)

[K3S](https://k3s.io/) test "cluster" on a single [Arch Linux](https://www.archlinux.org/) host on my homelab server.

## Cluster components

  - [SOPS](https://toolkit.fluxcd.io/guides/mozilla-sops/): Encrypts secrets which is safe to store - even to a public repository.
  - [cert-manager](https://cert-manager.io/docs/): Configured to create TLS certs for all ingress services automatically using LetsEncrypt.
  - [metallb](https://metallb.universe.tf/): Kubernetes Load Balancer that runs on Kubernetes.
  - [nginx ingress](https://kubernetes.github.io/ingress-nginx/): Ingress controller that uses NGINX (instead of Rancher's default Traefik).
  - [homer](https://github.com/bastienwirtz/homer): a simple home page builder using YAML.

## Applications

---

## Repository structure

The Git repository contains the following directories under `cluster` and are ordered below by how Flux will apply them.

- **base** directory is the entrypoint to Flux
- **crds** directory contains custom resource definitions (CRDs) that need to exist globally in your cluster before anything else exists
- **core** directory (depends on **crds**) are important infrastructure applications (grouped by namespace) that should never be pruned by Flux
- **apps** directory (depends on **core**) is where your common applications (grouped by namespace) could be placed, Flux will prune resources here if they are not tracked by Git anymore

```
./cluster
├── ./apps
├── ./base
├── ./core
└── ./crds
```

---

## Automation

- Rancher [System Upgrade Controller](https://github.com/rancher/system-upgrade-controller) to apply updates to k3s
- [Renovate](https://github.com/renovatebot/renovate) with the help of the [k8s-at-home/renovate-helm-releases](https://github.com/k8s-at-home/renovate-helm-releases) Github action keeps my application charts and container images up-to-date
- [Github Actions](https://docs.github.com/en/actions) automatically runs renovate

---

## Community

This cluster in inspired by the work of others shared at [awesome-home-kubernetes](https://github.com/k8s-at-home/awesome-home-kubernetes).
