#!/bin/bash
# OpenClaw Security Hardening Script
# Run this script to apply security best practices

set -e

echo "🔒 OpenClaw Security Hardening"
echo "=============================="
echo ""

# Check if OpenClaw is installed
if ! command -v openclaw &> /dev/null; then
    echo "❌ OpenClaw not found. Please install it first."
    exit 1
fi

echo "✅ OpenClaw found"

# Create exec-approvals.json if it doesn't exist
APPROVALS_FILE="$HOME/.openclaw/exec-approvals.json"
if [ ! -f "$APPROVALS_FILE" ]; then
    echo ""
    echo "📝 Creating exec-approvals.json..."
    cat > "$APPROVALS_FILE" << 'EOF'
{
  "version": 1,
  "defaults": {
    "security": "allowlist",
    "ask": "on-miss",
    "askFallback": "deny",
    "autoAllowSkills": true
  },
  "agents": {
    "main": {
      "security": "allowlist",
      "ask": "on-miss",
      "askFallback": "deny",
      "autoAllowSkills": true,
      "allowlist": [
        { "pattern": "/opt/homebrew/bin/*", "note": "Homebrew binaries" },
        { "pattern": "/usr/bin/*", "note": "System binaries" },
        { "pattern": "/bin/*", "note": "Core binaries" },
        { "pattern": "/usr/local/bin/*", "note": "Local binaries" }
      ]
    }
  }
}
EOF
    echo "   Created: $APPROVALS_FILE"
else
    echo ""
    echo "ℹ️  exec-approvals.json already exists, skipping..."
fi

# Run security audit
echo ""
echo "🔍 Running security audit..."
echo ""
openclaw security audit --deep 2>&1 || true

# Run doctor
echo ""
echo "🩺 Running doctor check..."
echo ""
openclaw doctor --non-interactive 2>&1 | head -30 || true

echo ""
echo "🎉 Hardening complete!"
echo ""
echo "Recommended next steps:"
echo "1. Review ~/.openclaw/openclaw.json for security settings"
echo "2. Ensure gateway.bind is 'loopback'"
echo "3. Ensure gateway.auth.mode is 'token' or 'password'"
echo "4. Set channel policies to 'allowlist'"
echo "5. Run: openclaw security audit --deep"
