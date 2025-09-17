#!/bin/bash

# OAuth Troubleshooting Script for n8n
# Fixes common 408 errors and tunnel issues

echo "🔧 n8n OAuth Troubleshooting Tool"
echo "=================================="
echo ""

# Check if n8n is running
if ! docker compose ps | grep -q "Up"; then
    echo "❌ n8n is not running. Starting it now..."
    docker compose up -d
    echo "⏳ Waiting for startup..."
    sleep 15
fi

# Get current tunnel URL
echo "🔍 Getting current tunnel URL..."
TUNNEL_URL=$(docker compose logs | grep "Tunnel URL:" | tail -1 | sed 's/.*Tunnel URL: //')

if [ -z "$TUNNEL_URL" ]; then
    echo "❌ No tunnel URL found. Restarting n8n with tunnel..."
    docker compose down
    docker compose up -d
    sleep 15
    TUNNEL_URL=$(docker compose logs | grep "Tunnel URL:" | tail -1 | sed 's/.*Tunnel URL: //')
fi

if [ -z "$TUNNEL_URL" ]; then
    echo "❌ Still no tunnel URL. Please check your docker-compose.yml has: command: start --tunnel"
    exit 1
fi

echo "✅ Current tunnel URL: $TUNNEL_URL"
echo ""

# Generate OAuth URLs
OAUTH_CALLBACK="${TUNNEL_URL}rest/oauth2-credential/callback"

echo "📋 **UPDATE YOUR OAUTH APPS WITH THESE URLs:**"
echo ""
echo "Homepage URL:"
echo "  $TUNNEL_URL"
echo ""
echo "Authorization callback URL:"
echo "  $OAUTH_CALLBACK"
echo ""

# Save URLs to .env for persistence
echo "💾 Saving tunnel URL to .env..."
if [ -f env-helper.sh ]; then
    source env-helper.sh
    update_tunnel_url "$TUNNEL_URL"
else
    # Fallback method
    if [ -f .env ]; then
        awk -v url="$TUNNEL_URL" '
        /^# Current tunnel URL \(automatically updated by start\.sh\)/ {
            print $0
            print "N8N_TUNNEL_URL=" url
            skip_next = 1
            next
        }
        /^N8N_TUNNEL_URL=/ && !skip_next { next }
        { skip_next = 0; print }
        ' .env > .env.tmp && mv .env.tmp .env
        echo "✅ Tunnel URL saved to environment"
    fi
fi

echo ""
echo "🌐 **ACCESS N8N VIA TUNNEL (not localhost):**"
echo "  $TUNNEL_URL"
echo ""

echo "📋 **QUICK SETUP FOR COMMON SERVICES:**"
echo ""
echo "🐙 GitHub OAuth App:"
echo "   1. Go to: https://github.com/settings/developers"
echo "   2. Click 'New OAuth App'"
echo "   3. Homepage URL: $TUNNEL_URL"
echo "   4. Callback URL: $OAUTH_CALLBACK"
echo ""
echo "🔐 Google OAuth (Gmail/Drive/Sheets):"
echo "   1. Go to: https://console.cloud.google.com/apis/credentials"
echo "   2. Create OAuth 2.0 Client ID"
echo "   3. Authorized redirect URI: $OAUTH_CALLBACK"
echo ""
echo "💬 Slack App:"
echo "   1. Go to: https://api.slack.com/apps"
echo "   2. Create New App → OAuth & Permissions"
echo "   3. Redirect URL: $OAUTH_CALLBACK"
echo ""

echo "⚠️  **IMPORTANT SECURITY REMINDERS:**"
echo "- Never share the tunnel URL publicly"
echo "- Only use this for development/testing"
echo "- Tunnel URL changes every time you restart n8n"
echo "- Access n8n via tunnel URL when setting up OAuth"
echo ""

echo "🔄 **IF YOU STILL GET 408 ERRORS:**"
echo "1. Restart n8n: docker compose down && docker compose up -d"
echo "2. Wait 30 seconds for full startup"
echo "3. Get new tunnel URL: $0"
echo "4. Update your GitHub OAuth app with the new URLs"
echo "5. Access n8n via the NEW tunnel URL"
echo ""

echo "✅ OAuth troubleshooting complete!"

