//
//  HomeView.swift
//  text2card
//
//  Created by Trae AI on 5/16/25.
//

import SwiftUI

struct HomeView: View {
    @State private var cards: [Card] = []
    @State private var showingCreateSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 主内容区域
                ScrollView {
                    VStack(spacing: 20) {
                        // 文字卡片标题区域
                        HStack {
                            Text("文字转卡片")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        // 卡片预览区域
                        if !cards.isEmpty {
                            ForEach(cards) { card in
                                CardPreviewView(card: card)
                                    .padding(.horizontal)
                            }
                        } else {
                            // 空状态
                            VStack(spacing: 20) {
                                Image(systemName: "doc.text")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                                Text("暂无卡片")
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                        
                        // 创建卡片按钮
                        Button(action: {
                            showingCreateSheet = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("创建卡片")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        
                        // 推荐模板区域
                        VStack(alignment: .leading, spacing: 10) {
                            Text("推荐模板")
                                .font(.headline)
                            
                            HStack(spacing: 15) {
                                ForEach(0..<2) { index in
                                    let template = CardTemplate.templates[index]
                                    TemplatePreviewView(template: template)
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
                CreateCardView()
            }
        }
        .onAppear {
            // 加载保存的卡片
            loadCards()
        }
    }
    
    // 加载保存的卡片
    private func loadCards() {
        // 这里将来会从UserDefaults或其他存储加载卡片
        // 现在先添加一些示例卡片
        cards = [
            Card(text: "新闻文案\n这是一个关于产品推广的新闻文案，包括产品的特点和优势。", backgroundColor: .blue, textColor: .white, name: "产品A"),
            Card(text: "活动宣传通知\n我们将在本周六举办产品发布会，欢迎参加！", backgroundColor: .pink, textColor: .white, name: "活动部")
        ]
    }
}

// 卡片预览组件
struct CardPreviewView: View {
    let card: Card
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(card.text)
                .font(.system(size: card.fontSize))
                .foregroundColor(card.textColor)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(card.backgroundColor)
                .cornerRadius(12)
            
            if let name = card.name {
                HStack {
                    Text(name)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(formatDate(card.createdAt))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

// 模板预览组件
struct TemplatePreviewView: View {
    let template: CardTemplate
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("示例文本")
                .font(.system(size: template.fontSize))
                .foregroundColor(template.textColor)
                .padding(8)
        }
        .frame(width: 100, height: 80)
        .background(template.backgroundColor)
        .cornerRadius(8)
    }
}

// 自定义底部标签栏
struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(imageName: "house.fill", title: "首页", isSelected: selectedTab == 0) {
                selectedTab = 0
            }
            
            TabBarButton(imageName: "doc.text.fill", title: "卡片", isSelected: selectedTab == 1) {
                selectedTab = 1
            }
            
            TabBarButton(imageName: "square.grid.2x2.fill", title: "模板", isSelected: selectedTab == 2) {
                selectedTab = 2
            }
            
            TabBarButton(imageName: "person.fill", title: "我的", isSelected: selectedTab == 3) {
                selectedTab = 3
            }
        }
        .background(Color(.systemBackground))
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(.systemGray4)),
            alignment: .top
        )
    }
}

// 标签栏按钮
struct TabBarButton: View {
    let imageName: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: imageName)
                    .font(.system(size: 22))
                Text(title)
                    .font(.system(size: 10))
            }
            .foregroundColor(isSelected ? .blue : .gray)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    HomeView()
}