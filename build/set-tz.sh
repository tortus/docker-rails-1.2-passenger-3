#!/bin/bash
set -eux

echo "$TZ" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata
