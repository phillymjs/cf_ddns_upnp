# Use an official lightweight Python image
FROM python:3.12-slim

# Install cron
RUN apt-get update && apt-get install -y cron && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy source files
COPY cf_ddns.py ./
COPY requirements.txt ./
COPY crontab.txt /etc/cron.d/cf_ddns_cron
COPY sample_env /app/sample_env
COPY entrypoint.sh /app/entrypoint.sh

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set correct permissions and register cron job
RUN chmod 0644 /etc/cron.d/cf_ddns_cron && \
    crontab /etc/cron.d/cf_ddns_cron

# Ensure entrypoint is executable
RUN chmod +x /app/entrypoint.sh

# Log file for cron output
RUN touch /app/cron.log

# Set entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]
