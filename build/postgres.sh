#!/bin/bash
#
# Install legacy postgres gem and dependencies.
set -eux

apt-get install -y --no-install-recommends \
    libpq5 \
    libpq-dev \
    postgresql-client

gem install postgres --no-ri --no-rdoc -v 0.7.9.2008.01.28

apt-get purge -y --auto-remove \
    libpq-dev
