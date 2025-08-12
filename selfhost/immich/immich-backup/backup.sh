#!/bin/sh

# Define log file path
LOG_FILE="/immich-backup-logs/immich-backup.log"

# Log backup start with timestamp
echo "=== Starting immich-library backup at $(date) ===" >> "$LOG_FILE" 2>&1

# Sync immich-library (photos/videos)
echo "Starting rclone sync from /immich-library to remote:immich-library" >> "$LOG_FILE" 2>&1

# Perform the actual library sync operation with error handling
# /immich-library = source (mounted read-only from host)
# remote:immich-library = destination (SFTP remote path)
# --progress = show transfer progress
# --create-empty-src-dirs = create empty directories at destination
if rclone sync /immich-library remote:immich-library --progress --create-empty-src-dirs >> "$LOG_FILE" 2>&1; then
    echo "=== Library backup completed successfully at $(date) ===" >> "$LOG_FILE" 2>&1
else
    echo "=== Library backup failed at $(date) - will retry tomorrow ===" >> "$LOG_FILE" 2>&1
fi