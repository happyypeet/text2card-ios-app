//
//  TemplateLibraryView.swift
//  text2card
//
//  Created by Trae AI on 5/16/25.
//

import SwiftUI

struct TemplateLibraryView: View {
    @EnvironmentObject var cardViewModel: CardViewModel
    @State private var selectedTab = 2
    @State private var showingCreateSheet = false
    @State private var selectedTemplate: CardTemplate? = nil
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 主内容区域
                ScrollView {
                    VStack(spacing: 20) {
                        // 模板库标题
                        HStack {
                            Text("模板库")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        // 模板分类
                        HStack {
                            CategoryButton(title: "全部", isSelected: true)
                            CategoryButton(title: "简约", isSelected: false)
                            CategoryButton(title: "商务", isSelected: false)
                            CategoryButton(title: "创意", isSelected: false)
                        }
                        .padding(.horizontal)
                        
                        // 模板网格
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 15) {
                            ForEach(CardTemplate.templates) { template in
                                TemplateGridItemView(template: template)
                                    .onTapGesture {
                                        selectedTemplate = template
                                        showingCreateSheet = true
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                
                // 移除自定义底部标签栏，使用主应用的TabView
            }
            .navigationBarTitle("", displayMode: .inline)
            .sheet(isPresented: $showingCreateSheet) {
                if let template = selectedTemplate {
                    CreateCardWithTemplateView(template: template)
                }
            }
        }
    }
}

// 分类按钮
struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.subheadline)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(isSelected ? Color.blue : Color(.systemGray6))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(16)
    }
}

// 模板网格项
struct TemplateGridItemView: View {
    let template: CardTemplate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 模板预览
            VStack(alignment: .leading, spacing: 4) {
                Text("示例文本")
                    .font(.system(size: template.fontSize))
                    .foregroundColor(template.textColor)
                    .padding(8)
                Spacer()
                Text(template.name)
                    .font(.caption)
                    .foregroundColor(template.textColor.opacity(0.8))
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
            }
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .background(template.backgroundColor)
            .cornerRadius(8)
        }
    }
}

// 使用模板创建卡片视图
struct CreateCardWithTemplateView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var cardViewModel: CardViewModel
    let template: CardTemplate
    @State private var cardText = ""
    @State private var name = ""
    @State private var qrCodeData = ""
    @State private var showQROptions = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 模板预览
                VStack(alignment: .leading, spacing: 8) {
                    Text(cardText.isEmpty ? "在这里输入您的文本..." : cardText)
                        .font(.system(size: template.fontSize))
                        .foregroundColor(template.textColor)
                        .padding()
                        .frame(height: 200)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(template.backgroundColor)
                        .cornerRadius(12)
                }
                .padding()
                
                // 文本输入区域
                TextEditor(text: $cardText)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .frame(height: 150)
                
                // 个性化选项
                VStack(alignment: .leading, spacing: 8) {
                    Text("个性化设置")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Toggle("显示姓名", isOn: .constant(!name.isEmpty))
                        .padding(.horizontal)
                        .onChange(of: name.isEmpty) { _, isEmpty in
                            if isEmpty {
                                name = ""
                            } else if name.isEmpty {
                                name = "默认姓名"
                            }
                        }
                    
                    if !name.isEmpty {
                        TextField("输入姓名", text: $name)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                    
                    Toggle("添加二维码", isOn: $showQROptions)
                        .padding(.horizontal)
                    
                    if showQROptions {
                        TextField("输入二维码内容", text: $qrCodeData)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                
                // 底部按钮
                Button(action: {
                    saveCard()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text("创建卡片")
                        Image(systemName: "checkmark")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom)
                .disabled(cardText.isEmpty)
            }
            .navigationBarTitle("使用模板", displayMode: .inline)
            .navigationBarItems(
                leading: Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    // 保存卡片
    private func saveCard() {
        let newCard = Card(
            text: cardText,
            backgroundColor: template.backgroundColor,
            textColor: template.textColor,
            font: template.font,
            fontSize: template.fontSize,
            name: name.isEmpty ? nil : name,
            qrCodeData: qrCodeData.isEmpty ? nil : qrCodeData,
            isMarkdown: false
        )
        
        cardViewModel.addCard(newCard)
    }
}

#Preview {
    TemplateLibraryView()
        .environmentObject(CardViewModel())
}