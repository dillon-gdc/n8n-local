#!/bin/bash

BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="n8n_backup_${TIMESTAMP}.tar.gz"

mkdir -p "$BACKUP_DIR"

echo "💾 Creating backup..."
echo "📁 Location: $BACKUP_DIR/$BACKUP_FILE"

docker run --rm \
  -v n8n_n8n_data:/data \
  -v "$(pwd)/$BACKUP_DIR":/backup \
  alpine tar czf "/backup/$BACKUP_FILE" -C /data .

if [ $? -eq 0 ]; then
    echo "✅ Backup created!"
    echo "📊 Size: $(du -h "$BACKUP_DIR/$BACKUP_FILE" | cut -f1)"
    echo ""
    echo "📚 All backups:"
    ls -lah "$BACKUP_DIR"/*.tar.gz 2>/dev/null || echo "No other backups found"
else
    echo "❌ Backup failed!"
    exit 1
fi

