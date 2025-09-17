# Gmail Workflows

Email automation workflows using Gmail integration.

## 📧 Available Workflows

### 001_Gmail_Slack_New_Email_Notification_Webhook.json
**Purpose**: Send Slack notifications when new emails are received via webhook

**Setup Requirements**:
1. **Gmail**: Set up Gmail webhook (Gmail Push Notifications API)
2. **Slack**: Create Slack App and get OAuth token
3. **Webhook**: Configure the webhook URL in your Gmail settings

**Configuration Steps**:
1. Import the workflow into n8n
2. Set up Slack credentials in n8n
3. Replace `REPLACE_WITH_YOUR_WEBHOOK_ID` with actual webhook ID
4. Update Slack channel name if needed
5. Configure Gmail to send webhooks to: `https://your-n8n-url/webhook/gmail-webhook`

**Features**:
- Real-time email notifications
- Rich Slack message with email preview
- Email subject, sender, and body preview
- Customizable notification format

**Required Credentials**:
- Slack OAuth Token (Bot User OAuth Token)
- Gmail API credentials (for webhook setup)

**Usage**: 
Once configured, every new email in your Gmail will trigger a notification in your specified Slack channel.

---

## 🔧 General Gmail Setup

### Prerequisites
1. **Gmail API Access**: Enable Gmail API in Google Cloud Console
2. **OAuth Credentials**: Create OAuth 2.0 credentials for your application
3. **Webhook Configuration**: Set up Gmail push notifications

### Common Setup Steps
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Enable Gmail API for your project
3. Create OAuth 2.0 credentials
4. Configure webhook endpoints in Gmail settings
5. Add credentials to n8n credential manager

### Security Notes
- Use minimal required Gmail API scopes
- Store credentials securely in n8n
- Regularly rotate API keys
- Monitor webhook endpoint for unauthorized access

---

*More Gmail workflows coming soon!*
