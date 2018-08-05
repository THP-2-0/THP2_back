#!/bin/bash

set -e

/wait_for_postgres.sh

echo "Creating database if needed…"
bundle exec rails db:create
echo "Migrating everything"
bundle exec rails db:migrate
echo "Starting CMD"

exec "$@"
