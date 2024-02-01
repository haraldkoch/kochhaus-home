Manual Configuration (prior to flux)
====================================

In order to run our own configurable coredns chart in k3s, the default coredns
deployment is disabled in the k3s bootstrap. But when it is disabled, the
cluster has no DNS servers and cannot bootstrap flux!

This command will bootstrap coredns into the cluster, using the same settings
as the ones flux will eventually apply.

    yq .spec.values kubernetes/main/apps/kube-system/coredns/app/helmrelease.yaml \
      | helm template -n kube-system coredns coredns/coredns -f - \
      | kubectl -n kube-system apply -f -

One flux is bootstrapping the cluster, it will fail reconciling the helm chart because of missing annotations. Run the following to fix the missing annotations:

    kubectl -n kube-system patch serviceaccount coredns --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-namespace": "kube-system"}}}'
    kubectl -n kube-system patch serviceaccount coredns --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "coredns"}}}'
    kubectl -n kube-system patch serviceaccount coredns --type=merge -p '{"metadata": {"labels": {"app.kubernetes.io/managed-by": "Helm"}}}'
    kubectl -n kube-system patch clusterrole coredns --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-namespace": "kube-system"}}}'
    kubectl -n kube-system patch clusterrole coredns --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "coredns"}}}'
    kubectl -n kube-system patch clusterrole coredns --type=merge -p '{"metadata": {"labels": {"app.kubernetes.io/managed-by": "Helm"}}}'
    kubectl -n kube-system patch clusterrolebinding coredns --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-namespace": "kube-system"}}}'
    kubectl -n kube-system patch clusterrolebinding coredns --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "coredns"}}}'
    kubectl -n kube-system patch clusterrolebinding coredns --type=merge -p '{"metadata": {"labels": {"app.kubernetes.io/managed-by": "Helm"}}}'
    kubectl -n kube-system patch deployment coredns --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-namespace": "kube-system"}}}'
    kubectl -n kube-system patch deployment coredns --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "coredns"}}}'
    kubectl -n kube-system patch deployment coredns --type=merge -p '{"metadata": {"labels": {"app.kubernetes.io/managed-by": "Helm"}}}'
    kubectl -n kube-system patch service coredns --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-namespace": "kube-system"}}}'
    kubectl -n kube-system patch service coredns --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "coredns"}}}'
    kubectl -n kube-system patch service coredns --type=merge -p '{"metadata": {"labels": {"app.kubernetes.io/managed-by": "Helm"}}}'
    kubectl -n kube-system patch configmap coredns --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-namespace": "kube-system"}}}'
    kubectl -n kube-system patch configmap coredns --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "coredns"}}}'
    kubectl -n kube-system patch configmap coredns --type=merge -p '{"metadata": {"labels": {"app.kubernetes.io/managed-by": "Helm"}}}'
