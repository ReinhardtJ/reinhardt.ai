#!/bin/sh
set -e

# Create rclone config directory if it doesn't exist
mkdir -p /config/rclone

# Generate rclone config from template if it doesn't exist
if [ ! -f /config/rclone/rclone.conf ]; then
    echo "Generating rclone configuration..."
    cat /templates/rclone.conf.template | envsubst > /config/rclone/rclone.conf
    chmod 600 /config/rclone/rclone.conf
fi

# Set environment variable for rclone config location
export RCLONE_CONFIG="/config/rclone/rclone.conf"

# Execute the command
exec "$@"
