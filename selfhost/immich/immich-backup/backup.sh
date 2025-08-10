#!/bin/sh

# Define log file path
LOG_FILE="/immich-backup-logs/immich-backup.log"
DB_BACKUP_DIR="/immich-db-backups"

# Log backup start with timestamp
echo "=== Starting backup at $(date) ===" >> "$LOG_FILE" 2>&1

# Step 1: Create database backup
echo "Creating database backup..." >> "$LOG_FILE" 2>&1
DB_BACKUP_FILE="$DB_BACKUP_DIR/immich-db-$(date +%Y%m%d_%H%M%S).sql.gz"

if PGPASSWORD="$POSTGRES_PASSWORD" pg_dumpall --clean --if-exists --host=immich-database --username="$POSTGRES_USER" | gzip > "$DB_BACKUP_FILE" 2>> "$LOG_FILE"; then
    echo "Database backup created successfully: $DB_BACKUP_FILE" >> "$LOG_FILE" 2>&1

    # Keep only the last 7 database backups to save space
    cd "$DB_BACKUP_DIR" && ls -t immich-db-*.sql.gz | tail -n +8 | xargs -r rm --
    echo "Cleaned up old database backups" >> "$LOG_FILE" 2>&1
else
    echo "Database backup failed!" >> "$LOG_FILE" 2>&1
fi

# Step 2: Sync immich-library (photos/videos)
echo "Starting rclone sync from /immich-library to remote:immich-library" >> "$LOG_FILE" 2>&1

# Perform the actual library sync operation with error handling
# /immich-library = source (mounted read-only from host)
# remote:immich-library = destination (SFTP remote path)
# --progress = show transfer progress
# --create-empty-src-dirs = create empty directories at destination
if rclone sync /immich-library remote:immich-library --progress --create-empty-src-dirs >> "$LOG_FILE" 2>&1; then
    echo "Library sync completed successfully" >> "$LOG_FILE" 2>&1
    LIBRARY_SYNC_SUCCESS=true
else
    echo "Library sync failed" >> "$LOG_FILE" 2>&1
    LIBRARY_SYNC_SUCCESS=false
fi

# Step 3: Sync database backups
echo "Starting rclone sync from database backups to remote:immich-database-backups" >> "$LOG_FILE" 2>&1

# Sync database backups to remote
# /immich-backup/database-backups = source (local database backups)
# remote:immich-database-backups = destination (SFTP remote path)
if rclone sync "$DB_BACKUP_DIR" remote:immich-database-backups --progress >> "$LOG_FILE" 2>&1; then
    echo "Database backup sync completed successfully" >> "$LOG_FILE" 2>&1
    DB_SYNC_SUCCESS=true
else
    echo "Database backup sync failed" >> "$LOG_FILE" 2>&1
    DB_SYNC_SUCCESS=false
fi

# Final status summary
if [ "$LIBRARY_SYNC_SUCCESS" = true ] && [ "$DB_SYNC_SUCCESS" = true ]; then
    echo "=== All backups completed successfully at $(date) ===" >> "$LOG_FILE" 2>&1
elif [ "$LIBRARY_SYNC_SUCCESS" = true ] || [ "$DB_SYNC_SUCCESS" = true ]; then
    echo "=== Partial backup success at $(date) - check logs for details ===" >> "$LOG_FILE" 2>&1
else
    echo "=== All backups failed at $(date) - will retry tomorrow ===" >> "$LOG_FILE" 2>&1
fi