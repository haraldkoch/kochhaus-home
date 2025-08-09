#!/usr/bin/env bash

set -o nounset
set -o errexit

# we rely on ZFS snapshots for versioning
config_filename="opnsense-backup.xml"

echo "Download Opnsense config file ..."
curl -fsSL \
    --user "${OPNSENSE_KEY}:${OPNSENSE_SECRET}" \
    --output "/tmp/${config_filename}" \
    "${OPNSENSE_URL}/api/backup/backup/download"

/bin/ls -l "/tmp/${config_filename}"

echo "Save backup to disk ..."
cp "/tmp/${config_filename}" "/data/${config_filename}"
