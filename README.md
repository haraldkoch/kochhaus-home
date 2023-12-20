<div>
<img src="https://github.com/kubernetes/kubernetes/raw/master/logo/logo.svg" align="left" width="144px" height="144px"/>

#### kochhaus-home - a mono-repo for my homelab

_... automated via [Flux](https://fluxcd.io), [Renovate](https://github.com/renovatebot/renovate) and [GitHub Actions](https://github.com/features/actions)_ 🐟

[![Kubernetes](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fgithub.com%2Fharaldkoch%2Fkochhaus-home%2Fraw%2Fmain%2Fkubernetes%2Fapps%2Fkube-system%2Fsystem-upgrade-controller%2Fplans%2Fserver.yaml&query=%24.spec.version&style=for-the-badge&logo=kubernetes&logoColor=white&label=%20)](https://k3s.io/)&nbsp;&nbsp;
[![Renovate](https://img.shields.io/github/actions/workflow/status/haraldkoch/kochhaus-home/renovate.yaml?branch=main&label=&logo=renovatebot&style=for-the-badge&color=blue)](https://github.com/haraldkoch/kochhaus-home/actions/workflows/renovate.yaml)

[K3S](https://k3s.io/) in a 7-node cluster running [Arch Linux](https://www.archlinux.org/).
</div>

<div align="center">

[![Age-Days](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.kochhaus.dev%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_age_days&style=flat-square&label=Age)](https://github.com/kashalls/kromgo/)&nbsp;&nbsp;
[![Uptime-Days](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.kochhaus.dev%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_uptime_days&style=flat-square&label=Uptime)](https://github.com/kashalls/kromgo/)&nbsp;&nbsp;
[![Node-Count](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.kochhaus.dev%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_node_count&style=flat-square&label=Nodes)](https://github.com/kashalls/kromgo/)&nbsp;&nbsp;
[![Pod-Count](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.kochhaus.dev%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_pod_count&style=flat-square&label=Pods)](https://github.com/kashalls/kromgo/)&nbsp;&nbsp;
[![CPU-Usage](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.kochhaus.dev%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_cpu_usage&style=flat-square&label=CPU)](https://github.com/kashalls/kromgo/)&nbsp;&nbsp;
[![Memory-Usage](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.kochhaus.dev%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_memory_usage&style=flat-square&label=Memory)](https://github.com/kashalls/kromgo/)&nbsp;&nbsp;
[![Power-Usage](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.kochhaus.dev%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_power_usage&style=flat-square&label=Power)](https://github.com/kashalls/kromgo/)

</div>

## Off-cluster support

- [registry](https://goharbor.io) - I have a separate host running Kubernetes and an instance of the Harbor container registry, configured as a pull-through cache.
- [named](https://www.isc.org/bind/) - primary home DNS running on a pair of (redundant) Raspberry Pi 3s.
- [blocky](https://github.com/0xERR0R/blocky) - lightweight ad-blocking DNS resolver - this has replaced an older Pi-Hole. Thinking of checking out NextDNS.

## Cluster components

- [Flux 2](https://github.com/fluxcd/flux2) - GitOps manager that configures the cluster entirely from this GitHub repository.
- [SOPS](https://toolkit.fluxcd.io/guides/mozilla-sops/) - Encrypts secrets which is safe to store - even to a public repository.

### Networking

- [calico](https://www.tigera.io/project-calico/) - container networking with IPv6 support and policy enforcement.
- [cert-manager](https://cert-manager.io/docs/) - Configured to create TLS certs for all ingress services automatically using LetsEncrypt.
- [external-dns](https://github.com/kubernetes-sigs/external-dns) - monitors service and ingress resources, and automatically generates DNS updates for them. This lets me maintain DNS mappings and LetsEncrypt certificates without a cloudflare account or domain.
- [metallb](https://metallb.universe.tf/) - Kubernetes Load Balancer that runs on Kubernetes.
- [nginx ingress](https://github.com/kubernetes/ingress-nginx) - Ingress controller. I used to use Traefik, but it it much more challenging to configure correctly.

### Storage

- [democratic-csi](https://github.com/democratic-csi/democratic-csi) - creates Persistent Volumes on a ZFS server as separate datasets, and exports them via NFS or iSCSI to the Kubernetes cluter.
- [nfs-subdir-external-provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner) - creates Persistent Volumes on a pre-existing NFS mount.
- [rook-ceph](https://rook.io/) - on-cluster (hyperconverged) storage - eventually this will all be on SSDs attached to the cluster nodes for low power usage.

### infrastructure

- [descheduler](https://github.com/kubernetes-sigs/descheduler) - analyzes the cluster looking for overloaded or under-utilized nodes, as well as pods violating affinity rules, and evicts them so that they will be rescheduled "correctly".
- [kube-fledged](https://github.com/senthilrch/kube-fledged) - caches critical images locally on each node for reliability during an Internet outage.
- [kured](https://github.com/weaveworks/kured) - The Kubernetes Reboot Daemon.
- [prometheus](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) - metrics, monitoring, and alerting.
- [reloader](https://github.com/stakater/Reloader) - reloads pods when a configMap and/or Secret changes - something that Flux 2 does not manage itself.
- [system-upgrade-controller](https://github.com/rancher/system-upgrade-controller) - Automatically upgrade the K3S kubernetes instance.
- [cloudnative-pg](https://cloudnative-pg.io/) - build and manage a postgresql cluster with HA and backups from a custom resource.
- [ext-postgres-operator](https://github.com/movetokube/postgres-operator) - create databases and users in an existing postgres cluster.
- [authentik](https://goauthentik.io/) - integrated authentication and user management.
- [volsync]() - data backup and restore. In a GitOps environment I don't need to backup the Kubernetes resources the way Velero and K10 do, and those tools are hard to manage. VolSync backs up my data.
- And more!

## Home Infrastructure

- [hajimari](https://github.com/toboshii/hajimari): a pretty start page with Kubernetes autodiscovery.
- [openweathermap-exporter](https://github.com/blackrez/openweathermap_exporter): a Prometheus exporter for Openweather.

## Applications

- [outline](https://www.getoutline.com/) - full featured documentation platform.
- [tautulli](https://github.com/Tautulli/Tautulli) - Plex usage monitoring application.
- [onedrive](https://github.com/abraunegg/onedrive) - syncs my OneDrive folder from Microsoft, as a local backup.
- [syncthing](https://syncthing.net/) - simple, peer-to-peer file synch app replacing Dropbox or NextCloud.
- [actions-runner](https://github.com/actions-runner-controller/actions-runner-controller) - Run GitHub Actions at home!
- [tekton](https://tekton.dev/) - simple CI/CD tooling.
- [nextcloud](https://nextcloud.com/) - Finally - moving applications from Linode to my homelab.

Yes, this is a lot of infrastructure and heavy lifting - the point is to experiment with Kubernetes and GitOps in a safe space.

[![dexhorthy](assets/blog-on-kubernetes.png)](https://twitter.com/dexhorthy/)

I have two longer-term goals:

1. migrate many of the apps that I currently run on Linode to my HomeLab.
2. Build a small Raspberry Pi cluster at home to run a lot of infrastructure, with the intent of being able to run off a small UPS during power outages.

---

## Repository structure

The Git repository contains the following directories under `cluster` and are ordered below by how Flux will apply them.

```sh
📁 cluster      # k8s cluster defined as code
├─📁 flux       # flux, gitops operator, loaded before everything
├─📁 crds       # custom resources, loaded before 📁 core and 📁 apps
├─📁 charts     # helm repos, loaded before 📁 core and 📁 apps
├─📁 config     # cluster config, loaded before 📁 core and 📁 apps
├─📁 core       # crucial apps, namespaced dir tree, loaded before 📁 apps
└─📁 apps       # regular apps, namespaced dir tree, loaded last
```

---

## Automation

- [Flux 2](https://github.com/fluxcd/flux2) - GitOps automation for Kubernetes.
- Rancher [System Upgrade Controller](https://github.com/rancher/system-upgrade-controller) to apply updates to k3s.
- [Renovate](https://github.com/renovatebot/renovate) with the help of the [k8s-at-home/renovate-helm-releases](https://github.com/k8s-at-home/renovate-helm-releases) Github action keeps my application charts and container images up-to-date.
- [Github Actions](https://docs.github.com/en/actions) automatically runs renovate.
- Many, many kubernetes operators

---

## 💻 Nodes

| Node                | Hostname | CPU             |  RAM | Storage   | Function             | Operating System |
|---------------------|----------|-----------------|------|-----------|----------------------|------------------|
| HP EliteDesk 800 G2 | k3sj | 4 Intel i5-6500T    | 16GB | 240GB SSD  | control-plane        | Arch Linux      |
| HP EliteDesk 800 G2 | k3sm | 4 Intel i5-6500T    | 16GB | 240GB SSD  | control-plane        | Arch Linux      |
| HP EliteDesk 800 G2 | k3st | 4 Intel i5-6500T    | 16GB | 240GB SSD  | control-plane        | Arch Linux      |
| Lenovo M910q tiny   | k3s0 | 4 Intel i5-6500T    | 16GB | 512GB NVMe | worker, ceph storage | Arch Linux      |
| libvirtd VM         | k3s1 | 6 AMD Ryzen 5 1600T | 16GB | 256GB HDD  | worker, ceph storage | Arch Linux      |
| Lenovo M900q tiny   | k3s2 | 4 Intel i5-6500T    | 16GB | 512GB SSD  | worker, ceph storage | Arch Linux      |
| Lenovo M910q tiny   | k3s3 | 4 Intel i5-6500T    | 16GB | 512GB NVMe | worker, ceph storage | Arch Linux      |

---

## Community

This cluster in inspired by the work of others shared at [awesome-home-kubernetes](https://github.com/k8s-at-home/awesome-home-kubernetes).
