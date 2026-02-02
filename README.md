# My OpenClaw Skills 🦞

个人 OpenClaw 技能库，可在任意设备上复用。

## 📦 技能列表

### 📝 内容创作
| 技能 | 描述 |
|------|------|
| [csdn-blog-publisher](./csdn-blog-publisher/) | 撰写并发布技术博客到 CSDN |

### 📱 iOS 开发
| 技能 | 描述 |
|------|------|
| [ios-swiftui-development](./ios-swiftui-development/) | SwiftUI 开发：UI 组件、状态管理、动画、导航 |
| [ios-app-architecture](./ios-app-architecture/) | iOS 架构设计：MVVM、TCA、Clean Architecture、模块化 |
| [ios-app-store-publishing](./ios-app-store-publishing/) | App Store 发布：ASO 优化、审核指南、上架流程 |

## 🚀 使用方法

### 方式一：直接复制到 OpenClaw skills 目录

```bash
# 克隆仓库
git clone https://github.com/jx1100370217/my-openclaw-skills.git

# 复制所需技能到 OpenClaw
cp -r my-openclaw-skills/ios-swiftui-development /path/to/openclaw/skills/
cp -r my-openclaw-skills/ios-app-architecture /path/to/openclaw/skills/
cp -r my-openclaw-skills/ios-app-store-publishing /path/to/openclaw/skills/
```

### 方式二：软链接

```bash
ln -s $(pwd)/my-openclaw-skills/ios-swiftui-development ~/.openclaw/skills/
ln -s $(pwd)/my-openclaw-skills/ios-app-architecture ~/.openclaw/skills/
```

## 📝 技能详情

### csdn-blog-publisher
自动化 CSDN 博客发布流程：
- 📚 内容研究与资料收集
- ✍️ 符合 CSDN 规范的博客撰写
- 🖼️ 免费封面图获取
- 🌐 浏览器自动化发布

### ios-swiftui-development
SwiftUI 现代化 iOS 开发：
- 🎨 UI 组件快速参考（List, Grid, Navigation）
- 📊 状态管理（@State, @Binding, @Observable）
- ✨ 动画与转场效果
- 🔧 自定义修饰符和性能优化

### ios-app-architecture
可扩展的 iOS 架构设计：
- 🏗️ MVVM / TCA / Clean Architecture
- 💉 依赖注入模式
- 📦 Swift Package 模块化
- 🧪 测试策略

### ios-app-store-publishing
App Store 成功上架指南：
- ✅ 提交前检查清单
- 🎯 ASO 优化策略
- 📋 审核指南解读
- 🚫 常见拒审原因及解决

## 🔄 触发示例

```
"帮我用 SwiftUI 写一个列表页面"
"设计一个 iOS app 的架构"
"准备发布我的 app 到 App Store"
"帮我写一篇关于 xxx 的博客发到 CSDN"
```

## 📚 参考资源

- [Apple SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Point-Free Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)
- [Awesome iOS](https://github.com/vsouza/awesome-ios)

## 📄 License

MIT
