#!/bin/bash
set -e

if [ "$MIGRATE" = "true" ]; then
    echo "Migrating database..."
    cd /app
    setuser app rake _0.7.3_ db:migrate
fi
