#!/bin/sh

mkdir -p /root/.ssh/
cat /var/shared-data/id_ed25519.pub > /root/.ssh/authorized_keys
service sshd restart
exec dockerd-entrypoint.sh "$@" 