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

# Try to get tunnel URL if enabled
if docker compose logs | grep -q "Tunnel URL:"; then
    TUNNEL_URL=$(docker compose logs | grep "Tunnel URL:" | tail -1 | sed 's/.*Tunnel URL: //')
    echo "🌍 Primary access: $TUNNEL_URL"
    echo "📍 Local fallback: $LOCALHOST_URL"
    echo ""
    echo "✅ Use tunnel URL for reliable access and OAuth setup!"
    
    # Automatically update .env with tunnel URL
    if [ -n "$TUNNEL_URL" ]; then
        echo "📋 Saving tunnel URLs for reference..."
        # Note: Not updating .env with N8N_TUNNEL_URL as it causes tunnel reuse issues
        # Tunnel URLs are dynamic and should be generated fresh each time
        
        # Create webhook URLs file for easy reference
        echo "📋 Creating webhook reference file..."
        cat > tunnel-urls.txt << EOF
# n8n Tunnel URLs - Auto-generated $(date)
# Use these URLs for external integrations

TUNNEL_URL=$TUNNEL_URL
WEBHOOK_BASE_URL=${TUNNEL_URL}webhook
OAUTH_CALLBACK_URL=${TUNNEL_URL}rest/oauth2-credential/callback

# Example webhook URLs:
# Gmail webhook: ${TUNNEL_URL}webhook/gmail-notifications
# GitHub webhook: ${TUNNEL_URL}webhook/github-pr-notifications
# Slack webhook: ${TUNNEL_URL}webhook/slack-events

# Copy these URLs to your external service configurations!
EOF
        echo "✅ Webhook URLs saved to tunnel-urls.txt"
    fi
else
    echo "📍 Access via: $LOCALHOST_URL"
    echo "⚠️  Tunnel not available - OAuth integrations won't work"
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
echo "🔄 Refresh tunnel:   ./tunnel-refresh.sh"
echo "📦 Update:           docker compose pull && docker compose up -d"
echo "🔗 Get webhook URLs:  ./webhook-helper.sh"
echo "🔧 OAuth setup:      ./oauth-fix.sh"
echo "📡 Monitor tunnel:    ./tunnel-monitor.sh"
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
if [ -n "$TUNNEL_URL" ]; then
    echo "✅ n8n is ready! Open: $TUNNEL_URL"
else
    echo "✅ n8n is ready! Open: $LOCALHOST_URL"
fi

# Optional: Open browser (uncomment if desired)
# BROWSER_URL="${TUNNEL_URL:-$LOCALHOST_URL}"
# case "$(uname -s)" in
#     Darwin*)    open "$BROWSER_URL" 2>/dev/null & ;;
#     Linux*)     xdg-open "$BROWSER_URL" 2>/dev/null & ;;
#     MINGW*)     start "$BROWSER_URL" 2>/dev/null & ;;
# esac
