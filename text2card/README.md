# Text2Card iOS应用

## 项目概述

这是一个iOS应用程序，可以将文本转换为精美的卡片，支持以下功能：

1. 文字转换为漂亮的卡片
2. 支持Markdown格式转换为卡片
3. 卡片可以添加姓名和二维码
4. 支持分享和保存卡片到本地图库
5. 提供多种漂亮的卡片模板

## 项目结构

- **Models/**: 数据模型
  - `CardModel.swift`: 卡片和模板数据结构
- **Views/**: 用户界面
  - `HomeView.swift`: 主页面
  - `CreateCardView.swift`: 创建卡片
  - `CardManagementView.swift`: 卡片管理
  - `TemplateLibraryView.swift`: 模板库
  - `SettingsView.swift`: 设置页面
- **ViewModels/**: 视图模型
  - `CardViewModel.swift`: 卡片数据管理

## 安装说明

### 依赖项

本项目使用了MarkdownUI库来支持Markdown渲染。请按照以下步骤添加依赖：

1. 在Xcode中，选择File > Add Packages...
2. 在搜索栏中输入：`https://github.com/gonzalezreal/swift-markdown-ui`
3. 选择版本2.0.0或更高版本
4. 点击Add Package添加到项目中

### 运行项目

1. 使用Xcode打开项目
2. 选择一个iOS模拟器或连接的设备
3. 点击Run按钮运行应用

## 使用说明

### 创建卡片

1. 在主页面点击"创建卡片"按钮
2. 输入文本内容（支持普通文本或Markdown格式）
3. 选择卡片模板和个性化设置
4. 点击"下一步"完成创建

### 管理卡片

在"卡片"标签页中可以查看、编辑和删除已创建的卡片。

### 分享卡片

1. 点击卡片查看详情
2. 使用分享按钮将卡片分享给他人
3. 或使用保存按钮将卡片保存到相册