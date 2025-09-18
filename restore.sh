#!/bin/bash

if [ $# -eq 0 ]; then
    echo "❌ Usage: $0 <backup_file.tar.gz>"
    echo "📚 Available backups:"
    ls -1 ./backups/*.tar.gz 2>/dev/null || echo "No backups found"
    exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Backup file not found: $BACKUP_FILE"
    exit 1
fi

echo "⚠️  WARNING: This will replace ALL current n8n data!"
echo "📄 Restoring from: $BACKUP_FILE"
echo ""
read -p "Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Cancelled"
    exit 1
fi

echo "🛑 Stopping n8n..."
docker compose down

echo "📦 Restoring data..."
docker run --rm \
  -v n8n_n8n_data:/data \
  -v "$(pwd):/backup" \
  alpine sh -c "cd /data && rm -rf ./* && tar xzf /backup/$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Restore completed!"
    echo "🚀 Starting n8n..."
    docker compose up -d
else
    echo "❌ Restore failed!"
    docker compose up -d
    exit 1
fi

