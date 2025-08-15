//
//  ContentView.swift
//  text2card
//
//  Created by happy peet on 5/16/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var cardViewModel: CardViewModel
    @StateObject private var themeViewModel = ThemeViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 设计页面
            MainCardView()
                .environmentObject(themeViewModel)
                .tabItem {
                    Label("设计", systemImage: "paintbrush.fill")
                }
                .tag(0)
            
            // 主题页面
            ThemeManagementView()
                .environmentObject(themeViewModel)
                .environmentObject(cardViewModel)
                .tabItem {
                    Label("主题", systemImage: "paintpalette.fill")
                }
                .tag(1)
        }
        .tint(Color(white: 0.3)) // Claude 风格的深灰色
    }
}

#Preview {
    ContentView()
        .environmentObject(CardViewModel())
}
