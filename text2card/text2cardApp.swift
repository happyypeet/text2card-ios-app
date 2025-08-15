//
//  text2cardApp.swift
//  text2card
//
//  Created by happy peet on 5/16/25.
//

import SwiftUI
import MarkdownUI

@main
struct text2cardApp: App {
    // 创建卡片视图模型作为环境对象
    @StateObject private var cardViewModel = CardViewModel()
    
    var body: some Scene {
        WindowGroup {
            // 使用 ContentView 作为主容器，包含 Tab 切换
            ContentView()
                .environmentObject(cardViewModel)
        }
    }
}
