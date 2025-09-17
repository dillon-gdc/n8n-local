#!/bin/bash

# n8n Quick Start Script
# Starts n8n with automatic tunnel detection and setup

echo "🚀 Starting n8n Playground"
echo "=========================="
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "⚠️  No .env file found. Running setup first..."
    ./setup.sh
    echo ""
fi

# Load environment variables (safely)
if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please run ./setup.sh first."
    exit 1
fi

# Stop any existing instance  
echo "🛑 Stopping any existing n8n instance..."
docker compose down --remove-orphans 2>/dev/null || true

# Start n8n
echo "🐳 Starting n8n container..."
docker compose up -d

# Wait for container to start
echo "⏳ Waiting for n8n to start..."
sleep 10

# Check if container is running
if ! docker compose ps | grep -q "Up"; then
    echo "❌ Failed to start n8n. Checking logs..."
    docker compose logs
    exit 1
fi

echo "✅ n8n is starting up..."

# Wait a bit more for full initialization
sleep 15

# Get access URLs
LOCALHOST_URL="http://localhost:5678"
TUNNEL_URL=""

echo ""
echo "🌐 Access URLs:"
echo "==============="
echo "📍 Local access: $LOCALHOST_URL"

# Try to get tunnel URL if enabled
if docker compose logs | grep -q "Tunnel URL:"; then
    TUNNEL_URL=$(docker compose logs | grep "Tunnel URL:" | tail -1 | sed 's/.*Tunnel URL: //')
    echo "🌍 Tunnel access: $TUNNEL_URL"
    echo ""
    echo "💡 Use tunnel URL for OAuth setup!"
else
    echo "🔒 Tunnel not enabled (localhost only)"
fi

echo ""
echo "📊 Container Status:"
docker compose ps

echo ""
echo "🔧 Useful Commands:"
echo "=================="
echo "📋 View logs:        docker compose logs -f"
echo "🛑 Stop n8n:         docker compose down"
echo "🔄 Restart:          docker compose restart"
echo "📦 Update:           docker compose pull && docker compose up -d"
echo "🔧 OAuth setup:      ./oauth-fix.sh"
echo "💾 Backup data:      ./backup.sh"

# Check for tunnel URL and OAuth setup
if [ -n "$TUNNEL_URL" ]; then
    echo ""
    echo "🔗 OAuth Setup Ready!"
    echo "===================="
    echo "For OAuth integrations (GitHub, Google, etc.):"
    echo "1. Use tunnel URL: $TUNNEL_URL"
    echo "2. Run: ./oauth-fix.sh (for detailed setup)"
    echo "3. Access n8n via tunnel URL (not localhost)"
fi

echo ""
echo "✅ n8n is ready! Open: $LOCALHOST_URL"

# Optional: Open browser (uncomment if desired)
# case "$(uname -s)" in
#     Darwin*)    open "$LOCALHOST_URL" 2>/dev/null & ;;
#     Linux*)     xdg-open "$LOCALHOST_URL" 2>/dev/null & ;;
#     MINGW*)     start "$LOCALHOST_URL" 2>/dev/null & ;;
# esac
