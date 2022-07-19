#!/bin/sh

# a brute force and ignorance script for restoring a kopia / poor mans backup
# of kube-prometheus-stack. This makes several assumptions about how the
# kube-prometheus-stack is configured, and probably only makes sense at KochHaus.

export NAMESPACE=monitoring

flux -n monitoring suspend helmrelease kube-prometheus-stack

for app in alertmanager prometheus; do

    export APP=${app}
    export VOLUME=${APP}-kps-${APP}-db-${APP}-kps-${APP}-0
        export SNAPSHOT=$(kubectl exec deployments/kopia -- kopia snapshot list /${APP} --json | jq --raw-output '.[-1] | .id')

    # kubectl -n monitoring scale statefulset ${APP}-kps-${APP} --replicas=0
    # we cannot just scale the statefulset because the prometheus-operator will fix it right away.
        # conveniently, the CRDs have the same name as the application
    kubectl -n monitoring patch ${APP} kps-${APP} --type="merge" -p '{"spec": {"replicas": 0}}'
    kubectl -n monitoring wait pod --for delete --selector="app.kubernetes.io/name=${APP}" --timeout=2m
    envsubst < <(cat ./hack/restore-job.yaml) | kubectl apply -f -
    sleep 1
    kubectl -n monitoring wait job --for condition=complete ${APP}-restore-snapshot --timeout=120m
    kubectl -n monitoring logs job/${APP}-restore-snapshot
    kubectl -n monitoring delete job ${APP}-restore-snapshot

    kubectl -n monitoring patch ${APP} kps-${APP} --type="merge" -p '{"spec": {"replicas": 1}}'

done

flux -n monitoring resume helmrelease kube-prometheus-stack
