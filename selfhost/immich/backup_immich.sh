#!/bin/bash

# Source directory (mounted as read-only volume from host)
SOURCE_DIR="/immich-library"
# Log file location (mounted from host)
LOG_FILE="/logs/immich_sync.log"

# Create log directory if it doesn't exist
mkdir -p "$(dirname "$LOG_FILE")"

# Add timestamp to log
echo "=== Starting sync at $(date) ===" >> "$LOG_FILE" 2>&1

# Run rclone sync with the specified parameters
echo "Starting rclone sync from $SOURCE_DIR to remote:immich-library"
rclone sync "$SOURCE_DIR" remote:immich-library --progress --create-empty-src-dirs --config "$RCLONE_CONFIG" >> "$LOG_FILE" 2>&1

# Add completion timestamp to log
echo "=== Sync completed at $(date) ===" >> "$LOG_FILE" 2>&1

