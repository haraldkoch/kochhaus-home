#!/bin/sh

###
#
# This script sets the necessary metadata on CRDs created by the cloudnative-pg operator for Flux2.
#


kubectl patch customresourcedefinition backups.postgresql.cnpg.io --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-namespace": "dbms"}}}'
kubectl patch customresourcedefinition backups.postgresql.cnpg.io --type=merge -p '{"metadata": {"labels": {"app.kubernetes.io/managed-by": "Helm"}}}'
kubectl patch customresourcedefinition backups.postgresql.cnpg.io --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "cnpg"}}}'
kubectl patch customresourcedefinition clusters.postgresql.cnpg.io --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-namespace": "dbms"}}}'
kubectl patch customresourcedefinition clusters.postgresql.cnpg.io --type=merge -p '{"metadata": {"labels": {"app.kubernetes.io/managed-by": "Helm"}}}'
kubectl patch customresourcedefinition clusters.postgresql.cnpg.io --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "cnpg"}}}'
kubectl patch customresourcedefinition poolers.postgresql.cnpg.io --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-namespace": "dbms"}}}'
kubectl patch customresourcedefinition poolers.postgresql.cnpg.io --type=merge -p '{"metadata": {"labels": {"app.kubernetes.io/managed-by": "Helm"}}}'
kubectl patch customresourcedefinition poolers.postgresql.cnpg.io --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "cnpg"}}}'
kubectl patch customresourcedefinition scheduledbackups.postgresql.cnpg.io --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-namespace": "dbms"}}}'
kubectl patch customresourcedefinition scheduledbackups.postgresql.cnpg.io --type=merge -p '{"metadata": {"labels": {"app.kubernetes.io/managed-by": "Helm"}}}'
kubectl patch customresourcedefinition scheduledbackups.postgresql.cnpg.io --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "cnpg"}}}'
