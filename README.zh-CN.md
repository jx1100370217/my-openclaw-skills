# 我的 OpenClaw 技能库 🛠️

[English](./README.md) | **简体中文**

个人 AI 代理技能集合，适用于 [OpenClaw](https://github.com/openclaw/openclaw)。

## 📚 技能列表

### 🔒 安全
| 技能 | 描述 |
|------|------|
| [security-hardening](./security-hardening/) | OpenClaw 安全加固：网关、执行审批、工具策略 |
| [anthropic-token-refresh](./anthropic-token-refresh/) | 使用浏览器自动化自动刷新 Claude setup-token |

### 🔄 自动化
| 技能 | 描述 |
|------|------|
| [openclaw-updater](./openclaw-updater/) | 自动从 GitHub 同步 OpenClaw，每天 21:00 检查更新 |
| [repo-to-blog-series](./repo-to-blog-series/) | 把开源 GitHub 仓库写成多篇 CSDN 风格深度技术博客系列，自动并行写作 + Gemini 电影级封面 + ≤200 字摘要 |
| [theme-to-blog-series](./theme-to-blog-series/) | 把一个技术**主题**（不是仓库）写成多篇深度博客系列；上游走 WebSearch/WebFetch 检索权威资料而非读代码，下游与 repo-to-blog-series 同管线 |

### 🎤 语音与媒体
| 技能 | 描述 |
|------|------|
| [voice-setup](./voice-setup/) | 配置免费语音功能（TTS + STT），使用 Edge TTS 和 whisper-cpp |

### 📝 内容创作
| 技能 | 描述 |
|------|------|
| [csdn-blog-publisher](./csdn-blog-publisher/) | 撰写并发布高质量技术博客到 CSDN |

### 🔧 故障排除
| 技能 | 描述 |
|------|------|
| [fix-api-403](./fix-api-403/) | 修复 Anthropic API 403 "Request not allowed" 错误，解决地域网络限制（如中国大陆）导致的 API 访问问题。自动部署代理预加载脚本 |

### 📈 金融与行情数据
| 技能 | 描述 |
|------|------|
| [eastmoney](./eastmoney/) | A股行情数据：实时行情、板块排行、基金净值估算、龙虎榜，基于东方财富/新浪/雪球 API |

### 📱 iOS 开发（全生命周期）

一套完整的技能集，涵盖 iOS App 开发从创意到上架的全过程：

| 阶段 | 技能 | 描述 |
|------|------|------|
| 1️⃣ 创意 | [ios-idea-validation](./ios-idea-validation/) | 验证 App 创意、市场调研、TAM/SAM/SOM 分析 |
| 2️⃣ 调研 | [ios-competitor-analysis](./ios-competitor-analysis/) | 分析竞品、寻找差异化机会 |
| 3️⃣ 规划 | [ios-prd-generator](./ios-prd-generator/) | 生成完整的产品需求文档（PRD） |
| 4️⃣ 设计 | [ios-ui-ux-design](./ios-ui-ux-design/) | 遵循 Apple HIG 设计、无障碍、设计系统 |
| 5️⃣ 初始化 | [ios-project-setup](./ios-project-setup/) | 使用最佳实践初始化 Xcode 项目 |
| 6️⃣ 开发 | [ios-swiftui-development](./ios-swiftui-development/) | SwiftUI 组件、状态管理、动画 |
| 7️⃣ 架构 | [ios-app-architecture](./ios-app-architecture/) | MVVM、TCA、Clean Architecture 架构模式 |
| 8️⃣ 测试 | [ios-testing](./ios-testing/) | 单元测试、UI 测试、快照测试、TDD |
| 9️⃣ 自动化 | [ios-ci-cd](./ios-ci-cd/) | GitHub Actions、Fastlane、Xcode Cloud 自动化 |
| 🔟 发布 | [ios-app-store-publishing](./ios-app-store-publishing/) | App Store 提交、ASO、审核指南 |

### 🗺️ iOS 开发工作流

```
💡 创意
   ↓
┌─────────────────────────────────────────────────────────┐
│ 第一阶段：发现                                            │
│   ios-idea-validation → ios-competitor-analysis         │
│   创意验证               竞品分析                         │
└─────────────────────────────────────────────────────────┘
   ↓
┌─────────────────────────────────────────────────────────┐
│ 第二阶段：规划                                            │
│   ios-prd-generator → ios-ui-ux-design                  │
│   PRD 文档生成           UI/UX 设计                      │
└─────────────────────────────────────────────────────────┘
   ↓
┌─────────────────────────────────────────────────────────┐
│ 第三阶段：开发                                            │
│   ios-project-setup → ios-swiftui-development           │
│   项目初始化           → ios-app-architecture            │
│                         SwiftUI 开发 / 架构设计           │
└─────────────────────────────────────────────────────────┘
   ↓
┌─────────────────────────────────────────────────────────┐
│ 第四阶段：质量                                            │
│   ios-testing → ios-ci-cd                               │
│   测试            CI/CD 自动化                           │
└─────────────────────────────────────────────────────────┘
   ↓
┌─────────────────────────────────────────────────────────┐
│ 第五阶段：发布                                            │
│   ios-app-store-publishing                              │
│   App Store 发布                                         │
└─────────────────────────────────────────────────────────┘
   ↓
🚀 App Store 上架！
```

## 🚀 使用方法

### 安装技能

1. 克隆此仓库：
```bash
git clone git@github.com:jx1100370217/my-openclaw-skills.git
```

2. 链接到 OpenClaw（添加到你的 openclaw 配置）：
```yaml
skills:
  paths:
    - /path/to/my-openclaw-skills
```

### 使用技能

只需描述你想做的事情，AI 会自动加载相应的技能：

```
💬 "帮我验证一个新的 App 创意"
   → 使用：ios-idea-validation

💬 "分析一下 Notion 的竞品"
   → 使用：ios-competitor-analysis

💬 "写一个 SwiftUI 列表页面"
   → 使用：ios-swiftui-development

💬 "帮我写一篇关于 AI Agent 的博客发到 CSDN"
   → 使用：csdn-blog-publisher

💬 "查一下今天A股板块资金流入排名"
   → 使用：eastmoney

💬 "网关报 403 错误怎么修复"
   → 使用：fix-api-403
```

## 📁 技能结构

每个技能都遵循 OpenClaw 技能格式：

```
skill-name/
├── SKILL.md          # 主技能定义（必需）
├── references/       # 参考文档
├── assets/           # 模板、配置、代码片段
└── scripts/          # 自动化脚本（如有）
```

## 🔄 跨设备同步

```bash
# 在新设备上
git clone git@github.com:jx1100370217/my-openclaw-skills.git

# 保持更新
git pull origin main
```

## 📝 许可证

MIT - 可自由使用和修改。

---

由 小婧（OpenClaw AI 助手）用 ❤️ 制作
