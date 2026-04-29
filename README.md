# My OpenClaw Skills 🛠️

**English** | [简体中文](./README.zh-CN.md)

Personal collection of AI agent skills for [OpenClaw](https://github.com/openclaw/openclaw).

## 📚 Available Skills

### 🔒 Security
| Skill | Description |
|-------|-------------|
| [security-hardening](./security-hardening/) | Harden OpenClaw security: gateway, exec approvals, tool policies |
| [anthropic-token-refresh](./anthropic-token-refresh/) | Auto-refresh Claude setup-token using browser automation |

### 🔄 Automation
| Skill | Description |
|-------|-------------|
| [openclaw-updater](./openclaw-updater/) | Auto-sync OpenClaw from GitHub, daily update checks at 21:00 |
| [repo-to-blog-series](./repo-to-blog-series/) | Turn an open-source GitHub repo into a multi-article CSDN-style blog series with cinematic Gemini covers and ≤200-char abstracts |
| [theme-to-blog-series](./theme-to-blog-series/) | Turn a technical *topic* (not repo) into a multi-article blog series; sister of repo-to-blog-series with web-research upstream |

### 🎤 Voice & Media
| Skill | Description |
|-------|-------------|
| [voice-setup](./voice-setup/) | Set up free voice functionality (TTS + STT) using Edge TTS and whisper-cpp |

### 📝 Content Creation
| Skill | Description |
|-------|-------------|
| [csdn-blog-publisher](./csdn-blog-publisher/) | Write and publish high-quality tech blogs to CSDN |

### 🔧 Troubleshooting
| Skill | Description |
|-------|-------------|
| [fix-api-403](./fix-api-403/) | Fix Anthropic API 403 "Request not allowed" errors caused by geographic restrictions (e.g. China). Auto-deploys proxy preload for OpenClaw gateway |

### 📈 Finance & Market Data
| Skill | Description |
|-------|-------------|
| [eastmoney](./eastmoney/) | A-share market data: real-time quotes, sector rankings, fund NAV, dragon-tiger list via East Money/Sina/Xueqiu APIs |

### 📱 iOS Development (Full Lifecycle)

A comprehensive skill set covering the entire iOS app development journey from idea to App Store:

| Stage | Skill | Description |
|-------|-------|-------------|
| 1️⃣ Ideation | [ios-idea-validation](./ios-idea-validation/) | Validate app ideas, market research, TAM/SAM/SOM analysis |
| 2️⃣ Research | [ios-competitor-analysis](./ios-competitor-analysis/) | Analyze competitors, find differentiation opportunities |
| 3️⃣ Planning | [ios-prd-generator](./ios-prd-generator/) | Generate comprehensive Product Requirements Documents |
| 4️⃣ Design | [ios-ui-ux-design](./ios-ui-ux-design/) | Design following Apple HIG, accessibility, design systems |
| 5️⃣ Setup | [ios-project-setup](./ios-project-setup/) | Initialize Xcode projects with best practices |
| 6️⃣ Development | [ios-swiftui-development](./ios-swiftui-development/) | SwiftUI components, state management, animations |
| 7️⃣ Architecture | [ios-app-architecture](./ios-app-architecture/) | MVVM, TCA, Clean Architecture patterns |
| 8️⃣ Testing | [ios-testing](./ios-testing/) | Unit tests, UI tests, snapshot tests, TDD |
| 9️⃣ CI/CD | [ios-ci-cd](./ios-ci-cd/) | GitHub Actions, Fastlane, Xcode Cloud automation |
| 🔟 Publishing | [ios-app-store-publishing](./ios-app-store-publishing/) | App Store submission, ASO, review guidelines |

### 🗺️ iOS Development Workflow

```
💡 Idea
   ↓
┌─────────────────────────────────────────────────────────┐
│ Phase 1: Discovery                                       │
│   ios-idea-validation → ios-competitor-analysis         │
└─────────────────────────────────────────────────────────┘
   ↓
┌─────────────────────────────────────────────────────────┐
│ Phase 2: Planning                                        │
│   ios-prd-generator → ios-ui-ux-design                  │
└─────────────────────────────────────────────────────────┘
   ↓
┌─────────────────────────────────────────────────────────┐
│ Phase 3: Development                                     │
│   ios-project-setup → ios-swiftui-development           │
│                    → ios-app-architecture               │
└─────────────────────────────────────────────────────────┘
   ↓
┌─────────────────────────────────────────────────────────┐
│ Phase 4: Quality                                         │
│   ios-testing → ios-ci-cd                               │
└─────────────────────────────────────────────────────────┘
   ↓
┌─────────────────────────────────────────────────────────┐
│ Phase 5: Launch                                          │
│   ios-app-store-publishing                              │
└─────────────────────────────────────────────────────────┘
   ↓
🚀 App Store!
```

## 🚀 Usage

### Install Skills

1. Clone this repository:
```bash
git clone git@github.com:jx1100370217/my-openclaw-skills.git
```

2. Link to OpenClaw (add to your openclaw config):
```yaml
skills:
  paths:
    - /path/to/my-openclaw-skills
```

### Use a Skill

Just describe what you want to do, and the AI will automatically load the appropriate skill:

```
💬 "帮我验证一个新的 App 创意"
   → Uses: ios-idea-validation

💬 "分析一下 Notion 的竞品"
   → Uses: ios-competitor-analysis

💬 "写一个 SwiftUI 列表页面"
   → Uses: ios-swiftui-development

💬 "帮我写一篇关于 AI Agent 的博客发到 CSDN"
   → Uses: csdn-blog-publisher

💬 "查一下今天A股板块资金流入排名"
   → Uses: eastmoney

💬 "webchat returns 403 error"
   → Uses: fix-api-403
```

## 📁 Skill Structure

Each skill follows the OpenClaw skill format:

```
skill-name/
├── SKILL.md          # Main skill definition (required)
├── references/       # Reference documentation
├── assets/           # Templates, configs, code snippets
└── scripts/          # Automation scripts (if any)
```

## 🔄 Sync Across Devices

```bash
# On new machine
git clone git@github.com:jx1100370217/my-openclaw-skills.git

# Keep updated
git pull origin main
```

## 📝 License

MIT - Feel free to use and modify for your own needs.

---

Made with ❤️ by 小婧 (OpenClaw AI Assistant)
