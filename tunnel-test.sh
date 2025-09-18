#!/bin/bash

# n8n Tunnel Test Script
# Tests if the tunnel is working properly after configuration changes

echo "🔍 n8n Tunnel Test"
echo "=================="
echo ""

# Check if n8n is running
if ! docker compose ps | grep -q "Up"; then
    echo "❌ n8n is not running. Please start it first with: ./start.sh"
    exit 1
fi

echo "✅ n8n container is running"
echo ""

# Wait for logs to be available
echo "⏳ Waiting for tunnel initialization..."
sleep 10

# Check for tunnel URL in logs
echo "🔍 Checking for tunnel URL in logs..."
TUNNEL_URL=$(docker compose logs | grep "Tunnel URL:" | tail -1 | sed 's/.*Tunnel URL: //')

if [ -n "$TUNNEL_URL" ]; then
    echo "✅ Tunnel URL found: $TUNNEL_URL"
    echo ""
    
    # Test tunnel connectivity
    echo "🌐 Testing tunnel connectivity..."
    if curl -s --connect-timeout 10 "$TUNNEL_URL" > /dev/null; then
        echo "✅ Tunnel is accessible!"
        echo ""
        
        # Create test webhook URL
        TEST_WEBHOOK="$TUNNEL_URL/webhook/test"
        echo "🔗 Example webhook URL: $TEST_WEBHOOK"
        echo ""
        
        # Test webhook endpoint
        echo "🧪 Testing webhook endpoint..."
        RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 "$TEST_WEBHOOK")
        
        if [ "$RESPONSE" = "404" ]; then
            echo "✅ Webhook endpoint responding correctly (404 expected for non-existent webhook)"
        elif [ "$RESPONSE" = "200" ] || [ "$RESPONSE" = "405" ]; then
            echo "✅ Webhook endpoint responding correctly (status: $RESPONSE)"
        else
            echo "⚠️  Webhook endpoint response: $RESPONSE (may need investigation)"
        fi
        
        echo ""
        echo "🎉 Tunnel test PASSED!"
        echo ""
        echo "📋 Your tunnel setup:"
        echo "   Local URL:    http://localhost:5678"
        echo "   Tunnel URL:   $TUNNEL_URL"
        echo "   Webhook base: ${TUNNEL_URL}/webhook"
        echo ""
        echo "💡 Use the tunnel URL (not localhost) for:"
        echo "   - OAuth configurations"
        echo "   - External webhook integrations"
        echo "   - API callbacks"
        
    else
        echo "❌ Tunnel URL not accessible"
        echo "   This might be a temporary issue. Try again in a few minutes."
        exit 1
    fi
else
    echo "❌ No tunnel URL found in logs"
    echo ""
    echo "🔍 Recent logs:"
    docker compose logs --tail=20
    echo ""
    echo "💡 Possible issues:"
    echo "   1. Tunnel is still initializing (wait 2-3 minutes)"
    echo "   2. Configuration problem in docker-compose.yml"
    echo "   3. Network connectivity issues"
    exit 1
fi

echo ""
echo "🏁 Test completed successfully!"
