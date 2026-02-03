---
name: security-hardening
description: Harden OpenClaw security configuration. Use when: (1) Setting up security for new OpenClaw installation, (2) Configuring exec approvals and allowlists, (3) Securing gateway access, (4) Setting up tool policies, (5) User asks about OpenClaw security or hardening.
---

# OpenClaw Security Hardening Skill

This skill provides a comprehensive guide for securing your OpenClaw installation.

## Security Checklist

| Area | Configuration | Status |
|------|---------------|--------|
| 🌐 Gateway | Bind to loopback | Required |
| 🔑 Auth | Token/password authentication | Required |
| 📱 Channels | Allowlist policy | Recommended |
| ⚡ Exec | Allowlist + approvals | Recommended |
| 🛡️ Elevated | Allowlist only | Recommended |
| 🧰 Tools | Deny dangerous tools | Optional |

## 1. Gateway Security

### Bind to Loopback (Required)

Never expose the gateway to public networks without authentication.

```json5
{
  "gateway": {
    "mode": "local",
    "bind": "loopback",  // Only localhost access
    "port": 18789,
    "auth": {
      "mode": "token",
      "token": "<strong-random-token>"
    }
  }
}
```

Generate a strong token:
```bash
openssl rand -hex 24
```

### Remote Access (If needed)

For remote access, use Tailscale instead of exposing the gateway:

```json5
{
  "gateway": {
    "tailscale": {
      "mode": "serve"  // or "funnel" for public access
    }
  }
}
```

## 2. Channel Security

### Allowlist Policy (Recommended)

Restrict who can interact with your agent:

```json5
{
  "channels": {
    "telegram": {
      "dmPolicy": "allowlist",
      "allowFrom": [123456789],  // Your Telegram user ID
      "groupPolicy": "allowlist",
      "allowGroups": []  // Specific group IDs
    },
    "whatsapp": {
      "dmPolicy": "allowlist",
      "allowFrom": ["+1234567890"]
    }
  }
}
```

## 3. Exec Approvals

### Configure Exec Approvals File

Create `~/.openclaw/exec-approvals.json`:

```json
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
        { "pattern": "/opt/homebrew/bin/*" },
        { "pattern": "/usr/bin/*" },
        { "pattern": "/bin/*" },
        { "pattern": "/usr/local/bin/*" }
      ]
    }
  }
}
```

### Security Modes

| Mode | Description |
|------|-------------|
| `deny` | Block all exec requests |
| `allowlist` | Allow only allowlisted commands |
| `full` | Allow everything (dangerous!) |

### Ask Modes

| Mode | Description |
|------|-------------|
| `off` | Never prompt |
| `on-miss` | Prompt when not in allowlist |
| `always` | Always prompt |

## 4. Tool Policies

### Exec Tool Configuration

```json5
{
  "tools": {
    "exec": {
      "host": "sandbox",           // Default to sandbox
      "security": "allowlist",     // Require allowlist
      "ask": "on-miss",            // Prompt for unknown commands
      "safeBins": ["jq", "grep", "cat", "echo"]  // Safe stdin-only tools
    }
  }
}
```

### Elevated Access Control

Only allow elevated access from specific users:

```json5
{
  "tools": {
    "elevated": {
      "enabled": true,
      "allowFrom": {
        "telegram": ["123456789"],
        "whatsapp": ["+1234567890"]
      }
    }
  }
}
```

### Deny Dangerous Tools

For high-security environments, deny certain tools:

```json5
{
  "agents": {
    "defaults": {
      "tools": {
        "deny": ["gateway", "browser"]
      }
    }
  }
}
```

## 5. Approval Forwarding

Forward exec approval requests to your chat channel:

```json5
{
  "approvals": {
    "exec": {
      "enabled": true,
      "mode": "both",
      "targets": [
        { "channel": "telegram", "to": "123456789" }
      ]
    }
  }
}
```

Approve via chat:
```
/approve <id> allow-once
/approve <id> allow-always
/approve <id> deny
```

## 6. Verification

### Run Security Audit

```bash
openclaw security audit --deep
```

### Check Configuration

```bash
openclaw doctor --non-interactive
```

### Expected Output

- 0 critical issues
- No channel security warnings

## Quick Setup Script

Run the included setup script:

```bash
./scripts/harden.sh
```

## Common Issues

### "Permission denied" errors
Your exec allowlist may be too restrictive. Add the needed binary paths.

### Can't run commands
Check if `security` is set to `deny`. Change to `allowlist`.

### Approval timeout
If no UI is available, requests will time out. Set `askFallback` appropriately.

## Security Best Practices

1. **Principle of least privilege** - Only allow what's needed
2. **Regular audits** - Run `openclaw security audit` periodically
3. **Monitor logs** - Check `~/.openclaw/logs/` for suspicious activity
4. **Keep updated** - Run `openclaw update` regularly
5. **Backup config** - Keep your `openclaw.json` backed up
