//
//  ThemeManagementView.swift
//  text2card
//
//  Created by Claude on 5/16/25.
//

import SwiftUI

struct ThemeManagementView: View {
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @EnvironmentObject var cardViewModel: CardViewModel
    @State private var showingThemeEditor = false
    @State private var editingTheme: Theme?
    @State private var showingDeleteAlert = false
    @State private var themeToDelete: Theme?
    
    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // 背景
                Color(white: 0.98)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // 搜索栏和筛选
                    VStack(spacing: 16) {
                        // 搜索框
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(white: 0.5))
                            
                            TextField("搜索主题", text: $themeViewModel.searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                            
                            if !themeViewModel.searchText.isEmpty {
                                Button(action: {
                                    themeViewModel.searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(Color(white: 0.5))
                                }
                            }
                        }
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                        
                        // 分类筛选
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                CategoryChip(
                                    title: "全部",
                                    icon: "square.grid.2x2",
                                    isSelected: themeViewModel.selectedCategory == nil
                                ) {
                                    themeViewModel.selectedCategory = nil
                                }
                                
                                ForEach(ThemeCategory.allCases, id: \.self) { category in
                                    CategoryChip(
                                        title: category.rawValue,
                                        icon: category.icon,
                                        isSelected: themeViewModel.selectedCategory == category
                                    ) {
                                        themeViewModel.selectedCategory = category
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    
                    // 主题网格
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            // 添加新主题按钮
                            Button(action: {
                                editingTheme = nil
                                showingThemeEditor = true
                            }) {
                                VStack(spacing: 12) {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(white: 0.95))
                                        .frame(height: 120)
                                        .overlay(
                                            VStack(spacing: 8) {
                                                Image(systemName: "plus.circle.fill")
                                                    .font(.system(size: 32))
                                                    .foregroundColor(Color(white: 0.3))
                                                Text("创建主题")
                                                    .font(.system(size: 14, weight: .medium))
                                                    .foregroundColor(Color(white: 0.4))
                                            }
                                        )
                                    
                                    Text(" ")
                                        .font(.system(size: 14, weight: .medium))
                                        .frame(height: 20)
                                }
                            }
                            
                            // 主题列表
                            ForEach(themeViewModel.filteredThemes) { theme in
                                ThemeGridItemView(theme: theme)
                                    .contextMenu {
                                        Button(action: {
                                            themeViewModel.toggleFavorite(theme)
                                        }) {
                                            Label(
                                                theme.isFavorite ? "取消收藏" : "收藏",
                                                systemImage: theme.isFavorite ? "star.slash" : "star"
                                            )
                                        }
                                        
                                        Button(action: {
                                            applyThemeToCard(theme)
                                        }) {
                                            Label("应用到当前卡片", systemImage: "checkmark.circle")
                                        }
                                        
                                        if theme.isCustom {
                                            Divider()
                                            
                                            Button(action: {
                                                editingTheme = theme
                                                showingThemeEditor = true
                                            }) {
                                                Label("编辑", systemImage: "pencil")
                                            }
                                            
                                            Button(action: {
                                                let _ = themeViewModel.duplicateTheme(theme)
                                            }) {
                                                Label("复制", systemImage: "doc.on.doc")
                                            }
                                            
                                            Button(role: .destructive, action: {
                                                themeToDelete = theme
                                                showingDeleteAlert = true
                                            }) {
                                                Label("删除", systemImage: "trash")
                                            }
                                        } else {
                                            Button(action: {
                                                let _ = themeViewModel.duplicateTheme(theme)
                                            }) {
                                                Label("基于此创建", systemImage: "doc.badge.plus")
                                            }
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("主题管理")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingThemeEditor) {
            ThemeEditorView(theme: editingTheme)
                .environmentObject(themeViewModel)
        }
        .alert("删除主题", isPresented: $showingDeleteAlert) {
            Button("取消", role: .cancel) { }
            Button("删除", role: .destructive) {
                if let theme = themeToDelete {
                    themeViewModel.deleteTheme(theme)
                }
            }
        } message: {
            Text("确定要删除主题 \"\(themeToDelete?.name ?? "")\" 吗？此操作无法撤销。")
        }
    }
    
    private func applyThemeToCard(_ theme: Theme) {
        // 这里可以通过某种方式通知 MainCardView 应用主题
        // 例如通过 NotificationCenter 或共享的 ViewModel
        NotificationCenter.default.post(
            name: Notification.Name("ApplyTheme"),
            object: nil,
            userInfo: ["theme": theme]
        )
    }
}

// MARK: - 分类筛选芯片

struct CategoryChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text(title)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color(white: 0.13) : Color.white)
            .foregroundColor(isSelected ? Color(white: 0.97) : Color(white: 0.3))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
}

#Preview {
    ThemeManagementView()
        .environmentObject(ThemeViewModel())
        .environmentObject(CardViewModel())
}