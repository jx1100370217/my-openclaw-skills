#!/bin/bash
# Check Anthropic token expiry
# Returns: DAYS_LEFT or error

AUTH_FILE="$HOME/.openclaw/agents/main/agent/auth-profiles.json"

if [ ! -f "$AUTH_FILE" ]; then
    echo "ERROR: Auth file not found: $AUTH_FILE"
    exit 1
fi

EXPIRES=$(cat "$AUTH_FILE" | jq -r '.profiles["anthropic:setup-token"].expires // 0')
NOW_MS=$(($(date +%s) * 1000))
DAYS_LEFT=$(( ($EXPIRES - $NOW_MS) / 1000 / 60 / 60 / 24 ))

echo "Token expires in $DAYS_LEFT days"

if [ "$DAYS_LEFT" -lt 30 ]; then
    echo "REFRESH_NEEDED"
    exit 1
else
    echo "OK"
    exit 0
fi
