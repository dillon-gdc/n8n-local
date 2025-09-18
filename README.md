# n8n Local Automation Lab

**The easiest way to run n8n locally with full integration support.**

Perfect for **business users** who want to automate workflows with Slack, Gmail, GitHub, Jenkins, and 400+ services - or **developers** who need a local n8n development environment.

---

## 👥 Choose Your Path

<details>
<summary><h3>🎯 <strong>Business Users</strong> - I want to automate my workflows</h3></summary>

### ✨ What You Get
- **🌐 Full Integration Access**: Connect to Slack, Gmail, GitHub, and 400+ services
- **🔒 100% Local & Private**: Everything runs on your computer
- **📚 Ready-to-Use Templates**: Pre-built workflows you can customize
- **⚡ Zero Configuration**: One command setup that works on any computer
- **🚀 Always Online**: Built-in tunnel so external services can reach your workflows

### 🚨 What You Need
- **Docker Desktop** (free) - [Download here](https://www.docker.com/products/docker-desktop/)
- **4GB RAM** minimum (8GB recommended)
- **2GB free disk space**
- **Any modern computer** (Mac, Windows, Linux)

### 🚀 Quick Start (3 Steps)

#### Step 1: Install Docker Desktop
1. Download **Docker Desktop** from [docker.com](https://www.docker.com/products/docker-desktop/)
2. Install and start Docker Desktop
3. Wait for the whale icon 🐳 to appear in your system tray/menu bar

#### Step 2: Download This Project
1. Download this `n8n` folder to your computer
2. Open Terminal (Mac/Linux) or Command Prompt (Windows)
3. Navigate to the folder: `cd path/to/n8n`

#### Step 3: Run Setup & Start
```bash
# This sets up everything automatically
./setup.sh

# Start n8n with tunnel support for integrations
./start.sh
```

**🎉 That's it!** n8n will provide a tunnel URL for reliable access and integrations!

### 📚 Using Workflow Templates
1. **Browse templates**: Check the `workflows/` folder for automation ideas
2. **Import workflow**: In n8n, click menu (☰) → Import from file
3. **Get webhook URLs**: Run `./webhook-helper.sh` for integration URLs
4. **Set up OAuth**: Run `./oauth-fix.sh` for external service connections
5. **Start automating**: Your workflows are ready to use!

### 🔧 Daily Commands
```bash
# Start n8n
./start.sh

# Get webhook URLs for integrations  
./webhook-helper.sh

# Set up OAuth for Gmail, Slack, GitHub
./oauth-fix.sh

# Stop n8n
./stop.sh

# Create backup
./backup.sh
```

### 🆘 Need Help?
- **Documentation**: https://docs.n8n.io/
- **Community Forum**: https://community.n8n.io/
- **This project's tutorials**: See `workflows/` folder

</details>

<details>
<summary><h3>💻 <strong>Developers</strong> - I want to develop with n8n</h3></summary>

### 🛠️ Development Features
- **🔄 Fresh tunnel URLs**: Reliable tunnel generation every restart
- **🐳 Docker Compose setup**: Easy container management and customization
- **📦 Volume persistence**: Your data survives container restarts
- **🔧 Development optimized**: Fast iteration and debugging
- **📊 Health monitoring**: Built-in tunnel monitoring tools
- **🔗 API-ready**: Full REST API access for automation

### ⚡ Quick Setup
```bash
git clone <your-repo>
cd n8n-local
./setup.sh && ./start.sh
```

### 🏗️ Architecture
```
n8n-local/
├── docker-compose.yml    # Container configuration
├── env.example          # Environment template  
├── .env                 # Auto-generated config (git-ignored)
├── start.sh             # Auto-tunnel detection & startup
├── tunnel-refresh.sh    # Tunnel refresh utility
├── webhook-helper.sh    # Webhook URL generator
├── workflows/           # Template library & export destination
├── shared-files/        # Mount point for workflow file access
└── backups/            # Automated backup storage
```

### 🔧 Development Workflow

#### Environment Management
```bash
# Start with fresh tunnel
./start.sh

# Refresh tunnel if needed
./tunnel-refresh.sh

# Get current tunnel status
./webhook-helper.sh
```

#### Webhook Development
```bash
# Get webhook URLs
./webhook-helper.sh

# Get tunnel URL from file
grep "TUNNEL_URL=" tunnel-urls.txt | cut -d'=' -f2

# Test webhook connectivity
TUNNEL_URL=$(grep "TUNNEL_URL=" tunnel-urls.txt | cut -d'=' -f2)
curl -X POST "${TUNNEL_URL}webhook/test" -d '{"test":true}'
```

#### Container Management
```bash
# Development mode (with logs)
docker compose up

# Production mode (detached)
docker compose up -d

# Update to latest n8n
docker compose pull && docker compose up -d

# Reset everything
docker compose down -v
```

### 🌐 Tunnel URLs

Tunnel URLs are saved to `tunnel-urls.txt`:
```bash
# Get current tunnel URL
grep "TUNNEL_URL=" tunnel-urls.txt | cut -d'=' -f2

# Available in n8n workflows (via tunnel detection)
# Use webhook-helper.sh to get current URLs
```

### 🔌 API Access
```bash
# Get tunnel URL first
TUNNEL_URL=$(grep "TUNNEL_URL=" tunnel-urls.txt | cut -d'=' -f2)

# Health check
curl ${TUNNEL_URL}healthz

# REST API
curl ${TUNNEL_URL}rest/workflows

# Webhook endpoints
curl ${TUNNEL_URL}webhook/your-endpoint
```

### 📦 Custom Configuration

#### PostgreSQL Database
Uncomment the PostgreSQL section in `docker-compose.yml` for production-like setup.

#### Custom Environment
```bash
cp env.example .env
# Edit .env with your configurations
docker compose up -d
```

#### SSL/Custom Domain
Mount your certificates in `docker-compose.yml` and update environment variables.

### 🧪 Testing & Debugging
```bash
# Container logs
docker compose logs -f

# Tunnel status
./webhook-helper.sh

# Refresh tunnel if broken
./tunnel-refresh.sh

# Backup before testing
./backup.sh
```

### 🔄 Contributing
1. **Export workflows**: Use n8n's export feature
2. **Clean sensitive data**: Remove credentials and personal info
3. **Add to templates**: Place in appropriate `workflows/` subfolder
4. **Test import**: Verify workflow imports cleanly

</details>

---

## 🎯 Quick Commands Reference

| Task | Command | Description |
|------|---------|-------------|
| **Start n8n** | `./start.sh` | Auto-setup, tunnel detection, env updates |
| **Get webhook URLs** | `./webhook-helper.sh` | Interactive URL generator |
| **OAuth setup** | `./oauth-fix.sh` | Step-by-step external service setup |
| **Refresh tunnel** | `./tunnel-refresh.sh` | Get fresh tunnel URL if broken |
| **Stop n8n** | `./stop.sh` | Graceful shutdown |
| **Backup data** | `./backup.sh` | Create timestamped backup |
| **View logs** | `docker compose logs -f` | Real-time container logs |

---

## 📚 Workflow Templates

Ready-to-use automation templates in the `workflows/` folder:

- **📧 Email** - Gmail to Slack notifications, auto-responders
- **💬 Chat** - Slack/Discord integrations, team alerts  
- **🐙 Development** - GitHub PR notifications, CI/CD triggers
- **📊 Data** - CSV processing, report generation
- **🔗 Webhooks** - HTTP integrations, API automation
- **⏰ Scheduling** - Time-based tasks, recurring operations
- **📈 Monitoring** - Health checks, uptime monitoring
- **🛒 E-commerce** - Order processing, inventory alerts

Each template includes setup instructions and example configurations.

---

## 🌐 Integration Setup

### OAuth Services (GitHub, Google, Slack)
1. Run `./oauth-fix.sh` for step-by-step setup
2. Use the provided tunnel URLs (not localhost)
3. Access n8n via tunnel URL when configuring credentials

### Webhook Services (Discord, custom APIs)
1. Run `./webhook-helper.sh` for webhook URLs
2. Copy the generated URLs to your external services
3. Test with the provided curl commands

---

## 🔧 Troubleshooting

### Common Issues:

**❌ Docker not found**
- Install Docker Desktop from [docker.com](https://www.docker.com/products/docker-desktop/)
- Restart terminal after installation

**❌ Port 5678 in use**
```bash
# Check what's using the port
lsof -i :5678

# Or change port in docker-compose.yml
ports: ["5679:5678"]
```

**❌ Tunnel not working**
```bash
# Get fresh tunnel
./tunnel-refresh.sh

# Check tunnel status
./webhook-helper.sh

# Alternative: restart completely
./stop.sh && ./start.sh
```

**❌ OAuth 408 errors**
- Use tunnel URL (not localhost) for OAuth setup
- Get fresh tunnel: `./tunnel-refresh.sh`
- Run `./oauth-fix.sh` for detailed guidance

---

## 🛡️ Security & Privacy

### ✅ What's Safe:
- **Local data only** - Everything stays on your computer
- **Encrypted tunnel** - HTTPS encryption for external connections
- **Temporary URLs** - Tunnel URLs change when you restart
- **Docker isolation** - n8n runs in isolated container

### ⚠️ Security Notes:
- **Tunnel URLs are temporary** - Change on each restart
- **Never share tunnel URLs publicly** 
- **Development only** - Not for production workloads
- **Use minimal OAuth permissions** - Only grant necessary access

---

## 📱 Project Structure

```
n8n-local/
├── 🚀 start.sh              # Start n8n with auto-tunnel detection
├── 🛑 stop.sh               # Stop n8n gracefully
├── ⚙️  setup.sh              # Initial setup and configuration
├── 🔗 webhook-helper.sh     # Webhook URL generator
├── 🔄 tunnel-refresh.sh     # Refresh tunnel URLs
├── 🔧 oauth-fix.sh          # OAuth setup helper
├── 💾 backup.sh             # Create timestamped backups
├── 📋 restore.sh            # Restore from backups
├── 🐳 docker-compose.yml    # Container configuration
├── 📄 env.example           # Environment template
├── 📚 workflows/            # Ready-to-use workflow templates
├── 📁 shared-files/         # File sharing with workflows
└── 💾 backups/             # Automated backup storage
```

---

## 🆘 Getting Help

- **Quick Issues**: Check troubleshooting section above
- **n8n Documentation**: https://docs.n8n.io/
- **Community Forum**: https://community.n8n.io/
- **Workflow Examples**: Browse the `workflows/` folder

---

**Happy automating! 🎉**

*Whether you're automating business processes or developing the next great workflow, this setup gets you running in minutes with enterprise-grade features on your local machine.*

---

## 🎯 What This Repository Solves

### The Problem: n8n Integration Headaches

If you've tried setting up n8n locally before, you've probably hit these frustrating roadblocks:

**🚫 OAuth Won't Work**
- Gmail, Slack, GitHub integrations fail with cryptic 408 errors
- Localhost URLs don't work for OAuth callbacks
- Complex tunnel setup required but poorly documented

**🚫 Manual Configuration Hell**
- Dozens of environment variables to set correctly
- Docker commands that work sometimes but break mysteriously
- No clear difference between development and production setups

**🚫 Integration Complexity**
- Webhook URLs change constantly and break workflows
- No easy way to get working URLs for external services
- Testing integrations requires complex networking knowledge

**🚫 Poor Development Experience**
- Restarting loses tunnel URLs and breaks everything
- No automated backup or recovery
- Difficult to share setups between team members

### The Solution: Production-Ready Local n8n

This repository eliminates every single pain point above:

**✅ Reliable OAuth & Integrations**
- **Fresh tunnel generation**: New, working tunnel URLs every restart
- **No stale URL issues**: Prevents tunnel reuse problems that cause 404/408 errors
- **Integration testing**: Built-in tools to verify webhook and OAuth connectivity
- **Real-world tested**: Works with Gmail, Slack, GitHub, Discord, and 400+ services

**✅ Zero-Configuration Setup**
- **One-command installation**: `./setup.sh && ./start.sh` - that's it
- **Cross-platform**: Works identically on Mac, Windows, and Linux
- **Intelligent defaults**: Optimal settings for local development out of the box
- **Environment auto-detection**: Timezone, resources, and configuration handled automatically

**✅ Integration-First Design**
- **Dynamic webhook URLs**: Generated fresh and saved to tunnel-urls.txt
- **Simple helpers**: Easy OAuth setup with exact URLs to use
- **Tunnel refresh**: One-command tunnel refresh when needed
- **Template library**: Ready-to-import workflows with real integration examples

**✅ Professional Development Workflow**
- **Docker Compose optimization**: Minimal, reliable configuration that just works
- **Automated backup system**: Your work is never lost
- **Streamlined scripts**: Clean, focused tools without bloat
- **Debugging tools**: Built-in utilities to diagnose and fix tunnel issues

### Why This Matters

**For Business Users**: You get a local automation platform that works exactly like the cloud version, with full integration support, but 100% private and under your control.

**For Developers**: You get a bulletproof local development environment that handles all the complex networking and environment management automatically, letting you focus on building workflows instead of fighting configuration.

**For Teams**: Everyone gets identical, working setups regardless of their technical experience or operating system.

### What Makes This Different

Most n8n local setups are just basic Docker commands that break the moment you need real integrations. This repository is a **complete automation development platform** that:

1. **Actually works with real services** (not just localhost demos)
2. **Handles the complex networking automatically** (tunnel management, URL tracking)
3. **Provides professional tooling** (monitoring, backup, debugging)
4. **Includes ready-to-use examples** (proven workflow templates)
5. **Scales from simple automations to complex business processes**

This is the difference between a toy setup and a production-ready development environment.