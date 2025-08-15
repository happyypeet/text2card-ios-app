# text2card-ios-app

一个优雅的 iOS 应用，将文字转换为精美的分享卡片。

## ✨ 功能特点

- 📝 **文字转卡片** - 输入文字，一键生成精美卡片
- 🎨 **Markdown 支持** - 支持 Markdown 格式渲染
- 🎭 **多样式模板** - 12+ 种精心设计的卡片模板，包括 Claude 主题
- 💾 **本地存储** - 所有卡片自动保存，随时查看
- 📤 **分享导出** - 支持分享到社交平台或保存到相册
- ⚙️ **个性化设置** - 自定义字体、主题、默认模板等

## 🛠 技术栈

- **平台**: iOS 17.0+
- **框架**: SwiftUI
- **架构**: MVVM
- **依赖管理**: Swift Package Manager
- **主要依赖**: MarkdownUI

## 📱 界面预览

### 主界面
- 极简 Claude 风格设计
- 实时预览卡片效果
- 快速切换文本/Markdown 模式

### 设置页面
- 外观定制（深色模式、字体大小）
- 功能开关（自动保存、触觉反馈）
- 数据管理（导出、清除）

## 🚀 快速开始

### 环境要求
- Xcode 15.0+
- iOS 17.0+
- macOS 14.0+

### 安装步骤

1. 克隆仓库
```bash
git clone https://github.com/happyypeet/text2card-ios-app.git
cd text2card-ios-app
```

2. 打开项目
```bash
open text2card.xcodeproj
```

3. 安装依赖
   - 在 Xcode 中，选择 File > Add Packages
   - 添加 MarkdownUI: `https://github.com/gonzalezreal/swift-markdown-ui`

4. 运行项目
   - 选择目标设备或模拟器
   - 点击 Run 按钮（⌘R）

## 📂 项目结构

```
text2card/
├── Models/           # 数据模型
│   └── CardModel.swift
├── Views/            # 视图组件
│   ├── MainCardView.swift
│   ├── ModernSettingsView.swift
│   └── ClaudeTheme.swift
├── ViewModels/       # 视图模型
│   └── CardViewModel.swift
└── text2cardApp.swift  # 应用入口
```

## 🎨 设计理念

采用 Claude 的极简设计风格：
- 黑白灰主色调
- 优雅的圆角和阴影
- 清晰的信息层级
- 流畅的交互体验

## 📝 使用说明

1. **创建卡片**
   - 输入文字内容
   - 选择模板样式
   - 点击"生成精美卡片"

2. **编辑设置**
   - 点击右上角齿轮图标
   - 调整外观和功能设置
   - 设置自动保存

3. **分享卡片**
   - 查看生成的卡片
   - 点击分享或保存按钮
   - 选择目标平台

## 🤝 贡献

欢迎提交 Issues 和 Pull Requests！

## 📄 许可证

MIT License

## 👨‍💻 作者

- GitHub: [@happyypeet](https://github.com/happyypeet)

## 🙏 致谢

- [MarkdownUI](https://github.com/gonzalezreal/swift-markdown-ui) - Markdown 渲染支持
- Claude - 设计灵感来源