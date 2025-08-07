#!/bin/sh

# Define log file path
LOG_FILE="/immich-backup/immich-backup.log"

# Log sync start with timestamp
echo "=== Starting sync at $(date) ===" >> "$LOG_FILE" 2>&1
echo "Starting rclone sync from /immich-library to remote:immich-library" >> "$LOG_FILE" 2>&1

# Perform the actual sync operation with error handling
# /immich-library = source (mounted read-only from host)
# remote:immich-library = destination (SFTP remote path)
# --progress = show transfer progress
# --create-empty-src-dirs = create empty directories at destination
if rclone sync /immich-library remote:immich-library --progress --create-empty-src-dirs >> "$LOG_FILE" 2>&1; then
    # Log sync completion with timestamp
    echo "=== Sync completed successfully at $(date) ===" >> "$LOG_FILE" 2>&1
else
    # Log sync failure with timestamp
    echo "=== Sync failed at $(date) - will retry tomorrow ===" >> "$LOG_FILE" 2>&1
fi