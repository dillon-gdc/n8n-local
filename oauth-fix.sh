#!/bin/bash

echo "🔧 OAuth Setup Helper"
echo "====================="
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
    TUNNEL_URL=$(docker compose logs | grep "Tunnel URL:" | tail -1 | sed 's/.*Tunnel URL: //')
fi

if [ -z "$TUNNEL_URL" ]; then
    echo "❌ No tunnel URL found. Try: ./tunnel-refresh.sh"
    exit 1
fi

echo "🌍 Current tunnel: $TUNNEL_URL"
echo ""

echo "🔐 OAuth Setup Instructions:"
echo "============================="
echo ""
echo "1. **Use tunnel URL (not localhost)**"
echo "   - Access n8n at: $TUNNEL_URL"
echo "   - NEVER use http://localhost:5678 for OAuth"
echo ""
echo "2. **OAuth App Configuration:**"
echo "   - Homepage URL: $TUNNEL_URL"
echo "   - Callback URL: ${TUNNEL_URL}rest/oauth2-credential/callback"
echo ""
echo "3. **Common OAuth Services:**"
echo "   - GitHub: https://github.com/settings/applications/new"
echo "   - Google: https://console.cloud.google.com/apis/credentials"
echo "   - Slack: https://api.slack.com/apps"
echo ""
echo "4. **Troubleshooting 408 Errors:**"
echo "   - Always use tunnel URL for credential setup"
echo "   - Restart for fresh tunnel: ./tunnel-refresh.sh"
echo "   - Check tunnel status: ./webhook-helper.sh"
echo ""
echo "💡 Remember: Tunnel URL changes when you restart n8n!"