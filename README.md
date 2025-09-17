# n8n Local Automation Lab

**The easiest way to run n8n locally with full integration support.**

Perfect for business users, analysts, and anyone who wants to automate workflows with **Slack, Gmail, GitHub, Jenkins, Outlook** and hundreds of other services - all running securely on your own computer.

## ✨ What This Gives You

- **🌐 Full Integration Access**: Connect to Slack, Gmail, Outlook, GitHub, Jenkins, and 400+ services
- **🔒 100% Local & Private**: Everything runs on your computer - your data never leaves
- **📚 Ready-to-Use Templates**: Pre-built workflows you can import and customize
- **⚡ Zero Configuration**: One command setup that works on any computer
- **🚀 Always Online**: Built-in tunnel so external services can reach your workflows

## 🚨 What You Need on Your Computer

**Before starting, make sure you have:**

### Required Software:
- **Docker Desktop** (free) - [Download here](https://www.docker.com/products/docker-desktop/)
  - For **Mac**: Docker Desktop for Mac
  - For **Windows**: Docker Desktop for Windows  
  - For **Linux**: Docker Desktop or Docker Engine

### System Requirements:
- **4GB RAM** minimum (8GB recommended)
- **2GB free disk space**
- **Internet connection** (for downloading and tunnels)
- **Any modern computer** (Mac, Windows, Linux)

## 🚀 Getting Started (3 Steps)

### Step 1: Install Docker Desktop
1. Download **Docker Desktop** from [docker.com](https://www.docker.com/products/docker-desktop/)
2. Install and start Docker Desktop
3. Wait for the whale icon 🐳 to appear in your system tray/menu bar

### Step 2: Download This Project
1. Download or copy this entire `n8n` folder to your computer
2. Open Terminal (Mac/Linux) or Command Prompt (Windows)
3. Navigate to the folder: `cd path/to/n8n`

### Step 3: Run Setup & Start
```bash
# This will set up everything automatically
./setup.sh

# Start n8n with tunnel support for integrations
./start.sh
```

**🎉 That's it!** 

- **Local access**: http://localhost:5678
- **Integration access**: You'll get a public tunnel URL for Slack, Gmail, etc.

### ⚡ Super Quick Start (One Command)
If Docker Desktop is already running:
```bash
./setup.sh && ./start.sh
```

### Manual Setup

If you prefer manual setup or want to understand each step:

```bash
# Create a persistent volume for your n8n data
docker volume create n8n_data

# Start n8n container
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -e GENERIC_TIMEZONE="America/New_York" \
  -e TZ="America/New_York" \
  -e N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true \
  -e N8N_RUNNERS_ENABLED=true \
  -v n8n_data:/home/node/.n8n \
  docker.n8n.io/n8nio/n8n
```

**Note:** Replace `"America/New_York"` with your actual timezone. For Pacific Time, use `"America/Los_Angeles"`, for Mountain Time use `"America/Denver"`, etc.

### Option 2: Docker Compose (Recommended for ongoing development)

Use the included `docker-compose.yml` file:

```bash
# Start n8n in the background
docker compose up -d

# View logs
docker compose logs -f

# Stop n8n
docker compose down
```

## 🌐 Accessing n8n

Once running, open your browser and navigate to:
**http://localhost:5678**

You'll be greeted with the n8n setup wizard where you can create your first admin account.

## 📁 Project Structure

```
n8n/
├── README.md              # Main documentation
├── LICENSE                # MIT License
├── .gitignore            # Git ignore rules
├── docker-compose.yml    # Docker Compose configuration
├── env.example          # Environment configuration template
├── setup.sh             # Cross-platform setup script
├── start.sh             # Quick start script  
├── stop.sh              # Graceful stop script
├── backup.sh            # Backup creation script
├── restore.sh           # Backup restore script
├── oauth-fix.sh         # OAuth troubleshooting tool
├── workflows/           # 📚 Workflow Library
│   ├── README.md        # Workflow documentation
│   ├── gmail/           # Email automation workflows
│   ├── slack/           # Team communication workflows
│   ├── discord/         # Discord server automation
│   ├── github/          # Repository automation
│   ├── automation/      # General automation workflows
│   ├── webhooks/        # HTTP integration workflows
│   ├── data-processing/ # Data transformation workflows
│   ├── scheduling/      # Time-based workflows
│   ├── monitoring/      # System monitoring workflows
│   ├── social-media/    # Social platform automation
│   ├── ecommerce/       # E-commerce workflows
│   └── development/     # Developer tool workflows
└── backups/            # Automated backups (created automatically)
```

## ⚙️ Configuration Details

### Environment Variables Used:
- `GENERIC_TIMEZONE`: Sets timezone for schedule-oriented nodes
- `TZ`: Sets system timezone for the container
- `N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS`: Ensures secure file permissions
- `N8N_RUNNERS_ENABLED`: Enables task runners (recommended)

### Ports:
- **5678**: n8n web interface (mapped to localhost:5678)

### Volumes:
- `n8n_data`: Persistent storage for workflows, credentials, and settings

## 📚 Working with Workflows

### 📂 Workflow Templates (Ready to Use)
The `workflows/` folder contains **ready-to-use workflow templates** organized by category:
- `gmail/` - Email automation 
- `slack/` - Team notifications
- `github/` - Code repository automation
- `jenkins/` - CI/CD pipeline automation
- And 8 more categories...

### 📥 Importing Templates
1. **Open n8n**: http://localhost:5678
2. **Import workflow**: Click menu (☰) → **Import from file**
3. **Browse templates**: Select any `.json` file from `workflows/`
4. **Configure credentials**: Add your API keys and tokens
5. **Test & activate**: Your workflow is ready!

### 📤 Saving Your Own Workflows  
**Important**: The `workflows/` folder is for **finished, tested workflows only**.

When you create a new workflow:
1. **Build and test** in n8n
2. **When finished**: Export via menu (☰) → **Export workflow**
3. **Save to appropriate category** in `workflows/` folder
4. **Share with others** by copying the folder

### 🔐 Integration Setup (Slack, Gmail, etc.)
All external integrations require your **tunnel URL** (not localhost):
1. **Start n8n**: `./start.sh` 
2. **Get tunnel URL**: Look for "Tunnel URL:" in the startup output
3. **Use tunnel URL** when configuring webhooks in Slack, GitHub, etc.
4. **Run troubleshooter**: `./oauth-fix.sh` if you have issues

## 🔧 Management Commands

### Quick Commands
```bash
# Start n8n with auto-setup
./start.sh

# Stop n8n gracefully  
./stop.sh

# Stop with backup
./stop.sh --backup

# Get OAuth tunnel URL
./oauth-fix.sh

# Create backup
./backup.sh
```

### Docker Commands
```bash
# View logs
docker compose logs -f

# Update to latest version
docker compose pull && docker compose up -d

# Reset everything (⚠️ deletes data)
docker compose down -v
```

### Docker Volume Management

```bash
# List Docker volumes
docker volume ls

# Inspect n8n data volume
docker volume inspect n8n_data

# Backup your workflows (optional)
docker run --rm -v n8n_data:/data -v $(pwd):/backup alpine tar czf /backup/n8n_backup.tar.gz -C /data .
```

## 🚀 Getting Started with Workflows

1. **Access n8n**: Open http://localhost:5678
2. **Create Account**: Set up your admin credentials
3. **Explore Templates**: Browse the template library for inspiration
4. **Build Your First Workflow**: Start with a simple webhook or schedule trigger

### Recommended First Workflows:
- **Hello World**: Manual trigger → Set node → HTTP Request
- **Scheduled Task**: Schedule trigger → HTTP Request → Send Email
- **Webhook Handler**: Webhook trigger → Data processing → Response

## 🔧 Troubleshooting

### Common Issues:

**Port 5678 already in use:**
```bash
# Check what's using the port
lsof -i :5678

# Or change the port in docker-compose.yml
ports:
  - "5679:5678"  # Use port 5679 instead
```

**Permission issues:**
```bash
# Fix Docker volume permissions
docker run --rm -v n8n_data:/data alpine chown -R 1000:1000 /data
```

**Container won't start:**
```bash
# Check Docker logs
docker compose logs n8n

# Restart Docker Desktop if needed
```

## 🔄 Updating n8n

To update to the latest version:

```bash
# Pull the latest image
docker compose pull

# Restart with new image
docker compose down
docker compose up -d
```

## 🆘 Troubleshooting

### "Docker not found" or "Command not found"
**Problem**: Docker Desktop isn't installed or isn't in your PATH
**Solution**: 
1. Install Docker Desktop from [docker.com](https://www.docker.com/products/docker-desktop/)
2. Restart your terminal/command prompt after installation
3. Make sure Docker Desktop is running (whale icon 🐳 in system tray)

### "Docker daemon is not running"  
**Problem**: Docker Desktop is installed but not started
**Solution**:
1. **Mac**: Look for Docker in Applications, double-click to start
2. **Windows**: Look for Docker Desktop in Start Menu, click to start
3. Wait for the whale icon 🐳 to appear in your system tray/menu bar

### "Permission denied" when running scripts
**Problem**: Scripts don't have execute permissions
**Solution**:
```bash
chmod +x *.sh
```

### "Can't connect to Slack/Gmail/GitHub"
**Problem**: Using localhost URL instead of tunnel URL
**Solution**:
1. Run `./oauth-fix.sh` to get your tunnel URL
2. Use the tunnel URL (not localhost) in external service configurations
3. Make sure n8n is started with `./start.sh` (includes tunnel)

### n8n won't start or shows errors
**Problem**: Port conflict or Docker issues
**Solution**:
1. Stop any existing n8n: `./stop.sh`
2. Check if port 5678 is in use: `lsof -i :5678` (Mac/Linux)
3. Restart Docker Desktop
4. Try starting again: `./start.sh`

### Low performance or crashes
**Problem**: Insufficient system resources
**Solution**:
1. Close other applications to free up RAM
2. Make sure you have at least 4GB RAM available
3. Check Docker Desktop resource settings (increase if needed)

### Need help?
- **n8n Documentation**: https://docs.n8n.io/
- **Community Forum**: https://community.n8n.io/
- **Discord**: https://discord.gg/XPKeKXeB

## 🤝 Sharing & Collaboration

This project is designed to be easily shared with friends and team members:

### For Your Friends
1. **Share the entire directory**: Copy the whole `n8n/` folder
2. **They run setup**: `./setup.sh` (auto-detects their OS and timezone)
3. **Start immediately**: `./start.sh`
4. **Import workflows**: Browse `workflows/` and import via n8n UI

### For GitHub
The project is ready for GitHub with:
- ✅ Proper `.gitignore` (excludes sensitive data)
- ✅ MIT License included
- ✅ Cross-platform compatibility
- ✅ Comprehensive documentation

### Security for Sharing
- ✅ All credentials removed from example workflows
- ✅ Environment variables for configuration
- ✅ Backup system for data safety
- ✅ Clear setup instructions

## 📚 Next Steps

1. **Explore Workflows**: Browse the `workflows/` directory for automation ideas
2. **Learn n8n**: Check out the [n8n documentation](https://docs.n8n.io/) and [Academy](https://docs.n8n.io/courses/)
3. **Join Community**: Visit the [n8n forum](https://community.n8n.io/) and [Discord](https://discord.gg/XPKeKXeB)
4. **Contribute**: Add your own workflows to the library

## 🔗 OAuth Setup (GitHub, Google, etc.)

### The 408 Error Fix

If you get 408 timeout errors during OAuth:

1. **Update your GitHub OAuth app** with the new tunnel URL:
   ```bash
   # Get your current tunnel URL
   docker compose logs | grep "Tunnel URL"
   ```

2. **Use the tunnel URL format**:
   - Homepage URL: `https://your-tunnel-url.hooks.n8n.cloud/`
   - Authorization callback URL: `https://your-tunnel-url.hooks.n8n.cloud/rest/oauth2-credential/callback`

3. **Access n8n via tunnel URL** (not localhost) when setting up OAuth credentials

### Step-by-Step OAuth Setup:

1. **Get your tunnel URL**: `docker compose logs | grep "Tunnel URL"`
2. **Create GitHub OAuth App**:
   - Go to [GitHub Developer Settings](https://github.com/settings/developers)
   - Click "New OAuth App"
   - Use your tunnel URL for both Homepage and Callback URLs
3. **In n8n** (accessed via tunnel URL):
   - Add GitHub credential
   - Select "OAuth2" 
   - Paste Client ID and Secret
   - The redirect URL will auto-populate correctly
4. **Test the connection**

### Troubleshooting OAuth:
- **408 Errors**: Restart n8n to get a fresh tunnel URL
- **Read-only redirect URL**: Access n8n via tunnel URL, not localhost
- **GitHub connection fails**: Verify the OAuth app callback URL matches exactly

## 🛡️ Security & Safety Information

### ✅ **What's Safe About This Setup:**

1. **Local Data Only**: All workflows, credentials, and data stay on your Mac
2. **Encrypted Tunnel**: The n8n tunnel uses HTTPS encryption
3. **Temporary Tunnel**: Tunnel URLs change when you restart n8n
4. **Docker Isolation**: n8n runs in an isolated container
5. **No Production Data**: This is for development/learning only

### ⚠️ **Security Considerations:**

1. **Tunnel URL Access**: 
   - Anyone with your tunnel URL can access your n8n instance
   - **Never share the tunnel URL publicly**
   - Tunnel URLs are temporary and change on restart

2. **OAuth Credentials**:
   - Store sensitive credentials securely in n8n's credential system
   - Don't commit OAuth secrets to git repositories
   - Use minimal permissions when creating OAuth apps

3. **Development vs Production**:
   - **This setup is for LOCAL DEVELOPMENT ONLY**
   - Never use tunnel mode for production workloads
   - For production, use proper domain, SSL, and authentication

### 🔒 **Best Practices:**

1. **Regular Restarts**: Restart n8n periodically to get new tunnel URLs
2. **Minimal OAuth Permissions**: Only grant necessary GitHub/API permissions
3. **Credential Management**: Use n8n's built-in credential encryption
4. **Network Awareness**: Be mindful of what networks you're on when using tunnels
5. **Backup Regularly**: Use the provided backup scripts

### 🚨 **What to Never Do:**

- ❌ Share tunnel URLs in Slack, email, or documentation
- ❌ Use this setup for production workflows
- ❌ Store real production API keys in development
- ❌ Leave n8n running unattended with tunnel enabled
- ❌ Use tunnel mode on untrusted networks

### 🛡️ **Additional Security Measures:**

```bash
# Disable tunnel when not needed (faster, more secure)
# Edit docker-compose.yml, remove: command: start --tunnel
docker compose down && docker compose up -d

# Enable encryption key (recommended)
# Add to docker-compose.yml environment:
# - N8N_ENCRYPTION_KEY=your-very-long-random-encryption-key-here

# Regular security updates
docker compose pull && docker compose up -d
```

## 🆘 Getting Help

- **Documentation**: https://docs.n8n.io/
- **Community Forum**: https://community.n8n.io/
- **GitHub Issues**: https://github.com/n8n-io/n8n/issues

---

**Happy automating! 🎉**

*This setup gives you a full-featured n8n instance for learning and development. Start small, experiment often, and build amazing workflows!*
