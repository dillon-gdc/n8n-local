#!/bin/bash

echo "🔄 Tunnel Refresh"
echo "=================="
echo ""

echo "🔍 Checking current tunnel..."
CURRENT_TUNNEL=""
if [ -f tunnel-urls.txt ]; then
    CURRENT_TUNNEL=$(grep "TUNNEL_URL=" tunnel-urls.txt 2>/dev/null | cut -d'=' -f2)
fi

if [ -n "$CURRENT_TUNNEL" ]; then
    echo "📡 Testing: $CURRENT_TUNNEL"
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 "$CURRENT_TUNNEL" 2>/dev/null)
    
    if [ "$RESPONSE" = "200" ]; then
        echo "✅ Current tunnel working! No refresh needed."
        echo "🌍 Access: $CURRENT_TUNNEL"
        exit 0
    else
        echo "❌ Tunnel not working (status: $RESPONSE)"
    fi
else
    echo "⚠️  No tunnel found"
fi

echo ""
echo "🔄 Refreshing tunnel..."
echo "🛑 Stopping n8n..."
docker compose down --remove-orphans 2>/dev/null

echo "🐳 Starting with fresh tunnel..."
docker compose up -d

echo "⏳ Waiting for initialization..."
sleep 25

echo "🔍 Getting new tunnel URL..."
NEW_TUNNEL=""
for i in {1..10}; do
    if docker compose logs | grep -q "Tunnel URL:"; then
        NEW_TUNNEL=$(docker compose logs | grep "Tunnel URL:" | tail -1 | sed 's/.*Tunnel URL: //')
        break
    fi
    echo "⏳ Waiting... ($i/10)"
    sleep 5
done

if [ -n "$NEW_TUNNEL" ]; then
    echo "🎉 New tunnel: $NEW_TUNNEL"
    
    echo "🧪 Testing tunnel..."
    sleep 10
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 "$NEW_TUNNEL" 2>/dev/null)
    
    if [ "$RESPONSE" = "200" ]; then
        echo "✅ Tunnel working!"
        echo ""
        echo "🌍 Access: $NEW_TUNNEL"
        echo "📍 Local: http://localhost:5678"
        
        cat > tunnel-urls.txt << EOF
# n8n Tunnel URLs - Refreshed $(date)
TUNNEL_URL=$NEW_TUNNEL
WEBHOOK_BASE_URL=${NEW_TUNNEL}webhook
OAUTH_CALLBACK_URL=${NEW_TUNNEL}rest/oauth2-credential/callback
EOF
        echo "📋 URLs saved to tunnel-urls.txt"
        
    else
        echo "❌ Tunnel not working yet (status: $RESPONSE)"
        echo "💡 Try again in 2-3 minutes"
    fi
else
    echo "❌ Failed to get tunnel URL"
    echo "📊 Container status:"
    docker compose ps
fi
