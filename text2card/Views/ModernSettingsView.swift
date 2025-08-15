//
//  ModernSettingsView.swift
//  text2card
//
//  Created by Claude on 5/16/25.
//

import SwiftUI

struct ModernSettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("defaultTemplate") private var defaultTemplateIndex = 0
    @AppStorage("autoSave") private var autoSave = true
    @AppStorage("fontSize") private var fontSize = 16.0
    @AppStorage("enableMarkdown") private var enableMarkdown = true
    @AppStorage("hapticFeedback") private var hapticFeedback = true
    @AppStorage("cardQuality") private var cardQuality = "high"
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var cardViewModel: CardViewModel
    
    @State private var showingClearDataAlert = false
    @State private var showingExportAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 外观设置
                    SettingsSection(title: "外观", icon: "paintbrush.fill", color: .blue) {
                        // 主题模式
                        SettingsRow(
                            icon: "moon.circle.fill",
                            title: "深色模式",
                            iconColor: .indigo
                        ) {
                            Toggle("", isOn: $isDarkMode)
                                .labelsHidden()
                        }
                        
                        // 默认模板
                        SettingsRow(
                            icon: "square.grid.2x2.fill",
                            title: "默认模板",
                            subtitle: CardTemplate.templates[defaultTemplateIndex].name,
                            iconColor: .purple
                        ) {
                            Menu {
                                ForEach(0..<CardTemplate.templates.count, id: \.self) { index in
                                    Button(CardTemplate.templates[index].name) {
                                        defaultTemplateIndex = index
                                    }
                                }
                            } label: {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(white: 0.4))
                            }
                        }
                        
                        // 字体大小
                        VStack(spacing: 12) {
                            SettingsRow(
                                icon: "textformat.size",
                                title: "字体大小",
                                subtitle: "\(Int(fontSize))pt",
                                iconColor: .orange
                            ) {
                                EmptyView()
                            }
                            
                            Slider(value: $fontSize, in: 12...24, step: 1)
                                .tint(Color(white: 0.3))
                                .padding(.horizontal, 4)
                        }
                    }
                    
                    // 功能设置
                    SettingsSection(title: "功能", icon: "gearshape.fill", color: .green) {
                        SettingsRow(
                            icon: "doc.text.fill",
                            title: "Markdown 支持",
                            subtitle: "默认启用 Markdown 模式",
                            iconColor: .teal
                        ) {
                            Toggle("", isOn: $enableMarkdown)
                                .labelsHidden()
                        }
                        
                        SettingsRow(
                            icon: "square.and.arrow.down.fill",
                            title: "自动保存",
                            subtitle: "生成后自动保存到相册",
                            iconColor: .green
                        ) {
                            Toggle("", isOn: $autoSave)
                                .labelsHidden()
                        }
                        
                        SettingsRow(
                            icon: "hand.tap.fill",
                            title: "触觉反馈",
                            subtitle: "操作时的振动反馈",
                            iconColor: .pink
                        ) {
                            Toggle("", isOn: $hapticFeedback)
                                .labelsHidden()
                        }
                    }
                    
                    // 导出设置
                    SettingsSection(title: "导出", icon: "photo.fill", color: .orange) {
                        SettingsRow(
                            icon: "sparkles",
                            title: "卡片质量",
                            subtitle: cardQuality == "high" ? "高质量" : "标准",
                            iconColor: .yellow
                        ) {
                            Menu {
                                Button("高质量") {
                                    cardQuality = "high"
                                }
                                Button("标准") {
                                    cardQuality = "standard"
                                }
                            } label: {
                                Text(cardQuality == "high" ? "高质量" : "标准")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(white: 0.3))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color(white: 0.95))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    
                    // 数据管理
                    SettingsSection(title: "数据管理", icon: "externaldrive.fill", color: .red) {
                        SettingsRow(
                            icon: "square.and.arrow.up.fill",
                            title: "导出所有卡片",
                            subtitle: "共 \(cardViewModel.cards.count) 张卡片",
                            iconColor: .blue
                        ) {
                            Button(action: {
                                showingExportAlert = true
                            }) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(white: 0.4))
                            }
                        }
                        
                        SettingsRow(
                            icon: "trash.fill",
                            title: "清除所有数据",
                            subtitle: "删除所有卡片和设置",
                            iconColor: .red
                        ) {
                            Button(action: {
                                showingClearDataAlert = true
                            }) {
                                Text("清除")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    
                    // 关于
                    SettingsSection(title: "关于", icon: "info.circle.fill", color: .gray) {
                        SettingsRow(
                            icon: "app.badge.fill",
                            title: "版本",
                            subtitle: "1.0.0",
                            iconColor: .gray
                        ) {
                            EmptyView()
                        }
                        
                        SettingsRow(
                            icon: "heart.fill",
                            title: "评价应用",
                            iconColor: .pink
                        ) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(white: 0.4))
                        }
                        
                        SettingsRow(
                            icon: "envelope.fill",
                            title: "反馈建议",
                            iconColor: .blue
                        ) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(white: 0.4))
                        }
                    }
                    
                    Spacer(minLength: 30)
                }
                .padding()
            }
            .background(Color(white: 0.98))
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(white: 0.3))
                }
            }
        }
        .alert("清除所有数据", isPresented: $showingClearDataAlert) {
            Button("取消", role: .cancel) { }
            Button("清除", role: .destructive) {
                cardViewModel.clearAllCards()
            }
        } message: {
            Text("此操作将删除所有卡片，且无法恢复。确定要继续吗？")
        }
        .alert("导出功能", isPresented: $showingExportAlert) {
            Button("确定") { }
        } message: {
            Text("导出功能正在开发中，敬请期待！")
        }
    }
}

// MARK: - 子组件

struct SettingsSection<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 标题
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(white: 0.13))
            }
            .padding(.horizontal, 4)
            
            // 内容
            VStack(spacing: 0) {
                content
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
}

struct SettingsRow<Content: View>: View {
    let icon: String
    let title: String
    var subtitle: String? = nil
    let iconColor: Color
    @ViewBuilder let content: Content
    
    var body: some View {
        HStack(spacing: 16) {
            // 图标
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(iconColor)
                .cornerRadius(8)
            
            // 文字
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(white: 0.13))
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(Color(white: 0.5))
                }
            }
            
            Spacer()
            
            // 右侧内容
            content
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - ViewModel 扩展

extension CardViewModel {
    func clearAllCards() {
        cards.removeAll()
        saveCards()
    }
}

#Preview {
    ModernSettingsView()
        .environmentObject(CardViewModel())
}