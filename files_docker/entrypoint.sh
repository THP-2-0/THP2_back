#!/bin/bash

set -e

/wait_for_postgres.sh

echo "Creating database if needed…"
rails db:create
echo "Migrating everything"
rails db:migrate
echo "Starting CMD"

exec "$@"
