# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

iOS SwiftUI 应用，将文本转换为精美卡片，支持 Markdown 格式和多种模板样式。

## 常用命令

### 构建和测试
```bash
# 构建项目
xcodebuild -project text2card.xcodeproj -scheme text2card -configuration Debug build

# 运行单元测试
xcodebuild test -project text2card.xcodeproj -scheme text2card -destination 'platform=iOS Simulator,name=iPhone 15'

# 运行单个测试
xcodebuild test -project text2card.xcodeproj -scheme text2card -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:text2cardTests/text2cardTests/example

# 清理构建
xcodebuild clean -project text2card.xcodeproj -scheme text2card

# 在模拟器中运行应用
open -a Simulator
xcodebuild -project text2card.xcodeproj -scheme text2card -destination 'platform=iOS Simulator,name=iPhone 15' run
```

### 依赖管理
```bash
# 更新 Swift Package 依赖
xcodebuild -resolvePackageDependencies -project text2card.xcodeproj -scheme text2card
```

## 架构设计

### MVVM + 环境对象模式

应用使用 MVVM 架构配合 SwiftUI 的环境对象系统：

- **入口点**: `text2cardApp.swift` 创建单一 `CardViewModel` 实例作为 `@StateObject`，通过 `.environmentObject()` 注入整个视图层级
- **数据流**: 单向数据流 - 用户交互 → View → ViewModel → Model → UserDefaults 持久化
- **状态管理**: CardViewModel 作为单一数据源，管理所有卡片状态和业务逻辑

### 核心组件关系

1. **MainCardView** (主控制器)
   - 整合文本输入、模板选择、预览和生成功能
   - 通过 `@EnvironmentObject` 访问 CardViewModel
   - 管理 Sheet 展示（模板选择器、卡片详情）

2. **CardViewModel** (业务逻辑中心)
   - 维护 `@Published var cards: [Card]` 作为数据源
   - 处理 CRUD 操作：`addCard()`, `deleteCard()`, `toggleFavorite()`
   - UserDefaults 持久化：自动保存/加载卡片数据

3. **Card & CardTemplate** (数据模型)
   - Card: Codable 协议支持序列化，包含文本内容和样式属性
   - CardTemplate: 12 种预设样式，定义背景色、文字色、字体等

### 关键实现细节

- **Markdown 渲染**: 使用 MarkdownUI 库，通过 `isMarkdown` 标志切换 Text/Markdown 组件
- **图片生成**: `ImageRenderer` 将 SwiftUI View 渲染为 UIImage (text2card/Views/MainCardView.swift:431)
- **分享机制**: `UIActivityViewController` 包装为 `UIViewControllerRepresentable` (text2card/Views/MainCardView.swift:444)
- **数据持久化**: UserDefaults 存储 JSON 编码的卡片数组

## 开发环境要求

- **Xcode**: 15.0+
- **iOS 部署目标**: 17.0+
- **Swift**: 6.1+
- **测试框架**: Swift Testing (非 XCTest)
- **外部依赖**: MarkdownUI 2.0.0+ (通过 Swift Package Manager)