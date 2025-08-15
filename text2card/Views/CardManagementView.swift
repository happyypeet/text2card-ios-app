//
//  CardManagementView.swift
//  text2card
//
//  Created by Trae AI on 5/16/25.
//

import SwiftUI

struct CardManagementView: View {
    @State private var cards: [Card] = []
    @State private var selectedTab = 0
    @State private var searchText = ""
    @State private var showingCreateSheet = false
    @State private var selectedCard: Card? = nil
    
    var filteredCards: [Card] {
        if searchText.isEmpty {
            return cards
        } else {
            return cards.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 顶部标签切换
                HStack(spacing: 4) {
                    Button(action: { selectedTab = 0 }) {
                        Text("全部")
                            .font(.system(size: 16, weight: .medium))
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(selectedTab == 0 ? Color.blue : Color(.systemGray5))
                            .foregroundColor(selectedTab == 0 ? .white : .primary)
                            .cornerRadius(8)
                    }
                    
                    Button(action: { selectedTab = 1 }) {
                        Text("收藏")
                            .font(.system(size: 16, weight: .medium))
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(selectedTab == 1 ? Color.blue : Color(.systemGray5))
                            .foregroundColor(selectedTab == 1 ? .white : .primary)
                            .cornerRadius(8)
                    }
                    
                    Button(action: { selectedTab = 2 }) {
                        Text("已分享")
                            .font(.system(size: 16, weight: .medium))
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(selectedTab == 2 ? Color.blue : Color(.systemGray5))
                            .foregroundColor(selectedTab == 2 ? .white : .primary)
                            .cornerRadius(8)
                    }
                    
                    Button(action: { selectedTab = 3 }) {
                        Text("已删除")
                            .font(.system(size: 16, weight: .medium))
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(selectedTab == 3 ? Color.blue : Color(.systemGray5))
                            .foregroundColor(selectedTab == 3 ? .white : .primary)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                
                // 搜索栏
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("搜索卡片", text: $searchText)
                }
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding()
                
                // 卡片列表
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 15) {
                        ForEach(filteredCards) { card in
                            CardGridItemView(card: card)
                                .onTapGesture {
                                    selectedCard = card
                                }
                        }
                    }
                    .padding()
                }
                
                // 移除自定义底部标签栏，使用主应用的TabView
            }
            .navigationBarTitle("我的卡片", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                showingCreateSheet = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingCreateSheet) {
                CreateCardView()
            }
            .sheet(item: $selectedCard) { card in
                CardDetailView(card: card)
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
            Card(text: "活动宣传通知\n我们将在本周六举办产品发布会，欢迎参加！", backgroundColor: .pink, textColor: .white, name: "活动部"),
            Card(text: "会议记录\n今天的会议讨论了项目进度和下一步计划。", backgroundColor: .green, textColor: .black, name: "项目组"),
            Card(text: "产品说明\n这是一款创新的产品，具有多种功能和特性。", backgroundColor: .orange, textColor: .white, name: "产品B")
        ]
    }
}

// 网格中的卡片项视图
struct CardGridItemView: View {
    let card: Card
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 卡片内容预览
            Text(card.text.prefix(50) + (card.text.count > 50 ? "..." : ""))
                .font(.system(size: 14))
                .foregroundColor(card.textColor)
                .lineLimit(5)
                .padding(10)
                .frame(height: 120, alignment: .topLeading)
                .frame(maxWidth: .infinity)
                .background(card.backgroundColor)
                .cornerRadius(8)
            
            // 卡片信息
            if let name = card.name {
                Text(name)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    CardManagementView()
}