//
//  ThemeEditorView.swift
//  text2card
//
//  Created by Claude on 5/16/25.
//

import SwiftUI

struct ThemeEditorView: View {
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var themeName = ""
    @State private var backgroundColor = Color.white
    @State private var textColor = Color.black
    @State private var selectedFont = "System"
    @State private var fontSize: CGFloat = 16
    @State private var selectedCategory = ThemeCategory.custom
    @State private var isGradient = false
    @State private var gradientColors: [Color] = [.blue, .purple]
    @State private var showingColorPicker = false
    @State private var editingColorType: ColorEditType = .background
    
    let theme: Theme?
    
    enum ColorEditType {
        case background, text, gradient(Int)
    }
    
    let availableFonts = [
        "System",
        "Arial",
        "Helvetica",
        "Times New Roman",
        "Georgia",
        "Courier New",
        "Verdana",
        "American Typewriter",
        "Avenir",
        "Baskerville",
        "Copperplate",
        "Didot",
        "Futura",
        "Gill Sans",
        "Optima",
        "Palatino",
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 预览卡片
                    VStack(alignment: .leading, spacing: 12) {
                        Text("预览")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(white: 0.13))
                        
                        PreviewCard(
                            text: themeViewModel.getPreviewText(),
                            backgroundColor: isGradient ? nil : backgroundColor,
                            gradientColors: isGradient ? gradientColors : nil,
                            textColor: textColor,
                            font: selectedFont,
                            fontSize: fontSize
                        )
                    }
                    
                    // 基本信息
                    VStack(alignment: .leading, spacing: 16) {
                        Text("基本信息")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(white: 0.13))
                        
                        VStack(spacing: 12) {
                            // 主题名称
                            HStack {
                                Text("名称")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color(white: 0.3))
                                    .frame(width: 80, alignment: .leading)
                                
                                TextField("输入主题名称", text: $themeName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            // 主题类型
                            HStack {
                                Text("类型")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color(white: 0.3))
                                    .frame(width: 80, alignment: .leading)
                                
                                Toggle("渐变背景", isOn: $isGradient)
                                    .tint(Color(white: 0.3))
                            }
                        }
                    }
                    
                    // 颜色设置
                    VStack(alignment: .leading, spacing: 16) {
                        Text("颜色设置")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(white: 0.13))
                        
                        VStack(spacing: 12) {
                            if isGradient {
                                // 渐变颜色
                                ForEach(0..<gradientColors.count, id: \.self) { index in
                                    ColorRow(
                                        title: "颜色 \(index + 1)",
                                        color: $gradientColors[index]
                                    )
                                }
                                
                                // 添加/删除颜色按钮
                                HStack {
                                    Button(action: {
                                        gradientColors.append(.blue)
                                    }) {
                                        Label("添加颜色", systemImage: "plus.circle")
                                            .font(.system(size: 14, weight: .medium))
                                    }
                                    
                                    Spacer()
                                    
                                    if gradientColors.count > 2 {
                                        Button(action: {
                                            gradientColors.removeLast()
                                        }) {
                                            Label("删除颜色", systemImage: "minus.circle")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                            } else {
                                // 背景色
                                ColorRow(title: "背景色", color: $backgroundColor)
                            }
                            
                            // 文字颜色
                            ColorRow(title: "文字色", color: $textColor)
                        }
                    }
                    
                    // 字体设置
                    VStack(alignment: .leading, spacing: 16) {
                        Text("字体设置")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(white: 0.13))
                        
                        VStack(spacing: 12) {
                            // 字体选择
                            HStack {
                                Text("字体")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color(white: 0.3))
                                    .frame(width: 80, alignment: .leading)
                                
                                Picker("字体", selection: $selectedFont) {
                                    ForEach(availableFonts, id: \.self) { font in
                                        Text(font).tag(font)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .tint(Color(white: 0.3))
                            }
                            
                            // 字体大小
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("大小")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(Color(white: 0.3))
                                        .frame(width: 80, alignment: .leading)
                                    
                                    Text("\(Int(fontSize))pt")
                                        .font(.system(size: 15))
                                        .foregroundColor(Color(white: 0.5))
                                    
                                    Spacer()
                                }
                                
                                Slider(value: $fontSize, in: 12...32, step: 1)
                                    .tint(Color(white: 0.3))
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color(white: 0.98))
            .navigationTitle(theme == nil ? "创建主题" : "编辑主题")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                    .foregroundColor(Color(white: 0.3))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        saveTheme()
                    }
                    .foregroundColor(Color(white: 0.3))
                    .disabled(themeName.isEmpty)
                }
            }
        }
        .onAppear {
            if let theme = theme {
                loadTheme(theme)
            }
        }
    }
    
    private func loadTheme(_ theme: Theme) {
        themeName = theme.name
        backgroundColor = theme.backgroundColor.color
        textColor = theme.textColor.color
        selectedFont = theme.font
        fontSize = theme.fontSize
        selectedCategory = theme.category
        
        if let gradColors = theme.gradientColors {
            isGradient = true
            gradientColors = gradColors.map { $0.color }
        }
    }
    
    private func saveTheme() {
        let newTheme: Theme
        
        if isGradient {
            newTheme = Theme(
                name: themeName,
                gradientColors: gradientColors,
                textColor: textColor,
                font: selectedFont,
                fontSize: fontSize,
                category: .custom,
                isCustom: true
            )
        } else {
            newTheme = Theme(
                name: themeName,
                backgroundColor: backgroundColor,
                textColor: textColor,
                font: selectedFont,
                fontSize: fontSize,
                category: .custom,
                isCustom: true
            )
        }
        
        if let existingTheme = theme {
            var updatedTheme = newTheme
            updatedTheme.id = existingTheme.id
            updatedTheme.createdDate = existingTheme.createdDate
            updatedTheme.isFavorite = existingTheme.isFavorite
            themeViewModel.updateTheme(updatedTheme)
        } else {
            themeViewModel.addTheme(newTheme)
        }
        
        dismiss()
    }
}

// MARK: - 子组件

struct ColorRow: View {
    let title: String
    @Binding var color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color(white: 0.3))
                .frame(width: 80, alignment: .leading)
            
            ColorPicker("", selection: $color)
                .labelsHidden()
            
            Spacer()
        }
    }
}

struct PreviewCard: View {
    let text: String
    let backgroundColor: Color?
    let gradientColors: [Color]?
    let textColor: Color
    let font: String
    let fontSize: CGFloat
    
    var backgroundView: some View {
        Group {
            if let gradientColors = gradientColors, !gradientColors.isEmpty {
                LinearGradient(
                    gradient: Gradient(colors: gradientColors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                backgroundColor ?? Color.white
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(text)
                .font(.custom(font == "System" ? ".SF Pro Text" : font, size: fontSize))
                .foregroundColor(textColor)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            backgroundView
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    ThemeEditorView(theme: nil)
        .environmentObject(ThemeViewModel())
}