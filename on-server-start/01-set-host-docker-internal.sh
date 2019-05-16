#!/bin/bash
#
# Set host.docker.internal if not set. This version should avoid breaking it
# on OSX or Windows.
set -e

function fix_linux_internal_host {
    DOCKER_INTERNAL_HOST="host.docker.internal"
    if ! grep $DOCKER_INTERNAL_HOST /etc/hosts > /dev/null && ! nslookup host.docker.internal > /dev/null ; then
        DOCKER_INTERNAL_IP=`/sbin/ip route | awk '/default/ { print $3 }' | awk '!seen[$0]++'`
        echo -e "$DOCKER_INTERNAL_IP\t$DOCKER_INTERNAL_HOST" | tee -a /etc/hosts > /dev/null
        echo "Added $DOCKER_INTERNAL_HOST to hosts /etc/hosts"
    fi
}

fix_linux_internal_host
