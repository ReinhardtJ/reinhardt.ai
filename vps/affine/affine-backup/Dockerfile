# Use minimal Alpine Linux as base image
FROM alpine:latest

# Install rclone, tzdata, dcron, and postgresql-client for database backups
RUN apk add --no-cache rclone tzdata dcron postgresql-client

# Set timezone to German time
ENV TZ=Europe/Berlin

# Set up static rclone configuration using environment variables
ENV RCLONE_CONFIG_REMOTE_TYPE=sftp
ENV RCLONE_CONFIG_REMOTE_KEY_FILE=/root/.ssh/id_rsa
ENV RCLONE_CONFIG_REMOTE_USE_INSECURE_CIPHER=false
ENV RCLONE_CONFIG_REMOTE_SET_MODTIME=true

# Copy scripts into container
COPY backup.sh /backup.sh
COPY init.sh /init.sh

# Make scripts executable
RUN chmod +x /backup.sh /init.sh

# Set working directory
WORKDIR /data

# Run initialization script
CMD ["/init.sh"]