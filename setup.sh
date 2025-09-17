#!/bin/bash

# n8n Playground Setup Script
# Cross-platform setup for n8n development environment

set -e  # Exit on any error

echo "🚀 n8n Local Automation Lab Setup"
echo "================================="
echo ""
echo "Setting up your local n8n environment with full integration support..."
echo ""

# Detect operating system
OS="Unknown"
case "$(uname -s)" in
    Darwin*)    OS="macOS";;
    Linux*)     OS="Linux";;
    MINGW*)     OS="Windows (Git Bash)";;
    MSYS*)      OS="Windows (MSYS2)";;
    CYGWIN*)    OS="Windows (Cygwin)";;
esac

echo "🖥️  Operating System: $OS"
echo ""

# Check prerequisites
echo "🔍 Checking prerequisites..."

# Function to detect timezone
detect_timezone() {
    if command -v timedatectl &> /dev/null; then
        # Linux systemd
        timedatectl show --property=Timezone --value 2>/dev/null
    elif [ -f /etc/timezone ]; then
        # Debian/Ubuntu
        cat /etc/timezone
    elif [ -h /etc/localtime ]; then
        # Most Unix systems
        readlink /etc/localtime | sed 's|.*/zoneinfo/||'
    elif command -v ls &> /dev/null && ls -la /etc/localtime 2>/dev/null | grep -q zoneinfo; then
        # Alternative method
        ls -la /etc/localtime | sed 's|.*/zoneinfo/||'
    elif [[ "$OS" == "macOS" ]]; then
        # macOS
        systemsetup -gettimezone 2>/dev/null | sed 's/Time Zone: //' || echo "UTC"
    else
        echo "UTC"
    fi
}

# Check Docker installation
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed!"
    echo ""
    echo "📥 Please install Docker Desktop first:"
    case "$OS" in
        "macOS")
            echo "   1. Go to: https://docs.docker.com/desktop/mac/install/"
            echo "   2. Download Docker Desktop for Mac"
            echo "   3. Install and start Docker Desktop"
            echo "   4. Wait for the whale icon 🐳 in your menu bar"
            ;;
        "Linux")
            echo "   1. Go to: https://docs.docker.com/desktop/linux/install/"
            echo "   2. Download Docker Desktop for Linux"
            echo "   3. Or run: curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh"
            ;;
        "Windows"*)
            echo "   1. Go to: https://docs.docker.com/desktop/windows/install/"
            echo "   2. Download Docker Desktop for Windows"
            echo "   3. Install and start Docker Desktop"
            echo "   4. Wait for the whale icon 🐳 in your system tray"
            ;;
    esac
    echo ""
    echo "After installing Docker Desktop, run this script again: ./setup.sh"
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo "❌ Docker is installed but not running!"
    echo ""
    echo "🐳 Please start Docker Desktop:"
    case "$OS" in
        "macOS")
            echo "   1. Find Docker Desktop in Applications"
            echo "   2. Double-click to start it"
            echo "   3. Wait for the whale icon 🐳 in your menu bar"
            ;;
        "Windows"*)
            echo "   1. Find Docker Desktop in Start Menu"
            echo "   2. Click to start it"
            echo "   3. Wait for the whale icon 🐳 in your system tray"
            ;;
        *)
            echo "   1. Start Docker Desktop application"
            echo "   2. Or run: sudo systemctl start docker"
            ;;
    esac
    echo ""
    echo "After Docker is running, run this script again: ./setup.sh"
    exit 1
fi

# Check Docker Compose
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not available!"
    echo "Docker Compose should be included with Docker Desktop."
    echo "Please update Docker Desktop or install Docker Compose separately."
    exit 1
fi

echo "✅ Docker is installed and running"

# Check system resources
echo "💾 Checking system resources..."
if command -v free &> /dev/null; then
    TOTAL_MEM=$(free -m | awk 'NR==2{printf "%.0f", $2/1024}')
    if [ "$TOTAL_MEM" -lt 4 ]; then
        echo "⚠️  Warning: Low RAM detected (${TOTAL_MEM}GB). 4GB+ recommended."
    else
        echo "✅ Memory: ${TOTAL_MEM}GB available"
    fi
elif [[ "$OS" == "macOS" ]]; then
    TOTAL_MEM=$(( $(sysctl -n hw.memsize) / 1024 / 1024 / 1024 ))
    if [ "$TOTAL_MEM" -lt 4 ]; then
        echo "⚠️  Warning: Low RAM detected (${TOTAL_MEM}GB). 4GB+ recommended."
    else
        echo "✅ Memory: ${TOTAL_MEM}GB available"
    fi
else
    echo "✅ System resources check completed"
fi

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo ""
    echo "📝 Creating environment configuration..."
    
    # Detect timezone
    DETECTED_TZ=$(detect_timezone)
    if [ -z "$DETECTED_TZ" ] || [ "$DETECTED_TZ" = "UTC" ]; then
        echo "⚠️  Could not detect timezone, using UTC"
        DETECTED_TZ="UTC"
    else
        echo "🌍 Detected timezone: $DETECTED_TZ"
    fi
    
    # Create .env from template
    cp env.example .env
    
    # Update timezone in .env file (simple approach)
    grep -v "TIMEZONE=" .env > .env.tmp
    echo "TIMEZONE=$DETECTED_TZ" >> .env.tmp
    mv .env.tmp .env
    
    echo "✅ Created .env file with timezone: $DETECTED_TZ"
else
    echo "📝 .env file already exists"
fi

# Create necessary directories
echo ""
echo "📁 Creating directories..."
mkdir -p backups
mkdir -p shared-files
mkdir -p workflows/{gmail,slack,discord,github,automation,webhooks,data-processing,scheduling,monitoring,social-media,ecommerce,development}
echo "✅ Directory structure created"
echo "   - workflows/     📚 (Ready-to-use workflow templates)"
echo "   - shared-files/  📄 (Files accessible to your workflows)"
echo "   - backups/       💾 (Automatic backups will be stored here)"

# Make scripts executable
echo ""
echo "🔧 Setting up scripts..."
chmod +x backup.sh restore.sh oauth-fix.sh setup.sh
if [ -f "start.sh" ]; then
    chmod +x start.sh
fi
if [ -f "stop.sh" ]; then
    chmod +x stop.sh
fi
echo "✅ Scripts are now executable"

# Pull Docker images
echo ""
echo "📦 Pulling n8n Docker image..."
docker pull docker.n8n.io/n8nio/n8n:latest
echo "✅ Docker image pulled successfully"

echo ""
echo "🎉 Setup Complete! Ready for Automation"
echo "======================================="
echo ""
echo "Your n8n Local Automation Lab is ready! 🚀"
echo ""
echo "🌟 What's configured:"
echo "   ✅ Tunnel enabled for Slack, Gmail, GitHub, Jenkins integrations"
echo "   ✅ Timezone set to: $DETECTED_TZ"
echo "   ✅ Workflow templates ready to import"
echo "   ✅ Backup system configured"
echo ""
echo "🚀 Next step - Start n8n:"
echo "   ./start.sh"
echo ""
echo "📱 Once started, you'll get:"
echo "   - Local access: http://localhost:5678"
echo "   - Public tunnel URL for integrations (automatically generated)"
echo ""
echo "📚 Quick help:"
echo "   - Start n8n:           ./start.sh"
echo "   - Stop n8n:            ./stop.sh"
echo "   - Get tunnel URL:      ./oauth-fix.sh"
echo "   - Create backup:       ./backup.sh"
echo "   - Import workflows:    n8n UI → Menu (☰) → Import workflow"
echo ""
echo "💡 Pro tip: Use the tunnel URL (not localhost) when setting up"
echo "   integrations with external services like Slack, Gmail, etc."
echo ""
echo "Ready to automate! Run: ./start.sh 🎯"
