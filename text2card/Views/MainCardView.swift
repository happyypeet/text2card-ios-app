//
//  MainCardView.swift
//  text2card
//
//  Created by Trae AI on 5/16/25.
//

import SwiftUI
import MarkdownUI

struct MainCardView: View {
    @EnvironmentObject var cardViewModel: CardViewModel
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @State private var inputText = ""
    @State private var selectedTemplate = CardTemplate.templates[0]
    @State private var showingTemplateSelector = false
    @State private var generatedCard: Card?
    @State private var showingCardDetail = false
    @State private var isMarkdown = false
    @State private var showingSettings = false
    
    // 从 UserDefaults 读取设置
    @AppStorage("defaultTemplate") private var defaultTemplateIndex = 0
    @AppStorage("enableMarkdown") private var enableMarkdown = true
    
    // 主题选择相关
    @State private var selectedTheme: Theme?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Claude 风格极简背景
                Color(white: 0.98)
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // 标题区域 - Claude 极简风格
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("文字转卡片")
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(white: 0.09))
                                
                                Text("将您的文字转换为精美卡片")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color(white: 0.4))
                            }
                            
                            Spacer()
                            
                            // 设置按钮
                            Button(action: {
                                showingSettings = true
                            }) {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color(white: 0.3))
                                    .frame(width: 44, height: 44)
                                    .background(Color(white: 0.95))
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // 输入区域
                        VStack(spacing: 16) {
                            // 模式切换
                            HStack(spacing: 12) {
                                ModeButton(
                                    title: "📝 普通文本",
                                    isSelected: !isMarkdown
                                ) {
                                    isMarkdown = false
                                }
                                
                                ModeButton(
                                    title: "🎨 Markdown",
                                    isSelected: isMarkdown
                                ) {
                                    isMarkdown = true
                                }
                            }
                            
                            // 文本输入框
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(isMarkdown ? "Markdown 内容" : "输入您的文字")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("\(inputText.count)/200")
                                        .font(.system(size: 12))
                                        .foregroundColor(inputText.count > 200 ? .red : .secondary)
                                }
                                
                                TextEditor(text: $inputText)
                                    .frame(minHeight: 120)
                                    .padding(12)
                                    .background(Color(.systemBackground))
                                    .cornerRadius(16)
                                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // 模板选择
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("🎨 选择样式")
                                    .font(.system(size: 18, weight: .semibold))
                                Spacer()
                                Button("更多样式") {
                                    showingTemplateSelector = true
                                }
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.blue)
                            }
                            .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(CardTemplate.templates.prefix(6)) { template in
                                        TemplateCard(
                                            template: template,
                                            isSelected: selectedTemplate.id == template.id
                                        ) {
                                            selectedTemplate = template
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // 卡片预览
                        if !inputText.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("📱 预览效果")
                                    .font(.system(size: 18, weight: .semibold))
                                    .padding(.horizontal, 20)
                                
                                BeautifulCardView(
                                    text: inputText,
                                    template: selectedTemplate,
                                    isMarkdown: isMarkdown
                                )
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // 生成按钮
                        Button(action: generateCard) {
                            HStack(spacing: 8) {
                                Image(systemName: "sparkles")
                                Text("生成精美卡片")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 20)
                        .disabled(inputText.isEmpty || inputText.count > 200)
                        .opacity(inputText.isEmpty || inputText.count > 200 ? 0.6 : 1.0)
                        
                        // 最近生成的卡片
                        if !cardViewModel.cards.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("📚 最近生成")
                                    .font(.system(size: 18, weight: .semibold))
                                    .padding(.horizontal, 20)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(cardViewModel.cards.prefix(5)) { card in
                                            MiniCardView(card: card) {
                                                generatedCard = card
                                                showingCardDetail = true
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                        
                        Spacer(minLength: 50)
                    }
                }
            }
        }
        .sheet(isPresented: $showingTemplateSelector) {
            TemplateSelectionSheet(selectedTemplate: $selectedTemplate)
        }
        .sheet(isPresented: $showingCardDetail) {
            if let card = generatedCard {
                CardDetailSheet(card: card)
            }
        }
        .sheet(isPresented: $showingSettings) {
            ModernSettingsView()
                .environmentObject(cardViewModel)
        }
        .onAppear {
            // 加载默认设置
            if defaultTemplateIndex < CardTemplate.templates.count {
                selectedTemplate = CardTemplate.templates[defaultTemplateIndex]
            }
            isMarkdown = enableMarkdown
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ApplyTheme"))) { notification in
            if let theme = notification.userInfo?["theme"] as? Theme {
                applyTheme(theme)
            }
        }
    }
    
    private func generateCard() {
        let newCard: Card
        
        if let theme = selectedTheme {
            newCard = Card(
                text: inputText,
                backgroundColor: theme.backgroundColor.color,
                textColor: theme.textColor.color,
                font: theme.font,
                fontSize: theme.fontSize,
                isMarkdown: isMarkdown
            )
        } else {
            newCard = Card(
                text: inputText,
                backgroundColor: selectedTemplate.backgroundColor,
                textColor: selectedTemplate.textColor,
                font: selectedTemplate.font,
                fontSize: selectedTemplate.fontSize,
                isMarkdown: isMarkdown
            )
        }
        
        cardViewModel.addCard(newCard)
        generatedCard = newCard
        showingCardDetail = true
        
        // 清空输入
        inputText = ""
    }
    
    private func applyTheme(_ theme: Theme) {
        selectedTheme = theme
        selectedTemplate = theme.toCardTemplate()
    }
}

// MARK: - 子组件

struct ModeButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ? 
                    LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing) :
                    LinearGradient(gradient: Gradient(colors: [Color(.systemGray5)]), startPoint: .leading, endPoint: .trailing)
                )
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(12)
        }
    }
}

struct TemplateCard: View {
    let template: CardTemplate
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(template.backgroundColor)
                    .frame(width: 60, height: 40)
                    .overlay(
                        Text("Aa")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(template.textColor)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                    )
                
                Text(template.name)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct BeautifulCardView: View {
    let text: String
    let template: CardTemplate
    let isMarkdown: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if isMarkdown {
                Markdown(text)
                    .foregroundColor(template.textColor)
            } else {
                Text(text)
                    .font(.system(size: template.fontSize, weight: .medium))
                    .foregroundColor(template.textColor)
                    .lineLimit(nil)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(template.backgroundColor)
                .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
        )
    }
}

struct MiniCardView: View {
    let card: Card
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Text(card.text)
                    .font(.system(size: 12))
                    .foregroundColor(card.textColor)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(12)
            .frame(width: 120, height: 80)
            .background(card.backgroundColor)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Sheet Views

struct TemplateSelectionSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedTemplate: CardTemplate
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                    ForEach(CardTemplate.templates) { template in
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(template.backgroundColor)
                                .frame(height: 80)
                                .overlay(
                                    Text("示例文本")
                                        .font(.system(size: 12))
                                        .foregroundColor(template.textColor)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedTemplate.id == template.id ? Color.blue : Color.clear, lineWidth: 2)
                                )
                            
                            Text(template.name)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.primary)
                        }
                        .onTapGesture {
                            selectedTemplate = template
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("选择模板")
            .navigationBarItems(trailing: Button("完成") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct CardDetailSheet: View {
    @Environment(\.presentationMode) var presentationMode
    let card: Card
    @State private var showingShareSheet = false
    @State private var cardImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 卡片展示
                BeautifulCardView(
                    text: card.text,
                    template: CardTemplate(name: "Custom", backgroundColor: card.backgroundColor, textColor: card.textColor, font: card.font, fontSize: card.fontSize),
                    isMarkdown: card.isMarkdown
                )
                .padding()
                
                // 操作按钮
                HStack(spacing: 20) {
                    Button(action: {
                        generateCardImage()
                        showingShareSheet = true
                    }) {
                        VStack {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 24))
                            Text("分享")
                                .font(.caption)
                        }
                        .foregroundColor(.blue)
                    }
                    
                    Button(action: {
                        generateCardImage()
                        if let image = cardImage {
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        }
                    }) {
                        VStack {
                            Image(systemName: "square.and.arrow.down")
                                .font(.system(size: 24))
                            Text("保存")
                                .font(.caption)
                        }
                        .foregroundColor(Color(white: 0.3))
                    }
                }
                
                Spacer()
            }
            .navigationTitle("卡片详情")
            .navigationBarItems(trailing: Button("完成") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .sheet(isPresented: $showingShareSheet) {
            if let image = cardImage {
                ShareSheet(items: [image])
            }
        }
    }
    
    private func generateCardImage() {
        let renderer = ImageRenderer(content: 
            BeautifulCardView(
                text: card.text,
                template: CardTemplate(name: "Custom", backgroundColor: card.backgroundColor, textColor: card.textColor, font: card.font, fontSize: card.fontSize),
                isMarkdown: card.isMarkdown
            )
            .padding()
        )
        cardImage = renderer.uiImage
    }
}

// 分享表单
struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}

#Preview {
    MainCardView()
        .environmentObject(CardViewModel())
        .environmentObject(ThemeViewModel())
}