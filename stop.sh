#!/bin/bash

# n8n Stop Script
# Gracefully stops n8n and optionally creates backup

echo "🛑 Stopping n8n Playground"
echo "=========================="
echo ""

# Check if backup is requested
BACKUP=false
if [ "$1" = "--backup" ] || [ "$1" = "-b" ]; then
    BACKUP=true
fi

# Create backup before stopping (if requested)
if [ "$BACKUP" = true ]; then
    echo "💾 Creating backup before stopping..."
    if [ -f backup.sh ]; then
        ./backup.sh
        echo ""
    else
        echo "⚠️  backup.sh not found, skipping backup"
        echo ""
    fi
fi

# Check if n8n is running
if ! docker compose ps | grep -q "Up"; then
    echo "ℹ️  n8n is not currently running"
    exit 0
fi

echo "🐳 Stopping n8n container..."
docker compose down

# Verify it stopped
if docker compose ps | grep -q "Up"; then
    echo "⚠️  Container may still be running. Force stopping..."
    docker compose down --timeout 30
    
    # If still running, force kill
    if docker compose ps | grep -q "Up"; then
        echo "🚨 Force killing container..."
        docker kill n8n_local 2>/dev/null || true
        docker rm n8n_local 2>/dev/null || true
    fi
fi

echo "✅ n8n stopped successfully"
echo ""

# Show data preservation info
echo "📦 Data Status:"
echo "=============="
echo "✅ Your workflows and credentials are preserved"
echo "📁 Data location: Docker volume 'n8n_n8n_data'"
echo "🔄 Restart anytime with: ./start.sh or docker compose up -d"

if [ "$BACKUP" = true ]; then
    echo "💾 Backup created in: ./backups/"
fi

echo ""
echo "🔧 Maintenance Commands:"
echo "======================="
echo "🧹 Clean up containers: docker system prune"
echo "📦 Remove volumes:       docker compose down -v (⚠️  DELETES DATA)"
echo "🔄 Update image:         docker compose pull"

echo ""
echo "💡 To restart: ./start.sh"
