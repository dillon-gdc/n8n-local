#!/bin/bash

# n8n Restore Script
# Restores n8n data from a backup file

if [ $# -eq 0 ]; then
    echo "❌ Usage: $0 <backup_file.tar.gz>"
    echo "📚 Available backups:"
    ls -1 ./backups/*.tar.gz 2>/dev/null || echo "No backups found in ./backups/"
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
read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Restore cancelled"
    exit 1
fi

echo "🛑 Stopping n8n..."
docker compose down

echo "🗂️  Restoring data..."
docker run --rm \
  -v n8n_n8n_data:/data \
  -v "$(pwd):/backup" \
  alpine sh -c "cd /data && rm -rf ./* && tar xzf /backup/$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Restore completed successfully!"
    echo "🚀 Starting n8n..."
    docker compose up -d
    echo "🌐 n8n will be available at http://localhost:5678"
else
    echo "❌ Restore failed!"
    echo "🚀 Starting n8n with original data..."
    docker compose up -d
    exit 1
fi

