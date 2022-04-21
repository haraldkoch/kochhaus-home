<img src="https://raw.githubusercontent.com/kubernetes/kubernetes/master/logo/logo.svg" align="left" width="144px" height="144px">

#### kochhaus-home - Home Cloud via Flux v2 | GitOps Toolkit

> GitOps state for my cluster using flux v2

[![k8s](https://img.shields.io/badge/k8s-v1.23.3%2Bk3s1-green?style=flat-square)](https://k8s.io/)
[![GitHub last commit](https://img.shields.io/github/last-commit/haraldkoch/kochhaus-home?style=flat-square)](https://github.com/haraldkoch/kochhaus-home/main)
[![Renovate](https://github.com/haraldkoch/kochhaus-home/actions/workflows/schedule-renovate.yaml/badge.svg)](https://github.com/haraldkoch/kochhaus-home/actions/workflows/schedule-renovate.yaml)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-green?logo=pre-commit&logoColor=white&style=flat-square)](https://github.com/pre-commit/pre-commit)

[K3S](https://k3s.io/) test cluster on 5 [Arch Linux](https://www.archlinux.org/) hosts. Currently I have:
- Raspberry Pi 4b (4G) - control plane
- Raspberry Pi 4b (8G) with an external SSD
- Two VMs (6G) on my homelab compute server
- One VM (6G) on my homelab backup / media server

## Off-cluster support

- [registry](https://github.com/distribution/distribution): I have a host running several instances of the OCI container registry as a pull-through cache for each of the major internet container registries.
- [blocky](https://github.com/0xERR0R/blocky): lightweight ad-blocking DNS resolver - this is replacing Pi-Hole.

## Cluster components

- [SOPS](https://toolkit.fluxcd.io/guides/mozilla-sops/): Encrypts secrets which is safe to store - even to a public repository.
- [calico](https://www.tigera.io/project-calico/): container networking with policy enforcement.
- [metallb](https://metallb.universe.tf/): Kubernetes Load Balancer that runs on Kubernetes.
- [external-dns](https://github.com/kubernetes-sigs/external-dns): monitors service and ingress resources, and automatically generates DNS updates for them. This lets me maintain DNS mappings and LetsEncrypt certificates without a cloudflare account or domain.
- [cert-manager](https://cert-manager.io/docs/): Configured to create TLS certs for all ingress services automatically using LetsEncrypt.
- [traefik ingress](https://doc.traefik.io/traefik/providers/kubernetes-ingress/): Ingress controller based on Traefik (but not Rancher's default)
- [nfs-subdir-external-provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner): creates Persistent Volumes on a pre-existing NFS mount.
- [democratic-csi](https://github.com/democratic-csi/democratic-csi): creates Persistent Volumes on a ZFS server as separate datasets, and exports them via NFS to the Kubernetes cluter.
- [rook-ceph](https://rook.io/): on-cluster (hyperconverged) storage - eventually this will all be on SSDs attached to the cluster nodes for low power usage.
- [system-upgrade-controller](https://github.com/rancher/system-upgrade-controller): Automatically upgrade the K3S kubernetes instance.
- [prometheus](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack): metrics, monitoring, and alerting
- [velero](https://velero.io/): backups!
- And more!

## Home Infrastructure

- [hajimari](https://github.com/toboshii/hajimari): a pretty start page with Kubernetes autodiscovery.
- [openweathermap-exporter](https://github.com/blackrez/openweathermap_exporter): a Prometheus exporter for Openweather.
- [weather-exporter](https://github.com/celliott/weather_exporter): the much older weather exporter using the DarkSky API.

## Applications

- [bookstack](https://www.bookstackapp.com/): full featured documentation platform.
- [tautulli](https://github.com/Tautulli/Tautulli): Plex usage monitoring application.

Yes, this is a lot of infrastructure and heavy lifting - the point is to experiment with Kubernetes and GitOps in a safe space.

[![dexhorthy](assets/blog-on-kubernetes.png)](https://twitter.com/dexhorthy/status/856639005462417409)

I have two longer-term goals:

1. migrate many of the apps that I currently run on Linode to a K8S cluster at Linode or Digital Ocean.
2. Build a small Raspberry Pi cluster at home to run a lot of infrastructure, with the intent of being able to run off a small UPS during power outages.

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
