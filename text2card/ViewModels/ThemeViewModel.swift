//
//  ThemeViewModel.swift
//  text2card
//
//  Created by Claude on 5/16/25.
//

import SwiftUI
import Combine

class ThemeViewModel: ObservableObject {
    @Published var themes: [Theme] = []
    @Published var selectedCategory: ThemeCategory? = nil
    @Published var searchText = ""
    @Published var selectedTheme: Theme?
    
    private let userDefaultsKey = "SavedThemes"
    
    init() {
        loadThemes()
    }
    
    // 筛选后的主题
    var filteredThemes: [Theme] {
        var result = themes
        
        // 按分类筛选
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        // 按搜索文本筛选
        if !searchText.isEmpty {
            result = result.filter { 
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // 按收藏和创建时间排序
        result.sort { first, second in
            if first.isFavorite != second.isFavorite {
                return first.isFavorite
            }
            return first.createdDate > second.createdDate
        }
        
        return result
    }
    
    // 收藏的主题
    var favoriteThemes: [Theme] {
        themes.filter { $0.isFavorite }
    }
    
    // 自定义主题
    var customThemes: [Theme] {
        themes.filter { $0.isCustom }
    }
    
    // MARK: - 主题管理
    
    func addTheme(_ theme: Theme) {
        themes.append(theme)
        saveThemes()
    }
    
    func updateTheme(_ theme: Theme) {
        if let index = themes.firstIndex(where: { $0.id == theme.id }) {
            themes[index] = theme
            saveThemes()
        }
    }
    
    func deleteTheme(_ theme: Theme) {
        guard theme.isCustom else { return } // 只能删除自定义主题
        themes.removeAll { $0.id == theme.id }
        saveThemes()
    }
    
    func toggleFavorite(_ theme: Theme) {
        if let index = themes.firstIndex(where: { $0.id == theme.id }) {
            themes[index].isFavorite.toggle()
            saveThemes()
        }
    }
    
    func duplicateTheme(_ theme: Theme) -> Theme {
        var newTheme = theme
        newTheme.id = UUID()
        newTheme.name = "\(theme.name) 副本"
        newTheme.isCustom = true
        newTheme.createdDate = Date()
        addTheme(newTheme)
        return newTheme
    }
    
    // MARK: - 持久化
    
    private func loadThemes() {
        // 加载默认主题
        themes = Theme.defaultThemes
        
        // 加载自定义主题
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let customThemes = try? JSONDecoder().decode([Theme].self, from: data) {
            themes.append(contentsOf: customThemes)
        }
    }
    
    private func saveThemes() {
        // 只保存自定义主题和收藏状态
        let customThemes = themes.filter { $0.isCustom }
        if let data = try? JSONEncoder().encode(customThemes) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
        
        // 保存默认主题的收藏状态
        saveFavoriteStates()
    }
    
    private func saveFavoriteStates() {
        let favoriteIds = themes.filter { !$0.isCustom && $0.isFavorite }.map { $0.id.uuidString }
        UserDefaults.standard.set(favoriteIds, forKey: "FavoriteThemeIds")
    }
    
    private func loadFavoriteStates() {
        guard let favoriteIds = UserDefaults.standard.stringArray(forKey: "FavoriteThemeIds") else { return }
        for id in favoriteIds {
            if let uuid = UUID(uuidString: id),
               let index = themes.firstIndex(where: { $0.id == uuid }) {
                themes[index].isFavorite = true
            }
        }
    }
    
    // MARK: - 主题应用
    
    func applyTheme(_ theme: Theme, to card: inout Card) {
        card.backgroundColor = theme.backgroundColor.color
        card.textColor = theme.textColor.color
        card.font = theme.font
        card.fontSize = theme.fontSize
    }
    
    // 获取主题预览文本
    func getPreviewText() -> String {
        """
        生活如诗，岁月如歌
        每一天都是新的开始
        让我们用心感受美好
        """
    }
}