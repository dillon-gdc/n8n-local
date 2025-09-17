#!/bin/bash

# Environment Helper Functions
# Safe functions for updating .env files

# Function to safely update or add environment variable
update_env_var() {
    local key="$1"
    local value="$2"
    local env_file="${3:-.env}"
    
    if [ ! -f "$env_file" ]; then
        echo "❌ Environment file $env_file not found"
        return 1
    fi
    
    # Create backup
    cp "$env_file" "${env_file}.backup.$(date +%s)"
    
    # Check if the key exists (as a real variable, not in comments)
    if grep -q "^${key}=" "$env_file"; then
        # Key exists, update it
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS sed
            sed -i '' "s|^${key}=.*|${key}=${value}|" "$env_file"
        else
            # Linux sed
            sed -i "s|^${key}=.*|${key}=${value}|" "$env_file"
        fi
        echo "✅ Updated ${key} in ${env_file}"
    else
        # Key doesn't exist as a variable, need to add it
        # Use awk to place it correctly after the comment
        awk -v key="$key" -v value="$value" '
        /^# Current tunnel URL \(automatically updated by start\.sh\)/ {
            print $0
            print key "=" value
            next
        }
        { print }
        ' "$env_file" > "${env_file}.tmp" && mv "${env_file}.tmp" "$env_file"
        echo "✅ Added ${key} to ${env_file}"
    fi
    
    return 0
}

# Function to get environment variable value
get_env_var() {
    local key="$1"
    local env_file="${2:-.env}"
    
    if [ ! -f "$env_file" ]; then
        echo ""
        return 1
    fi
    
    grep "^${key}=" "$env_file" | cut -d'=' -f2- | tr -d '"' | tr -d "'"
}

# Function to validate environment file
validate_env_file() {
    local env_file="${1:-.env}"
    
    if [ ! -f "$env_file" ]; then
        echo "❌ Environment file $env_file not found"
        return 1
    fi
    
    # Check for common issues
    local issues=0
    
    # Check for duplicate keys
    local duplicates=$(grep -E "^[A-Z_].*=" "$env_file" | cut -d'=' -f1 | sort | uniq -d)
    if [ -n "$duplicates" ]; then
        echo "⚠️  Duplicate keys found: $duplicates"
        issues=$((issues + 1))
    fi
    
    # Check for malformed lines (lines that start with var name but don't have =)
    local malformed=$(grep -E "^[A-Z_]+[^=]*$" "$env_file" | grep -v "^#" | grep -v "=")
    if [ -n "$malformed" ]; then
        echo "⚠️  Malformed lines found:"
        echo "$malformed"
        issues=$((issues + 1))
    fi
    
    if [ $issues -eq 0 ]; then
        echo "✅ Environment file is valid"
        return 0
    else
        echo "❌ Environment file has $issues issue(s)"
        return 1
    fi
}

# Function to restore from backup
restore_env_backup() {
    local env_file="${1:-.env}"
    local backup_file
    
    # Find the most recent backup
    backup_file=$(ls -t "${env_file}.backup."* 2>/dev/null | head -1)
    
    if [ -n "$backup_file" ] && [ -f "$backup_file" ]; then
        cp "$backup_file" "$env_file"
        echo "✅ Restored $env_file from $backup_file"
        return 0
    else
        echo "❌ No backup file found for $env_file"
        return 1
    fi
}

# Main function to safely update tunnel URL
update_tunnel_url() {
    local tunnel_url="$1"
    
    if [ -z "$tunnel_url" ]; then
        echo "❌ No tunnel URL provided"
        return 1
    fi
    
    echo "🔄 Safely updating tunnel URL in .env..."
    
    if update_env_var "N8N_TUNNEL_URL" "$tunnel_url"; then
        echo "✅ Tunnel URL updated successfully"
        validate_env_file
        return 0
    else
        echo "❌ Failed to update tunnel URL"
        return 1
    fi
}

# If script is run directly (not sourced), run the main function
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [ $# -eq 0 ]; then
        echo "Usage: $0 <tunnel_url>"
        echo "Example: $0 https://abc123.hooks.n8n.cloud/"
        exit 1
    fi
    
    update_tunnel_url "$1"
fi
