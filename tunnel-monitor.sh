#!/bin/bash

# n8n Tunnel Health Monitor
# Monitors tunnel status and provides notifications

echo "📡 n8n Tunnel Health Monitor"
echo "============================="
echo ""

# Check if n8n is running
if ! docker compose ps | grep -q "Up"; then
    echo "❌ n8n is not running"
    echo "   Start with: ./start.sh"
    exit 1
fi

# Source environment variables
if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

# Get current tunnel URL
CURRENT_TUNNEL=$(docker compose logs | grep "Tunnel URL:" | tail -1 | sed 's/.*Tunnel URL: //')
STORED_TUNNEL="$N8N_TUNNEL_URL"

echo "🔍 Tunnel Status Check:"
echo "======================"
echo ""

if [ -z "$CURRENT_TUNNEL" ]; then
    echo "❌ No tunnel URL found in logs"
    echo "   Tunnel may not be enabled or n8n is still starting"
    exit 1
fi

echo "✅ Current tunnel: $CURRENT_TUNNEL"

# Check if stored tunnel matches current
if [ "$STORED_TUNNEL" != "$CURRENT_TUNNEL" ]; then
    echo "⚠️  Tunnel URL has changed!"
    echo "   Stored:  $STORED_TUNNEL"
    echo "   Current: $CURRENT_TUNNEL"
    echo ""
    echo "🔄 Updating .env file..."
    
    # Update .env file
    if [ -f env-helper.sh ]; then
        source env-helper.sh
        update_tunnel_url "$CURRENT_TUNNEL"
    else
        # Fallback method
        if [ -f .env ]; then
            awk -v url="$CURRENT_TUNNEL" '
            /^# Current tunnel URL \(automatically updated by start\.sh\)/ {
                print $0
                print "N8N_TUNNEL_URL=" url
                skip_next = 1
                next
            }
            /^N8N_TUNNEL_URL=/ && !skip_next { next }
            { skip_next = 0; print }
            ' .env > .env.tmp && mv .env.tmp .env
            echo "✅ Updated .env with new tunnel URL"
        fi
    fi
    
    # Update tunnel-urls.txt if it exists
    if [ -f tunnel-urls.txt ]; then
        echo "📝 Updating tunnel-urls.txt..."
        cat > tunnel-urls.txt << EOF
# n8n Tunnel URLs - Auto-updated $(date)
# Use these URLs for external integrations

TUNNEL_URL=$CURRENT_TUNNEL
WEBHOOK_BASE_URL=${CURRENT_TUNNEL}webhook
OAUTH_CALLBACK_URL=${CURRENT_TUNNEL}rest/oauth2-credential/callback

# Example webhook URLs:
# Gmail webhook: ${CURRENT_TUNNEL}webhook/gmail-notifications
# GitHub webhook: ${CURRENT_TUNNEL}webhook/github-pr-notifications
# Slack webhook: ${CURRENT_TUNNEL}webhook/slack-events

# Copy these URLs to your external service configurations!
EOF
        echo "✅ Updated tunnel-urls.txt"
    fi
    
    echo ""
    echo "⚠️  ACTION REQUIRED:"
    echo "   Update any external service configurations (GitHub, Slack, etc.)"
    echo "   with the new tunnel URL: $CURRENT_TUNNEL"
else
    echo "✅ Tunnel URL is current (no changes needed)"
fi

# Test tunnel connectivity
echo ""
echo "🌐 Testing Tunnel Connectivity:"
echo "==============================="

# Test health endpoint
if curl -s --max-time 10 "${CURRENT_TUNNEL}healthz" > /dev/null; then
    echo "✅ Tunnel is accessible"
else
    echo "❌ Tunnel is not responding"
    echo "   This could be temporary - try again in a few seconds"
fi

# Show webhook test URL
echo ""
echo "🧪 Test Your Webhook:"
echo "====================="
echo "Test URL: ${CURRENT_TUNNEL}webhook/test"
echo ""
echo "Quick test command:"
echo "curl -X POST '${CURRENT_TUNNEL}webhook/test' -H 'Content-Type: application/json' -d '{\"message\":\"test\"}'"

echo ""
echo "📊 Container Health:"
echo "==================="
docker compose ps

echo ""
echo "🔧 Useful Commands:"
echo "=================="
echo "📋 Get webhook URLs:    ./webhook-helper.sh"
echo "🔄 Restart n8n:         ./start.sh"
echo "🔧 OAuth setup help:    ./oauth-fix.sh"
echo "📝 View current URLs:   cat tunnel-urls.txt"

# Optional: Monitor mode
if [ "$1" = "--monitor" ] || [ "$1" = "-m" ]; then
    echo ""
    echo "🔄 Starting continuous monitoring (Ctrl+C to stop)..."
    echo "   Checking every 30 seconds for tunnel changes..."
    echo ""
    
    while true; do
        sleep 30
        NEW_TUNNEL=$(docker compose logs | grep "Tunnel URL:" | tail -1 | sed 's/.*Tunnel URL: //')
        
        if [ "$NEW_TUNNEL" != "$CURRENT_TUNNEL" ] && [ -n "$NEW_TUNNEL" ]; then
            echo "$(date): 🔄 Tunnel URL changed!"
            echo "  Old: $CURRENT_TUNNEL"
            echo "  New: $NEW_TUNNEL"
            
            # Update stored value
            CURRENT_TUNNEL="$NEW_TUNNEL"
            
            # Update .env
            if [ -f env-helper.sh ]; then
                source env-helper.sh
                update_tunnel_url "$NEW_TUNNEL" >/dev/null 2>&1
            else
                # Fallback method
                if [ -f .env ]; then
                    awk -v url="$NEW_TUNNEL" '
                    /^# Current tunnel URL \(automatically updated by start\.sh\)/ {
                        print $0
                        print "N8N_TUNNEL_URL=" url
                        skip_next = 1
                        next
                    }
                    /^N8N_TUNNEL_URL=/ && !skip_next { next }
                    { skip_next = 0; print }
                    ' .env > .env.tmp && mv .env.tmp .env
                fi
            fi
            
            echo "  ✅ Environment updated"
        fi
    done
fi
