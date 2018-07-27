#!/bin/bash

set -e

echo "Creating database if needed…"
rails db:create
echo "Migrating everything"
rails db:migrate
echo "Starting CMD"

exec "$@"
