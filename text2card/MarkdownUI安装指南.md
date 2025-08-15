# MarkdownUI 安装指南

## 问题描述

在项目中遇到了 `No such module 'MarkdownUI'` 错误，这表明项目中缺少 MarkdownUI 依赖。

## 解决方案

根据项目的 README.md 文件中的说明，本项目使用了 MarkdownUI 库来支持 Markdown 渲染。请按照以下步骤添加依赖：

### 在 Xcode 中添加 Swift Package 依赖

1. 在 Xcode 中打开项目
2. 选择 File > Add Packages...
3. 在搜索栏中输入：`https://github.com/gonzalezreal/swift-markdown-ui`
4. 选择版本 2.0.0 或更高版本
5. 点击 Add Package 添加到项目中
6. 在弹出的窗口中，确保选择了 `text2card` 作为目标
7. 点击 Add Package 完成添加

### 验证安装

添加包后，请尝试重新构建项目，错误应该已经解决。如果仍然存在问题，请尝试以下步骤：

1. 关闭并重新打开 Xcode
2. 清理项目缓存：选择 Product > Clean Build Folder
3. 重新构建项目

## 其他可能的解决方案

如果上述方法不起作用，可能是由于以下原因：

1. Swift Package 缓存问题：可以尝试在 Xcode 中选择 File > Packages > Reset Package Caches
2. 项目设置问题：检查项目的 Build Settings 中是否正确配置了 Swift Package 依赖

## 参考资料

- [MarkdownUI GitHub 仓库](https://github.com/gonzalezreal/swift-markdown-ui)
- [Swift Package Manager 文档](https://www.swift.org/package-manager/)