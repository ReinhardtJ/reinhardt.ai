# Use minimal Alpine Linux as base image
FROM alpine:latest

# Install rclone, cron and envsubst for config templating
RUN apk add --no-cache rclone tzdata gettext && \
    # Create directories
    mkdir -p /config/rclone /scripts /logs

# Copy the sync script and config template
COPY backup_immich.sh /scripts/backup_immich.sh
COPY rclone.conf.template /templates/rclone.conf.template

# Make scripts executable
RUN chmod +x /scripts/*.sh

# Add cron job to run at 8 PM daily
RUN echo "0 20 * * * /scripts/backup_immich.sh" > /etc/crontabs/root

# Create a volume for the immich library (will be mounted read-only at runtime)
VOLUME ["/immich-library"]

# Set the working directory
WORKDIR /data

# Entrypoint script to handle configuration
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

# Start crond in the foreground
CMD ["crond", "-f"]
