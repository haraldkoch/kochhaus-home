#!/bin/sh

curl https://${DYNDNS_USERNAME}:${DYNDNS_PASSWORD}@${DYNDNS_SERVER}/nic/update?hostname=${DYNDNS_HOSTNAME}
