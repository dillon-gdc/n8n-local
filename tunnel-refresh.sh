#!/bin/bash

# n8n Tunnel Refresh Script
# Restarts n8n to get a fresh, working tunnel URL

echo "🔄 n8n Tunnel Refresh"
echo "===================="
echo ""

echo "🔍 Checking current tunnel status..."

# Get current tunnel URL if available
CURRENT_TUNNEL=""
if [ -f .env ] && grep -q "N8N_TUNNEL_URL=" .env; then
    CURRENT_TUNNEL=$(grep "N8N_TUNNEL_URL=" .env | cut -d'=' -f2)
fi

if [ -n "$CURRENT_TUNNEL" ]; then
    echo "📡 Current tunnel: $CURRENT_TUNNEL"
    echo "🧪 Testing current tunnel..."
    
    # Test current tunnel
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 "$CURRENT_TUNNEL" 2>/dev/null)
    
    if [ "$RESPONSE" = "200" ]; then
        echo "✅ Current tunnel is working! No refresh needed."
        echo "🌍 Access n8n at: $CURRENT_TUNNEL"
        exit 0
    else
        echo "❌ Current tunnel not working (status: $RESPONSE)"
        echo "🔄 Refreshing tunnel..."
    fi
else
    echo "⚠️  No tunnel URL found, starting fresh..."
fi

echo ""
echo "🛑 Stopping n8n..."
docker compose down --remove-orphans 2>/dev/null

echo "🐳 Starting n8n with fresh tunnel..."
docker compose up -d

echo "⏳ Waiting for tunnel initialization..."
sleep 25

echo "🔍 Getting new tunnel URL..."
NEW_TUNNEL=""
for i in {1..10}; do
    if docker compose logs | grep -q "Tunnel URL:"; then
        NEW_TUNNEL=$(docker compose logs | grep "Tunnel URL:" | tail -1 | sed 's/.*Tunnel URL: //')
        break
    fi
    echo "⏳ Still waiting... ($i/10)"
    sleep 5
done

if [ -n "$NEW_TUNNEL" ]; then
    echo "🎉 New tunnel URL: $NEW_TUNNEL"
    
    # Test new tunnel
    echo "🧪 Testing new tunnel..."
    sleep 10
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 "$NEW_TUNNEL" 2>/dev/null)
    
    if [ "$RESPONSE" = "200" ]; then
        echo "✅ New tunnel is working!"
        echo ""
        echo "🌍 Access n8n at: $NEW_TUNNEL"
        echo "📍 Local access: http://localhost:5678"
        echo ""
        echo "💡 Use the tunnel URL for OAuth setup and external integrations"
        
        # Update environment
        if [ -f env-helper.sh ]; then
            source env-helper.sh
            update_tunnel_url "$NEW_TUNNEL"
        fi
        
        # Create webhook URLs file
        cat > tunnel-urls.txt << EOF
# n8n Tunnel URLs - Refreshed $(date)
# Use these URLs for external integrations

TUNNEL_URL=$NEW_TUNNEL
WEBHOOK_BASE_URL=${NEW_TUNNEL}webhook
OAUTH_CALLBACK_URL=${NEW_TUNNEL}rest/oauth2-credential/callback

# Example webhook URLs:
# Gmail webhook: ${NEW_TUNNEL}webhook/gmail-notifications
# GitHub webhook: ${NEW_TUNNEL}webhook/github-pr-notifications
# Slack webhook: ${NEW_TUNNEL}webhook/slack-events

# Copy these URLs to your external service configurations!
EOF
        echo "📋 Updated tunnel-urls.txt with new URLs"
        
    else
        echo "❌ New tunnel not working yet (status: $RESPONSE)"
        echo "⏳ This can happen - tunnel might need more time to sync"
        echo "💡 Try again in 2-3 minutes or run this script again"
    fi
else
    echo "❌ Failed to get tunnel URL"
    echo "📊 Container status:"
    docker compose ps
    echo ""
    echo "📋 Recent logs:"
    docker compose logs --tail=10
fi

echo ""
echo "🔧 Useful commands:"
echo "  ./tunnel-refresh.sh  # Run this script again"
echo "  ./tunnel-monitor.sh  # Monitor tunnel health"
echo "  ./webhook-helper.sh  # Get webhook URLs"
