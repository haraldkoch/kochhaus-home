#!/bin/sh

# a brute force and ignorance script for using kopia and poor mans backup to
# snapshot my kube-prometheus-stack. This makes several assumptions about how
# the kube-prometheus-stack is configured, and probably only makes sense at KochHaus.

export NAMESPACE=monitoring

for app in alertmanager prometheus ; do
    export APP=${app}
    export VOLUME=${APP}-kps-${APP}-db-${APP}-kps-${APP}-0

    envsubst < <(cat ./hack/snapshot-job.yaml) | kubectl apply -f -
    sleep 1
    kubectl -n monitoring wait pod --for condition=ready --selector=job-name=${APP}-create-snapshot --timeout=1m
    kubectl -n monitoring logs --selector=job-name=${APP}-create-snapshot -f
    kubectl -n monitoring delete job ${APP}-create-snapshot

done
