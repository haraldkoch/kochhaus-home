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
  - [external-dns](https://github.com/kubernetes-sigs/external-dns): monitors service and ingress resources, and automatically generates DNS updates for them. This lets me maintain DNS mappings and LetsEncrypt certificates without a cloudflare account or domain.
  - [docker-registry](https://github.com/twuni/docker-registry.helm): Private docker registry.
  - [nfs-subdir-external-provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner): creates Persistent Volumes on a pre-existing NFS mount.
  - [democratic-csi](https://github.com/democratic-csi/democratic-csi): creates Persistent Volumes on a ZFS server as separate datasets, and exports them via NFS to the Kubernetes cluter.
  - [system-upgrade-controller](https://github.com/rancher/system-upgrade-controller): Automatically upgrade the K3S kubernetes instance.

## Applications

  - [openweathermap-exporter](https://github.com/blackrez/openweathermap_exporter): a Prometheus exporter for Openweather.
  - [weather-exporter](https://github.com/celliott/weather_exporter): the much older weather exporter using the DarkSky API.
  - [tautulli](https://github.com/Tautulli/Tautulli): Plex usage monitoring application.

Yes, this is a lot of infrastructure and heavy lifting to run two small Docker containers. That's not the point; the point is to experiment with Kubernetes and GitOps in a safe space.

[![dexhorthy](assets/blog-on-kubernetes.png)](https://twitter.com/dexhorthy/status/856639005462417409)

I have two longer-term goals:

  1. migrate many of the apps that I currently run on Linode to a K8S cluster at Linode or Digital Ocean.
  2. Build a small Raspberry Pi cluster at home to run all of this infrastructure, including pi-hole, homeassistant, and maybe even plex!

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
