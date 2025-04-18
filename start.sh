#!/bin/sh
# Ensure environment variables are loaded properly
export $(cat /etc/environment | xargs)

# Run the Python script immediately
/usr/local/bin/python /app/cf_ddns_upnp.py

# Start cron in the foreground (for periodic runs)
cron -f
