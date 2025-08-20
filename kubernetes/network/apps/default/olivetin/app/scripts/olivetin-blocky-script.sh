#!/usr/bin/env bash

ACTION=$1
DURATION=$2
BLOCKY_GROUPS=$3 # this should be not required with v0.24, but it is now. use 'ads'

for host in castor pollux; do
    case "$ACTION" in
        status)
            echo -n "${host}: " && ssh ${host} /usr/bin/blocky blocking status
        ;;
        enable)
            echo -n "${host}: " && ssh ${host} /usr/bin/blocky blocking enable
        ;;
        disable)
            if [ -z "$DURATION" ]; then
                echo -n "${host}: " && ssh ${host} /usr/bin/blocky blocking disable --groups "$BLOCKY_GROUPS"
            else
                echo -n "${host}: " && ssh ${host} /usr/bin/blocky blocking disable --duration "$DURATION" --groups "$BLOCKY_GROUPS"
            fi
        ;;
    esac
done
