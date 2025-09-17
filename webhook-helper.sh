#!/bin/bash

# Webhook Helper Script for n8n
# Generates webhook URLs and provides integration guidance

echo "🔗 n8n Webhook Helper"
echo "====================="
echo ""

# Check if n8n is running
if ! docker compose ps | grep -q "Up"; then
    echo "❌ n8n is not running. Please start it first:"
    echo "   ./start.sh"
    exit 1
fi

# Source .env file to get tunnel URL
if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

# Get current tunnel URL from logs if not in env
if [ -z "$N8N_TUNNEL_URL" ]; then
    echo "🔍 Getting current tunnel URL..."
    N8N_TUNNEL_URL=$(docker compose logs | grep "Tunnel URL:" | tail -1 | sed 's/.*Tunnel URL: //')
fi

if [ -z "$N8N_TUNNEL_URL" ]; then
    echo "❌ No tunnel URL found. Make sure n8n is running with tunnel enabled."
    echo "   Check docker-compose.yml has: command: start --tunnel"
    exit 1
fi

echo "✅ Current tunnel URL: $N8N_TUNNEL_URL"
echo ""

# Function to generate webhook URL
generate_webhook_url() {
    local webhook_path="$1"
    echo "${N8N_TUNNEL_URL}webhook/${webhook_path}"
}

# Function to generate OAuth callback URL
generate_oauth_callback() {
    echo "${N8N_TUNNEL_URL}rest/oauth2-credential/callback"
}

# Interactive webhook generator
echo "🛠️  Webhook URL Generator"
echo "=========================="
echo ""
echo "Choose an option:"
echo "1) Generate webhook URL for specific path"
echo "2) Show common webhook examples"
echo "3) Show OAuth setup URLs"
echo "4) Show all integration URLs"
echo "5) Copy current tunnel URL to clipboard"
echo ""
read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        echo ""
        read -p "Enter webhook path (e.g., 'github-pr', 'slack-events'): " webhook_path
        if [ -n "$webhook_path" ]; then
            webhook_url=$(generate_webhook_url "$webhook_path")
            echo ""
            echo "🔗 Your webhook URL:"
            echo "   $webhook_url"
            echo ""
            echo "📋 To use this webhook:"
            echo "   1. Copy the URL above"
            echo "   2. In n8n, create a Webhook node"
            echo "   3. Set the webhook path to: $webhook_path"
            echo "   4. Use the full URL in your external service"
        fi
        ;;
    2)
        echo ""
        echo "📋 Common Webhook Examples:"
        echo "=========================="
        echo ""
        echo "GitHub PR notifications:"
        echo "   $(generate_webhook_url 'github-pr')"
        echo ""
        echo "Gmail new email alerts:"
        echo "   $(generate_webhook_url 'gmail-notifications')"
        echo ""
        echo "Slack events:"
        echo "   $(generate_webhook_url 'slack-events')"
        echo ""
        echo "Discord webhooks:"
        echo "   $(generate_webhook_url 'discord-notifications')"
        echo ""
        echo "Generic form submissions:"
        echo "   $(generate_webhook_url 'form-submit')"
        ;;
    3)
        oauth_url=$(generate_oauth_callback)
        echo ""
        echo "🔐 OAuth Setup URLs:"
        echo "==================="
        echo ""
        echo "Homepage URL (for OAuth apps):"
        echo "   $N8N_TUNNEL_URL"
        echo ""
        echo "Authorization callback URL:"
        echo "   $oauth_url"
        echo ""
        echo "📱 OAuth Setup Instructions:"
        echo "   1. Use the URLs above in your OAuth app configuration"
        echo "   2. Access n8n via tunnel URL (not localhost) when setting up credentials"
        echo "   3. Common OAuth apps: GitHub, Google, Slack, Microsoft"
        ;;
    4)
        oauth_url=$(generate_oauth_callback)
        echo ""
        echo "🌐 All Integration URLs:"
        echo "======================="
        echo ""
        echo "Base tunnel URL:"
        echo "   $N8N_TUNNEL_URL"
        echo ""
        echo "Webhook base:"
        echo "   ${N8N_TUNNEL_URL}webhook/"
        echo ""
        echo "OAuth callback:"
        echo "   $oauth_url"
        echo ""
        echo "Health check:"
        echo "   ${N8N_TUNNEL_URL}healthz"
        echo ""
        echo "API endpoint:"
        echo "   ${N8N_TUNNEL_URL}rest/"
        ;;
    5)
        echo ""
        echo "📋 Copying tunnel URL to clipboard..."
        
        # Cross-platform clipboard copy
        case "$(uname -s)" in
            Darwin*)    
                echo -n "$N8N_TUNNEL_URL" | pbcopy
                echo "✅ Tunnel URL copied to clipboard (macOS)"
                ;;
            Linux*)     
                if command -v xclip &> /dev/null; then
                    echo -n "$N8N_TUNNEL_URL" | xclip -selection clipboard
                    echo "✅ Tunnel URL copied to clipboard (Linux - xclip)"
                elif command -v xsel &> /dev/null; then
                    echo -n "$N8N_TUNNEL_URL" | xsel --clipboard --input
                    echo "✅ Tunnel URL copied to clipboard (Linux - xsel)"
                else
                    echo "📋 Tunnel URL: $N8N_TUNNEL_URL"
                    echo "   (Copy manually - xclip/xsel not installed)"
                fi
                ;;
            MINGW*|MSYS*|CYGWIN*)     
                echo -n "$N8N_TUNNEL_URL" | clip
                echo "✅ Tunnel URL copied to clipboard (Windows)"
                ;;
            *)
                echo "📋 Tunnel URL: $N8N_TUNNEL_URL"
                echo "   (Copy manually)"
                ;;
        esac
        ;;
    *)
        echo "❌ Invalid choice. Please run the script again."
        exit 1
        ;;
esac

echo ""
echo "💡 Pro Tips:"
echo "============"
echo "• Always use the tunnel URL (not localhost) for external integrations"
echo "• Tunnel URL changes each time you restart n8n"
echo "• Run this script anytime to get current URLs"
echo "• Check tunnel-urls.txt file for saved URLs"
echo ""
echo "🔧 Need help? Run: ./oauth-fix.sh"
