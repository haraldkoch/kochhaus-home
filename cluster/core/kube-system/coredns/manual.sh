
### Run this command when building a new cluster to install coredns - otherwise
# the cluster does not have DNS services and can't download ... anything

helm template -n kube-system coredns coredns/coredns -f values.yaml |kubectl -n kube-system apply -f -


###
# Run these commands after linking the cluster to GitHub with flux 2 so that
# it stops complaining about the missing annotations

kubectl annotate -n kube-system serviceaccount coredns meta.helm.sh/release-name=coredns meta.helm.sh/release-namespace=kube-system
kubectl annotate -n kube-system clusterrole coredns meta.helm.sh/release-name=coredns meta.helm.sh/release-namespace=kube-system
kubectl annotate -n kube-system clusterrolebinding coredns meta.helm.sh/release-name=coredns meta.helm.sh/release-namespace=kube-system
kubectl annotate -n kube-system deployment coredns meta.helm.sh/release-name=coredns meta.helm.sh/release-namespace=kube-system
kubectl annotate -n kube-system service coredns meta.helm.sh/release-name=coredns meta.helm.sh/release-namespace=kube-system
kubectl annotate -n kube-system service coredns-metrics meta.helm.sh/release-name=coredns meta.helm.sh/release-namespace=kube-system
