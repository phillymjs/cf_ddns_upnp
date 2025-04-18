FROM python:3.12-slim

# Install system dependencies
RUN apt-get update && apt-get install -y cron && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy app files
COPY cf_ddns_upnp.py /app/
COPY crontab /etc/cron.d/cf-ddns-cron
COPY requirements.txt /app/
COPY start.sh /start.sh

# Install Python dependencies
RUN pip install --no-cache-dir -r /app/requirements.txt

# Set permissions for cron and prepare data directory
RUN chmod 0644 /etc/cron.d/cf-ddns-cron && \
    chmod +x /start.sh && \
    mkdir -p /app/data && \
    crontab /etc/cron.d/cf-ddns-cron

# Start the wrapper script to load environment variables and run cron in the foreground
CMD ["/start.sh"]
