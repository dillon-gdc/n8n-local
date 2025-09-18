#!/bin/bash

echo "🚀 Starting n8n"
echo "==============="
echo ""

if [ ! -f .env ]; then
    echo "⚠️  Running setup first..."
    ./setup.sh
    echo ""
fi

if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Please run ./setup.sh first."
    exit 1
fi

echo "🛑 Stopping existing instance..."
docker compose down --remove-orphans 2>/dev/null || true

echo "🐳 Starting container..."
docker compose up -d

echo "⏳ Waiting for startup..."
sleep 25

if ! docker compose ps | grep -q "Up"; then
    echo "❌ Failed to start. Logs:"
    docker compose logs
    exit 1
fi

LOCALHOST_URL="http://localhost:5678"
TUNNEL_URL=""

echo ""
echo "🌐 Access URLs:"
echo "==============="

if docker compose logs | grep -q "Tunnel URL:"; then
    TUNNEL_URL=$(docker compose logs | grep "Tunnel URL:" | tail -1 | sed 's/.*Tunnel URL: //')
    echo "🌍 Primary: $TUNNEL_URL"
    echo "📍 Local: $LOCALHOST_URL"
    echo ""
    echo "✅ Use tunnel URL for OAuth and integrations!"
    
    if [ -n "$TUNNEL_URL" ]; then
        cat > tunnel-urls.txt << EOF
# n8n Tunnel URLs - Generated $(date)
TUNNEL_URL=$TUNNEL_URL
WEBHOOK_BASE_URL=${TUNNEL_URL}webhook
OAUTH_CALLBACK_URL=${TUNNEL_URL}rest/oauth2-credential/callback
EOF
        echo "📋 URLs saved to tunnel-urls.txt"
    fi
else
    echo "📍 Local: $LOCALHOST_URL"
    echo "⚠️  Tunnel unavailable - OAuth won't work"
fi

echo ""
echo "🔧 Quick Commands:"
echo "=================="
echo "📋 View logs:      docker compose logs -f"
echo "🛑 Stop:           docker compose down"
echo "🔄 Refresh tunnel: ./tunnel-refresh.sh"
echo "🔗 Webhook URLs:   ./webhook-helper.sh"
echo "💾 Backup:         ./backup.sh"

if [ -n "$TUNNEL_URL" ]; then
    echo ""
    echo "🔗 OAuth Ready!"
    echo "==============="
    echo "For OAuth setup: use tunnel URL (not localhost)"
    echo "Run: ./oauth-fix.sh for help"
fi

echo ""
if [ -n "$TUNNEL_URL" ]; then
    echo "✅ n8n ready! Open: $TUNNEL_URL"
else
    echo "✅ n8n ready! Open: $LOCALHOST_URL"
fi
