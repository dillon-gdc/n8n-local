#!/bin/bash

# n8n Backup Script
# Creates a timestamped backup of your n8n data

BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="n8n_backup_${TIMESTAMP}.tar.gz"

# Create backups directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "🗂️  Creating n8n backup..."
echo "📁 Backup location: $BACKUP_DIR/$BACKUP_FILE"

# Create backup from Docker volume
docker run --rm \
  -v n8n_n8n_data:/data \
  -v "$(pwd)/$BACKUP_DIR":/backup \
  alpine tar czf "/backup/$BACKUP_FILE" -C /data .

if [ $? -eq 0 ]; then
    echo "✅ Backup created successfully!"
    echo "📄 File: $BACKUP_DIR/$BACKUP_FILE"
    echo "📊 Size: $(du -h "$BACKUP_DIR/$BACKUP_FILE" | cut -f1)"
    
    # List all backups
    echo ""
    echo "📚 All backups:"
    ls -lah "$BACKUP_DIR"/*.tar.gz 2>/dev/null || echo "No other backups found"
else
    echo "❌ Backup failed!"
    exit 1
fi

