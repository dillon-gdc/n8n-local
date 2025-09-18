#!/bin/bash

echo "🛑 Stopping n8n"
echo "==============="
echo ""

BACKUP=false
if [ "$1" = "--backup" ] || [ "$1" = "-b" ]; then
    BACKUP=true
fi

if [ "$BACKUP" = true ]; then
    echo "💾 Creating backup..."
    if [ -f backup.sh ]; then
        ./backup.sh
        echo ""
    fi
fi

if ! docker compose ps | grep -q "Up"; then
    echo "ℹ️  n8n not running"
    exit 0
fi

echo "🐳 Stopping container..."
docker compose down

if docker compose ps | grep -q "Up"; then
    echo "⚠️  Force stopping..."
    docker compose down --timeout 30
    docker kill n8n_local 2>/dev/null || true
    docker rm n8n_local 2>/dev/null || true
fi

echo "✅ n8n stopped"
echo ""
echo "📦 Data preserved in Docker volume"
echo "🔄 Restart: ./start.sh"
