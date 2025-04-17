#!/bin/bash

# Ensure /app/data exists
mkdir -p /app/data

# If .env doesn't exist in /app/data, copy sample
if [ ! -f /app/data/.env ]; then
  echo "Copying sample_env to data/.env"
  cp /app/sample_env /app/data/.env
fi

# Symlink .env from data to project root if needed
if [ ! -f /app/.env ]; then
  ln -s /app/data/.env /app/.env
fi

# Run script immediately, then start cron
python /app/cf_ddns.py
cron -f