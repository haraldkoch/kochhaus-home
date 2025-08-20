#!/usr/bin/env bash

ACTION=$1
DURATION=$2
BLOCKY_GROUPS=$3 # this should be not required with v0.24, but it is now. use 'ads'

for pod in $BLOCKY_PODS; do
    case "$ACTION" in
        status)
            echo -n "castor: " && ssh castor /usr/bin/blocky blocking status
            echo -n "pollux: " && ssh pollux /usr/bin/blocky blocking status
        ;;
        enable)
            echo -n "castor: " && ssh castor /usr/bin/blocky blocking enable
            echo -n "pollux: " && ssh pollux /usr/bin/blocky blocking enable
        ;;
        disable)
            if [ -z "$DURATION" ]; then
                echo -n "castor: " && ssh castor /usr/bin/blocky blocking disable --groups "$BLOCKY_GROUPS"
                echo -n "pollux: " && ssh pollux /usr/bin/blocky blocking disable --groups "$BLOCKY_GROUPS"
            else
                echo -n "castor: " && ssh castor /usr/bin/blocky blocking disable --duration "$DURATION" --groups "$BLOCKY_GROUPS"
                echo -n "pollux: " && ssh pollux /usr/bin/blocky blocking disable --duration "$DURATION" --groups "$BLOCKY_GROUPS"
            fi
        ;;
    esac
done
