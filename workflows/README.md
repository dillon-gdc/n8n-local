# n8n Workflow Library

This directory contains pre-built n8n workflows organized by category. Each workflow is a complete automation solution that you can import and customize for your needs.

## 📁 Directory Structure

```
workflows/
├── gmail/              # Email automation workflows
├── slack/              # Slack integration workflows  
├── discord/            # Discord bot and notification workflows
├── github/             # GitHub automation workflows
├── automation/         # General automation workflows
├── webhooks/           # Webhook-based integrations
├── data-processing/    # Data transformation workflows
├── scheduling/         # Time-based automation workflows
├── monitoring/         # System and service monitoring
├── social-media/       # Social media automation
├── ecommerce/          # E-commerce and payment workflows
└── development/        # Developer tools and CI/CD workflows
```

## 🚀 How to Import Workflows

### Method 1: Manual Import (Recommended)
1. Open your n8n Editor UI (http://localhost:5678 or your tunnel URL)
2. Click the menu (☰) → **Import workflow**
3. Choose any `.json` file from the workflows/ folder
4. **Update credentials/webhook URLs** before running
5. Test the workflow in a safe environment

### Method 2: Drag & Drop
1. Open your n8n Editor UI
2. Drag a `.json` file directly onto the canvas
3. Configure credentials and settings
4. Activate the workflow

## ⚠️ Before Using Workflows

### Security Checklist:
- [ ] **Remove sensitive data**: All workflows have credentials/keys removed
- [ ] **Update URLs**: Replace example URLs with your actual endpoints
- [ ] **Test safely**: Run in development environment first
- [ ] **Verify permissions**: Ensure your API keys have appropriate access
- [ ] **Check compatibility**: Verify your n8n version supports all nodes

### Required Steps:
1. **Set up credentials** for each service used in the workflow
2. **Get webhook URLs** using `./webhook-helper.sh` (automatic tunnel URL)
3. **Configure environment variables** if needed
4. **Test with sample data** before production use

### 🌐 Automatic Tunnel URL Support:
- All workflows automatically use your current tunnel URL
- Run `./webhook-helper.sh` to get specific webhook URLs
- Use tunnel URL (not localhost) for OAuth setup
- Environment variable `$env.N8N_TUNNEL_URL` available in all workflows

## 📋 Workflow Naming Convention

Workflows follow this pattern for easy identification:
```
[ID]_[Primary-Service]_[Secondary-Service]_[Purpose]_[Trigger-Type].json
```

Examples:
- `001_Gmail_Slack_New_Email_Notification_Webhook.json`
- `002_GitHub_Discord_PR_Updates_Webhook.json`
- `003_Shopify_Google_Sheets_Order_Tracking_Scheduled.json`

## 🔧 Workflow Categories

### 📧 Gmail (`/gmail/`)
Email automation, filtering, forwarding, and notifications.
- Email parsing and routing
- Automated responses
- Email-to-task conversion
- Notification systems

### 💬 Slack (`/slack/`)
Team communication and notification workflows.
- Channel management
- Alert systems
- Bot integrations
- Message routing

### 🎮 Discord (`/discord/`)
Discord server automation and bot workflows.
- Server moderation
- Notification bots
- Community management
- Game integrations

### 🔧 GitHub (`/github/`)
Code repository automation and CI/CD workflows.
- Issue management
- Pull request automation
- Release notifications
- Code quality checks

### 🤖 Automation (`/automation/`)
General-purpose automation workflows.
- File processing
- Data synchronization
- System maintenance
- Cross-platform integrations

### 🔗 Webhooks (`/webhooks/`)
HTTP-based integration workflows.
- API integrations
- Real-time notifications
- Event-driven automation
- Third-party service connections

### 📊 Data Processing (`/data-processing/`)
Data transformation and analysis workflows.
- CSV/JSON processing
- Database synchronization
- Report generation
- Data validation

### ⏰ Scheduling (`/scheduling/`)
Time-based automation workflows.
- Recurring tasks
- Backup automation
- Maintenance schedules
- Periodic reports

### 📈 Monitoring (`/monitoring/`)
System and service monitoring workflows.
- Health checks
- Performance monitoring
- Alert systems
- Uptime tracking

### 📱 Social Media (`/social-media/`)
Social platform automation workflows.
- Content publishing
- Engagement tracking
- Social listening
- Cross-platform posting

### 🛒 E-commerce (`/ecommerce/`)
Online business automation workflows.
- Order processing
- Inventory management
- Customer communications
- Payment processing

### 💻 Development (`/development/`)
Developer tools and workflow automation.
- Code deployment
- Testing automation
- Documentation generation
- Development notifications

## 🤝 Contributing Workflows

When adding new workflows to this library:

1. **Export from n8n**: Use the export feature to generate JSON
2. **Remove sensitive data**: Clean all credentials, personal URLs, and private information
3. **Follow naming convention**: Use the established pattern for consistency
4. **Add to appropriate category**: Place in the most relevant subdirectory
5. **Test thoroughly**: Ensure the workflow works as expected
6. **Document requirements**: Note any special setup requirements

### Quality Standards:
- ✅ Workflow must be functional and tested
- ✅ All sensitive data removed
- ✅ Clear, descriptive filename
- ✅ Compatible with recent n8n versions
- ✅ Proper error handling where applicable

## 📚 Learning Resources

- [n8n Documentation](https://docs.n8n.io/)
- [n8n Community Forum](https://community.n8n.io/)
- [n8n Academy](https://docs.n8n.io/courses/)
- [Workflow Templates](https://n8n.io/workflows/)

## 🆘 Getting Help

If you encounter issues with any workflow:

1. Check the [n8n documentation](https://docs.n8n.io/) for node-specific help
2. Verify your credentials and permissions
3. Test with simplified versions first
4. Ask questions in the [community forum](https://community.n8n.io/)
5. Check for n8n version compatibility

---

**Happy automating! 🚀**

*Remember: These workflows are templates - always customize and test before using in production.*
