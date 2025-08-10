#!/bin/sh

# Create log directory if it doesn't exist
mkdir -p /immich-backup
mkdir -p /immich-db-backups
mkdir -p /immich-backup-logs

# Create SSH directory with proper permissions
mkdir -p /root/.ssh
chmod 700 /root/.ssh

# Write the SSH private key to file using printf to preserve formatting
# This handles multi-line keys better than echo
printf "%s\n" "$RCLONE_SSH_KEY" > /root/.ssh/id_rsa
# Set secure permissions on private key (readable only by owner)
chmod 600 /root/.ssh/id_rsa

# Set up dynamic rclone configuration using environment variables
export RCLONE_CONFIG_REMOTE_HOST="$RCLONE_REMOTE_HOST"     # Target server hostname/IP
export RCLONE_CONFIG_REMOTE_USER="$RCLONE_REMOTE_USER"     # SSH username

# Add cron job for daily backup at 20:00 German time
echo "0 20 * * * /backup.sh" > /tmp/crontab
crontab /tmp/crontab

# Start cron daemon and keep container running
crond -f