#!/bin/bash

set -e

echo "🚀 n8n Local Setup"
echo "=================="
echo ""

# Detect OS for specific instructions
OS="Unknown"
case "$(uname -s)" in
    Darwin*)    OS="macOS";;
    Linux*)     OS="Linux";;
    MINGW*|MSYS*|CYGWIN*) OS="Windows";;
esac

echo "🔍 Checking prerequisites..."

detect_timezone() {
    if command -v timedatectl &> /dev/null; then
        timedatectl show --property=Timezone --value 2>/dev/null
    elif [ -f /etc/timezone ]; then
        cat /etc/timezone
    elif [ -h /etc/localtime ]; then
        readlink /etc/localtime | sed 's|.*/zoneinfo/||'
    elif [[ "$OS" == "macOS" ]]; then
        systemsetup -gettimezone 2>/dev/null | sed 's/Time Zone: //' || echo "UTC"
    else
        echo "UTC"
    fi
}

if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found! Please install Docker Desktop:"
    echo "   https://www.docker.com/products/docker-desktop/"
    echo ""
    echo "After installation, run: ./setup.sh"
    exit 1
fi

if ! docker info &> /dev/null; then
    echo "❌ Docker not running! Please start Docker Desktop."
    echo "After Docker starts, run: ./setup.sh"
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose not available! Please update Docker Desktop."
    exit 1
fi

echo "✅ Docker ready"

if [ ! -f .env ]; then
    echo ""
    echo "📝 Creating configuration..."
    
    DETECTED_TZ=$(detect_timezone)
    if [ -z "$DETECTED_TZ" ] || [ "$DETECTED_TZ" = "UTC" ]; then
        DETECTED_TZ="UTC"
    fi
    
    cp env.example .env
    grep -v "TIMEZONE=" .env > .env.tmp
    echo "TIMEZONE=$DETECTED_TZ" >> .env.tmp
    mv .env.tmp .env
    
    echo "✅ Environment configured (timezone: $DETECTED_TZ)"
fi

echo ""
echo "📁 Creating directories..."
mkdir -p backups shared-files
mkdir -p workflows/{gmail,slack,discord,github,automation,webhooks,data-processing,scheduling,monitoring,social-media,ecommerce,development}

echo "🔧 Setting up scripts..."
chmod +x *.sh

echo "📦 Pulling Docker image..."
docker pull docker.n8n.io/n8nio/n8n:latest

echo ""
echo "🎉 Setup Complete!"
echo "=================="
echo ""
echo "✅ n8n ready to start"
echo "✅ Tunnel enabled for integrations"
echo "✅ Timezone: ${DETECTED_TZ:-UTC}"
echo ""
echo "🚀 Start n8n: ./start.sh"
