#!/bin/sh

# Define log file path
LOG_FILE="/affine-backup/affine-backup.log"
DB_BACKUP_DIR="/affine-db-backups"

# Create database backup directory if it doesn't exist
mkdir -p "$DB_BACKUP_DIR"

# Log backup start with timestamp
echo "=== Starting backup at $(date) ===" >> "$LOG_FILE" 2>&1

# Step 1: Create database backup
echo "Creating database backup..." >> "$LOG_FILE" 2>&1
DB_BACKUP_FILE="$DB_BACKUP_DIR/affine-db-$(date +%Y%m%d_%H%M%S).sql.gz"

if PGPASSWORD="$DB_PASSWORD" pg_dump --host=affine_postgres --username="$DB_USERNAME" --format=c --verbose "$DB_DATABASE" | gzip > "$DB_BACKUP_FILE" 2>> "$LOG_FILE"; then
    echo "Database backup created successfully: $DB_BACKUP_FILE" >> "$LOG_FILE" 2>&1
    
    # Keep only the last 7 database backups to save space
    cd "$DB_BACKUP_DIR" && ls -t affine-db-*.sql.gz | tail -n +8 | xargs -r rm --
    echo "Cleaned up old database backups" >> "$LOG_FILE" 2>&1
else
    echo "Database backup failed!" >> "$LOG_FILE" 2>&1
fi

# Step 2: Sync config folder
echo "Starting rclone sync from config to remote:affine-config-backup" >> "$LOG_FILE" 2>&1

if rclone sync /affine-data/config remote:affine-config-backup --progress --create-empty-src-dirs >> "$LOG_FILE" 2>&1; then
    echo "Config sync completed successfully" >> "$LOG_FILE" 2>&1
    CONFIG_SYNC_SUCCESS=true
else
    echo "Config sync failed" >> "$LOG_FILE" 2>&1
    CONFIG_SYNC_SUCCESS=false
fi

# Step 3: Sync storage folder
echo "Starting rclone sync from storage to remote:affine-storage-backup" >> "$LOG_FILE" 2>&1

if rclone sync /affine-data/storage remote:affine-storage-backup --progress --create-empty-src-dirs >> "$LOG_FILE" 2>&1; then
    echo "Storage sync completed successfully" >> "$LOG_FILE" 2>&1
    STORAGE_SYNC_SUCCESS=true
else
    echo "Storage sync failed" >> "$LOG_FILE" 2>&1
    STORAGE_SYNC_SUCCESS=false
fi

# Step 4: Sync database backups
echo "Starting rclone sync from database backups to remote:affine-database-backups" >> "$LOG_FILE" 2>&1

if rclone sync "$DB_BACKUP_DIR" remote:affine-database-backups --progress >> "$LOG_FILE" 2>&1; then
    echo "Database backup sync completed successfully" >> "$LOG_FILE" 2>&1
    DB_SYNC_SUCCESS=true
else
    echo "Database backup sync failed" >> "$LOG_FILE" 2>&1
    DB_SYNC_SUCCESS=false
fi

# Final status summary
TOTAL_SUCCESS=0
if [ "$CONFIG_SYNC_SUCCESS" = true ]; then TOTAL_SUCCESS=$((TOTAL_SUCCESS + 1)); fi
if [ "$STORAGE_SYNC_SUCCESS" = true ]; then TOTAL_SUCCESS=$((TOTAL_SUCCESS + 1)); fi
if [ "$DB_SYNC_SUCCESS" = true ]; then TOTAL_SUCCESS=$((TOTAL_SUCCESS + 1)); fi

if [ $TOTAL_SUCCESS -eq 3 ]; then
    echo "=== All backups completed successfully at $(date) ===" >> "$LOG_FILE" 2>&1
elif [ $TOTAL_SUCCESS -gt 0 ]; then
    echo "=== Partial backup success ($TOTAL_SUCCESS/3) at $(date) - check logs for details ===" >> "$LOG_FILE" 2>&1
else
    echo "=== All backups failed at $(date) - will retry tomorrow ===" >> "$LOG_FILE" 2>&1
fi