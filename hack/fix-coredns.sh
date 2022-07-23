#!/bin/sh

for resource in serviceaccount clusterrole clusterrolebinding deployment service configmap ; do
    printf "\e[1;32m%-6s\e[m\n" "Patching resource ${resource}..."
    kubectl -n kube-system patch ${resource} coredns --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-namespace": "kube-system"}}}'
    kubectl -n kube-system patch ${resource} coredns --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "coredns"}}}'
    kubectl -n kube-system patch ${resource} coredns --type=merge -p '{"metadata": {"labels": {"app.kubernetes.io/managed-by": "Helm"}}}'
done

printf "\e[1;32m%-6s\e[m\n" "Patching coredns-metrics service..."
kubectl -n kube-system patch service coredns-metrics --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-namespace": "kube-system"}}}'
kubectl -n kube-system patch service coredns-metrics --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "coredns"}}}'
kubectl -n kube-system patch service coredns-metrics --type=merge -p '{"metadata": {"labels": {"app.kubernetes.io/managed-by": "Helm"}}}'
