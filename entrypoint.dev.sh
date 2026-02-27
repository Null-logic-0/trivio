#!/bin/sh
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Wait for DB to be ready
echo "Waiting for database..."
until bundle exec rails db:version >/dev/null 2>&1; do
  echo "Database not ready, sleeping 2s..."
  sleep 2
done

# Install Ruby gems if not installed yet
if [ ! -f /usr/local/bundle/config ]; then
  echo "Installing Ruby gems..."
  bundle check || bundle install
fi

# Run pending migrations (only for web container)
if [ "$RAILS_ENV" = "development" ] && [ "$1" = "rails" ]; then
  echo "Running migrations..."
  bundle exec rails db:migrate 2>/dev/null || echo "No pending migrations."

  # Seed database
  if [ -f db/seeds.rb ]; then
    echo "Seeding database..."
    bundle exec rails db:seed
  fi
fi

# Start the main process (rails server or sidekiq)
exec "$@"
