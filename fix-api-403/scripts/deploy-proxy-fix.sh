#!/usr/bin/env bash
# deploy-proxy-fix.sh - Automatically fix Anthropic API 403 errors
# caused by geographic restrictions (e.g. China)
#
# Usage:
#   bash deploy-proxy-fix.sh [proxy-url]
#
# Default proxy: http://127.0.0.1:7897

set -euo pipefail

PROXY_URL="${1:-http://127.0.0.1:7897}"
SOCKS_PROXY="socks5://$(echo "$PROXY_URL" | sed 's|https\?://||')"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OPENCLAW_DIR="$HOME/.openclaw"
PRELOAD_SCRIPT="$OPENCLAW_DIR/scripts/proxy-preload.js"
PLIST_PATH="$HOME/Library/LaunchAgents/ai.openclaw.gateway.plist"

echo "=== OpenClaw API 403 Proxy Fix ==="
echo "Proxy URL: $PROXY_URL"
echo ""

# --- Step 0: Detect OpenClaw node_modules path ---
OPENCLAW_BIN="$(which openclaw 2>/dev/null || echo "")"
if [ -z "$OPENCLAW_BIN" ]; then
  echo "ERROR: 'openclaw' not found in PATH"
  exit 1
fi

OPENCLAW_REAL="$(readlink -f "$OPENCLAW_BIN" 2>/dev/null || realpath "$OPENCLAW_BIN" 2>/dev/null || echo "$OPENCLAW_BIN")"
# Resolve: .../bin/openclaw -> .../lib/node_modules/openclaw/node_modules
OPENCLAW_MODULES="$(dirname "$OPENCLAW_REAL")/../lib/node_modules/openclaw/node_modules"
OPENCLAW_MODULES="$(cd "$OPENCLAW_MODULES" 2>/dev/null && pwd || echo "$OPENCLAW_MODULES")"

if [ ! -d "$OPENCLAW_MODULES/undici" ]; then
  echo "ERROR: Cannot find undici in $OPENCLAW_MODULES"
  echo "Please set OPENCLAW_MODULES manually in the generated script"
  exit 1
fi

echo "[1/4] Found OpenClaw modules: $OPENCLAW_MODULES"

# --- Step 1: Generate proxy-preload.js ---
mkdir -p "$OPENCLAW_DIR/scripts"
sed "s|OPENCLAW_MODULES_PATH|$OPENCLAW_MODULES|g" \
  "$SCRIPT_DIR/proxy-preload.js.template" > "$PRELOAD_SCRIPT"

echo "[2/4] Generated $PRELOAD_SCRIPT"

# --- Step 2: Update LaunchAgent plist ---
if [ ! -f "$PLIST_PATH" ]; then
  echo "WARNING: LaunchAgent plist not found at $PLIST_PATH"
  echo "         You may need to run 'openclaw gateway install' first"
  echo "         Or manually add proxy env vars to your gateway startup"
  exit 1
fi

# Check if proxy already configured
if grep -q "http_proxy" "$PLIST_PATH"; then
  echo "[3/4] Proxy already in plist, updating values..."
  # Use temporary python to safely update plist values
  python3 -c "
import plistlib, sys

with open('$PLIST_PATH', 'rb') as f:
    plist = plistlib.load(f)

env = plist.get('EnvironmentVariables', {})
env['http_proxy'] = '$PROXY_URL'
env['https_proxy'] = '$PROXY_URL'
env['HTTP_PROXY'] = '$PROXY_URL'
env['HTTPS_PROXY'] = '$PROXY_URL'
env['ALL_PROXY'] = '$SOCKS_PROXY'
env['NODE_OPTIONS'] = '--require $PRELOAD_SCRIPT'
plist['EnvironmentVariables'] = env

with open('$PLIST_PATH', 'wb') as f:
    plistlib.dump(plist, f)
print('    Updated proxy settings in plist')
"
else
  echo "[3/4] Adding proxy settings to plist..."
  python3 -c "
import plistlib

with open('$PLIST_PATH', 'rb') as f:
    plist = plistlib.load(f)

env = plist.get('EnvironmentVariables', {})
env['http_proxy'] = '$PROXY_URL'
env['https_proxy'] = '$PROXY_URL'
env['HTTP_PROXY'] = '$PROXY_URL'
env['HTTPS_PROXY'] = '$PROXY_URL'
env['ALL_PROXY'] = '$SOCKS_PROXY'
env['NODE_OPTIONS'] = '--require $PRELOAD_SCRIPT'
plist['EnvironmentVariables'] = env

with open('$PLIST_PATH', 'wb') as f:
    plistlib.dump(plist, f)
print('    Added proxy settings to plist')
"
fi

# --- Step 3: Reload gateway ---
echo "[4/4] Reloading gateway..."
UID_NUM="$(id -u)"
launchctl bootout "gui/$UID_NUM/ai.openclaw.gateway" 2>/dev/null || true
sleep 2
launchctl bootstrap "gui/$UID_NUM" "$PLIST_PATH" 2>/dev/null || true
sleep 3

# --- Verify ---
echo ""
echo "=== Verification ==="
PID="$(pgrep -f openclaw-gateway 2>/dev/null || echo "")"
if [ -n "$PID" ]; then
  echo "Gateway running: PID $PID"
else
  echo "WARNING: Gateway may not be running. Check logs:"
  echo "  tail -20 ~/.openclaw/logs/gateway.log"
  echo "  tail -20 ~/.openclaw/logs/gateway.err.log"
fi

# Quick proxy check
echo ""
echo "Testing proxy connectivity to Anthropic API..."
HTTP_CODE="$(curl -s -o /dev/null -w '%{http_code}' --proxy "$PROXY_URL" --max-time 10 \
  'https://api.anthropic.com/v1/messages' \
  -H 'anthropic-version: 2023-06-01' \
  -H 'content-type: application/json' \
  -d '{}' 2>/dev/null || echo "000")"

if [ "$HTTP_CODE" = "401" ] || [ "$HTTP_CODE" = "400" ]; then
  echo "Proxy connectivity OK (API reachable, got HTTP $HTTP_CODE as expected without auth)"
elif [ "$HTTP_CODE" = "403" ]; then
  echo "WARNING: Still getting 403. Proxy may not be working correctly."
elif [ "$HTTP_CODE" = "000" ]; then
  echo "WARNING: Cannot reach API through proxy. Check proxy is running on $PROXY_URL"
else
  echo "API returned HTTP $HTTP_CODE through proxy"
fi

echo ""
echo "=== Done ==="
echo "To test: openclaw agent --message 'hello' --agent main --json | head -10"
