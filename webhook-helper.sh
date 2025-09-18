#!/bin/bash

echo "🔗 Webhook Helper"
echo "=================="
echo ""

if ! docker compose ps | grep -q "Up"; then
    echo "❌ n8n not running. Start with: ./start.sh"
    exit 1
fi

TUNNEL_URL=""
if [ -f tunnel-urls.txt ]; then
    TUNNEL_URL=$(grep "TUNNEL_URL=" tunnel-urls.txt 2>/dev/null | cut -d'=' -f2)
fi

if [ -z "$TUNNEL_URL" ]; then
    echo "🔍 Getting tunnel URL..."
    TUNNEL_URL=$(docker compose logs | grep "Tunnel URL:" | tail -1 | sed 's/.*Tunnel URL: //')
fi

if [ -z "$TUNNEL_URL" ]; then
    echo "❌ No tunnel URL found. Try restarting:"
    echo "   ./tunnel-refresh.sh"
    exit 1
fi

echo "🌍 Tunnel: $TUNNEL_URL"
STATUS=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "$TUNNEL_URL" 2>/dev/null || echo "Unable to check")
echo "📊 Status: $STATUS"
echo ""

echo "🔗 Webhook URLs:"
echo "================"
echo "Base: ${TUNNEL_URL}webhook/"
echo "OAuth: ${TUNNEL_URL}rest/oauth2-credential/callback"
echo ""
echo "Examples:"
echo "- Gmail: ${TUNNEL_URL}webhook/gmail-notifications"  
echo "- GitHub: ${TUNNEL_URL}webhook/github-pr-notifications"
echo "- Slack: ${TUNNEL_URL}webhook/slack-events"
echo "- Custom: ${TUNNEL_URL}webhook/your-webhook-name"
echo ""
echo "💡 Always use tunnel URL (not localhost) for OAuth setup"
echo "📋 URLs also saved in tunnel-urls.txt"