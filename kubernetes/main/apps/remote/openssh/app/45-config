#!/usr/bin/with-contenv bash

# This script copies files from the volumeMount at /ssh to the
# /config/ssh_host_keys folder used by the linuxserver.io openssh container.
# We cannot simply use a mount directly in /config, because of file
# permissions problems; the container expects the foler to be writeable.
#
# This script needs to run before /etc/cont-init.d/50-config.

mkdir -p /config/ssh_host_keys

cp -L /sshd/* /config/ssh_host_keys

# sshd will not run if host keys are group or other readable.
chmod 400 /config/ssh_host_keys/ssh_host*key
chmod 600 /config/ssh_host_keys/ssh*_config
