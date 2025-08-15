//
//  CreateCardView.swift
//  text2card
//
//  Created by Trae AI on 5/16/25.
//

import SwiftUI
import MarkdownUI

struct CreateCardView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var cardText = ""
    @State private var selectedTemplate = CardTemplate.templates[0]
    @State private var isMarkdown = false
    @State private var showingTemplateSheet = false
    @State private var name = ""
    @State private var qrCodeData = ""
    @State private var showQROptions = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 顶部切换栏
                HStack(spacing: 4) {
                    Button(action: {
                        isMarkdown = false
                    }) {
                        Text("文本输入")
                            .font(.system(size: 16, weight: .medium))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .background(isMarkdown ? Color(.systemGray5) : Color.blue)
                            .foregroundColor(isMarkdown ? .primary : .white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        isMarkdown = true
                    }) {
                        Text("Markdown")
                            .font(.system(size: 16, weight: .medium))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .background(isMarkdown ? Color.blue : Color(.systemGray5))
                            .foregroundColor(isMarkdown ? .white : .primary)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                
                // 输入提示
                HStack {
                    Text("输入内容（不超过200字）")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // 文本输入区域
                if isMarkdown {
                    VStack {
                        TextEditor(text: $cardText)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        // Markdown预览
                        if !cardText.isEmpty {
                            Divider()
                            Text("预览：")
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            ScrollView {
                                Markdown(cardText)
                                    .padding()
                                    .background(selectedTemplate.backgroundColor)
                                    .foregroundColor(selectedTemplate.textColor)
                                    .cornerRadius(8)
                                    .padding(.horizontal)
                            }
                        }
                    }
                } else {
                    TextEditor(text: $cardText)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
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
                        Text("下一步：确认卡片")
                        Image(systemName: "arrow.right")
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
            .navigationBarTitle("创建卡片", displayMode: .inline)
            .navigationBarItems(
                leading: Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button(action: {
                    showingTemplateSheet = true
                }) {
                    Image(systemName: "paintbrush")
                }
            )
            .sheet(isPresented: $showingTemplateSheet) {
                TemplateSelectionView(selectedTemplate: $selectedTemplate)
            }
        }
    }
    
    // 保存卡片
    private func saveCard() {
        let newCard = Card(
            text: cardText,
            backgroundColor: selectedTemplate.backgroundColor,
            textColor: selectedTemplate.textColor,
            font: selectedTemplate.font,
            fontSize: selectedTemplate.fontSize,
            name: name.isEmpty ? nil : name,
            qrCodeData: qrCodeData.isEmpty ? nil : qrCodeData,
            isMarkdown: isMarkdown
        )
        
        // 这里将来会保存卡片到UserDefaults或其他存储
        print("保存卡片: \(newCard)")
    }
}

// 模板选择视图
struct TemplateSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedTemplate: CardTemplate
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 颜色选择网格
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 15) {
                        ForEach(CardTemplate.templates) { template in
                            Circle()
                                .fill(template.backgroundColor)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                        .opacity(selectedTemplate.id == template.id ? 1 : 0)
                                )
                                .shadow(color: Color.black.opacity(0.1), radius: 2)
                                .onTapGesture {
                                    selectedTemplate = template
                                }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitle("选择模板", displayMode: .inline)
            .navigationBarItems(trailing: Button("完成") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// 卡片详情和分享视图
struct CardDetailView: View {
    let card: Card
    @State private var showingShareSheet = false
    @State private var cardImage: UIImage? = nil
    
    var body: some View {
        VStack {
            // 卡片预览
            CardView(card: card)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding()
            
            // 分享按钮
            HStack(spacing: 20) {
                Button(action: {
                    // 生成卡片图像
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
                    // 生成卡片图像并保存到相册
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
                    .foregroundColor(.green)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingShareSheet) {
            if let image = cardImage {
                ShareSheet(items: [image])
            }
        }
    }
    
    // 生成卡片图像
    private func generateCardImage() {
        let renderer = ImageRenderer(content: CardView(card: card).padding())
        cardImage = renderer.uiImage
    }
}

// 卡片视图
struct CardView: View {
    let card: Card
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if card.isMarkdown {
                Markdown(card.text)
                    .foregroundColor(card.textColor)
            } else {
                Text(card.text)
                    .font(.system(size: card.fontSize))
                    .foregroundColor(card.textColor)
            }
            
            if let name = card.name {
                Divider()
                Text(name)
                    .font(.caption)
                    .foregroundColor(card.textColor.opacity(0.8))
            }
            
            if let qrData = card.qrCodeData, let qrImage = generateQRCode(from: qrData) {
                HStack {
                    Spacer()
                    Image(uiImage: qrImage)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(card.backgroundColor)
        .cornerRadius(12)
    }
    
    // 生成二维码
    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: .utf8)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("H", forKey: "inputCorrectionLevel")
            if let outputImage = filter.outputImage {
                let transform = CGAffineTransform(scaleX: 10, y: 10)
                let scaledImage = outputImage.transformed(by: transform)
                let context = CIContext()
                if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        return nil
    }
}



#Preview {
    CreateCardView()
}