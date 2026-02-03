#!/bin/bash
# Update Anthropic token in auth-profiles.json
# Usage: ./update-token.sh <new-token>

AUTH_FILE="$HOME/.openclaw/agents/main/agent/auth-profiles.json"
NEW_TOKEN="$1"

if [ -z "$NEW_TOKEN" ]; then
    echo "Usage: $0 <new-token>"
    exit 1
fi

if [ ! -f "$AUTH_FILE" ]; then
    echo "ERROR: Auth file not found: $AUTH_FILE"
    exit 1
fi

# Calculate expiry (1 year from now)
EXPIRES=$(($(date +%s) * 1000 + 365 * 24 * 60 * 60 * 1000))

# Update the token
cat "$AUTH_FILE" | jq \
    --arg token "$NEW_TOKEN" \
    --argjson expires "$EXPIRES" \
    '.profiles["anthropic:setup-token"].token = $token | .profiles["anthropic:setup-token"].expires = $expires' \
    > "${AUTH_FILE}.tmp" && mv "${AUTH_FILE}.tmp" "$AUTH_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Token updated successfully!"
    echo "New expiry: $(date -r $((EXPIRES / 1000)) '+%Y-%m-%d %H:%M:%S')"
else
    echo "❌ Failed to update token"
    exit 1
fi
