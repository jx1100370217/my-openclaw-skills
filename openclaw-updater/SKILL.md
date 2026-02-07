---
name: openclaw-updater
description: Check and update OpenClaw to the latest version from GitHub. Use when the user asks to update OpenClaw, check for updates, sync with GitHub, or review changelog. Handles source installation from GitHub.
---

# OpenClaw Updater

Automate OpenClaw updates from GitHub repository.

## Source Location

OpenClaw source is installed at: `/Users/jianxiong/.openclaw/source/openclaw`

## Check for Updates

1. Get current installed version:
   ```bash
   head -5 /Users/jianxiong/.openclaw/source/openclaw/package.json | grep version
   ```

2. Fetch latest GitHub version:
   ```bash
   curl -s "https://raw.githubusercontent.com/openclaw/openclaw/main/package.json" | head -5 | grep version
   ```

3. Fetch changelog for update details:
   ```bash
   curl -s "https://raw.githubusercontent.com/openclaw/openclaw/main/CHANGELOG.md" | head -200
   ```

## Update from GitHub Source

```bash
cd /Users/jianxiong/.openclaw/source/openclaw
git pull origin main
pnpm install
pnpm build
npm install -g .
```

## Update Summary Format (Chinese)

```
🔄 **OpenClaw 更新摘要**

📦 当前版本: `X.X.X`
🆕 最新版本: `Y.Y.Y`

**主要更新**
• [Feature 1]
• [Feature 2]

**修复**
• [Fix 1]
• [Fix 2]
```

## Post-Update Actions

1. Verify new version: `npm list -g openclaw`
2. Restart gateway: use `gateway` tool with `action: "restart"`
3. Send summary to Telegram (target: 6033691813)

## Cron Job

Daily 9 PM (21:00 Asia/Shanghai) auto-update is configured via OpenClaw cron tool.
