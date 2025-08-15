//
//  CardViewModel.swift
//  text2card
//
//  Created by Trae AI on 5/16/25.
//

import SwiftUI
import Combine

class CardViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var favoriteCards: [UUID] = []
    @Published var sharedCards: [UUID] = []
    @Published var deletedCards: [UUID] = []
    
    private let cardsKey = "savedCards"
    private let favoritesKey = "favoriteCards"
    private let sharedKey = "sharedCards"
    private let deletedKey = "deletedCards"
    
    init() {
        loadCards()
    }
    
    // 加载保存的卡片
    func loadCards() {
        // 从UserDefaults加载卡片数据
        if let data = UserDefaults.standard.data(forKey: cardsKey) {
            do {
                cards = try JSONDecoder().decode([Card].self, from: data)
            } catch {
                print("加载卡片失败: \(error)")
                // 如果加载失败，添加一些示例卡片
                addSampleCards()
            }
        } else {
            // 如果没有保存的卡片，添加一些示例卡片
            addSampleCards()
        }
        
        // 加载收藏、分享和删除的卡片ID
        if let data = UserDefaults.standard.data(forKey: favoritesKey) {
            do {
                favoriteCards = try JSONDecoder().decode([UUID].self, from: data)
            } catch {
                print("加载收藏卡片失败: \(error)")
            }
        }
        
        if let data = UserDefaults.standard.data(forKey: sharedKey) {
            do {
                sharedCards = try JSONDecoder().decode([UUID].self, from: data)
            } catch {
                print("加载分享卡片失败: \(error)")
            }
        }
        
        if let data = UserDefaults.standard.data(forKey: deletedKey) {
            do {
                deletedCards = try JSONDecoder().decode([UUID].self, from: data)
            } catch {
                print("加载删除卡片失败: \(error)")
            }
        }
    }
    
    // 保存卡片
    func saveCards() {
        do {
            let data = try JSONEncoder().encode(cards)
            UserDefaults.standard.set(data, forKey: cardsKey)
            
            // 保存收藏、分享和删除的卡片ID
            let favoritesData = try JSONEncoder().encode(favoriteCards)
            UserDefaults.standard.set(favoritesData, forKey: favoritesKey)
            
            let sharedData = try JSONEncoder().encode(sharedCards)
            UserDefaults.standard.set(sharedData, forKey: sharedKey)
            
            let deletedData = try JSONEncoder().encode(deletedCards)
            UserDefaults.standard.set(deletedData, forKey: deletedKey)
        } catch {
            print("保存卡片失败: \(error)")
        }
    }
    
    // 添加新卡片
    func addCard(_ card: Card) {
        cards.append(card)
        saveCards()
    }
    
    // 更新卡片
    func updateCard(_ card: Card) {
        if let index = cards.firstIndex(where: { $0.id == card.id }) {
            cards[index] = card
            saveCards()
        }
    }
    
    // 删除卡片
    func deleteCard(_ card: Card) {
        deletedCards.append(card.id)
        saveCards()
    }
    
    // 收藏卡片
    func toggleFavorite(_ card: Card) {
        if favoriteCards.contains(card.id) {
            favoriteCards.removeAll { $0 == card.id }
        } else {
            favoriteCards.append(card.id)
        }
        saveCards()
    }
    
    // 标记卡片为已分享
    func markAsShared(_ card: Card) {
        if !sharedCards.contains(card.id) {
            sharedCards.append(card.id)
            saveCards()
        }
    }
    
    // 获取卡片列表（根据类型筛选）
    func getCards(type: CardListType) -> [Card] {
        switch type {
        case .all:
            return cards.filter { !deletedCards.contains($0.id) }
        case .favorites:
            return cards.filter { favoriteCards.contains($0.id) && !deletedCards.contains($0.id) }
        case .shared:
            return cards.filter { sharedCards.contains($0.id) && !deletedCards.contains($0.id) }
        case .deleted:
            return cards.filter { deletedCards.contains($0.id) }
        }
    }
    
    // 添加示例卡片
    private func addSampleCards() {
        cards = [
            Card(text: "新闻文案\n这是一个关于产品推广的新闻文案，包括产品的特点和优势。", backgroundColor: .blue, textColor: .white, name: "产品A"),
            Card(text: "活动宣传通知\n我们将在本周六举办产品发布会，欢迎参加！", backgroundColor: .pink, textColor: .white, name: "活动部"),
            Card(text: "会议记录\n今天的会议讨论了项目进度和下一步计划。", backgroundColor: .green, textColor: .black, name: "项目组"),
            Card(text: "产品说明\n这是一款创新的产品，具有多种功能和特性。", backgroundColor: .orange, textColor: .white, name: "产品B")
        ]
    }
}

// 卡片列表类型
enum CardListType {
    case all
    case favorites
    case shared
    case deleted
}