#!/bin/bash
#
# Install rmagick 2.15.4 and runtime dependencies.
set -ex

RMAGICK_VERSION=${RMAGICK_VERSION:-2.15.4}

apt-get install -y --no-install-recommends \
    imagemagick \
    libmagickwand-6.q16-2 \
    libmagickwand-6.q16-dev

gem install rmagick -v "$RMAGICK_VERSION" --no-ri --no-rdoc

apt-get purge -y --auto-remove libmagickwand-6.q16-dev
