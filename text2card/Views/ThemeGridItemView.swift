//
//  ThemeGridItemView.swift
//  text2card
//
//  Created by Claude on 5/16/25.
//

import SwiftUI

struct ThemeGridItemView: View {
    let theme: Theme
    @EnvironmentObject var themeViewModel: ThemeViewModel
    
    var backgroundView: some View {
        Group {
            if let gradientColors = theme.gradientColors, !gradientColors.isEmpty {
                LinearGradient(
                    gradient: Gradient(colors: gradientColors.map { $0.color }),
                    startPoint: theme.gradientStartPoint?.unitPoint ?? .topLeading,
                    endPoint: theme.gradientEndPoint?.unitPoint ?? .bottomTrailing
                )
            } else {
                theme.backgroundColor.color
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // 主题预览
            ZStack {
                backgroundView
                    .cornerRadius(12)
                    .frame(height: 120)
            }
            .overlay(
                VStack(spacing: 6) {
                        // 收藏标记
                        if theme.isFavorite {
                            HStack {
                                Spacer()
                                Image(systemName: "star.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.yellow)
                                    .padding(8)
                            }
                            Spacer()
                        }
                        
                        // 预览文字
                        Text("Aa")
                            .font(.custom(
                                theme.font == "System" ? ".SF Pro Text" : theme.font,
                                size: min(theme.fontSize * 1.5, 32)
                            ))
                            .foregroundColor(theme.textColor.color)
                        
                        Text("示例文字")
                            .font(.custom(
                                theme.font == "System" ? ".SF Pro Text" : theme.font,
                                size: theme.fontSize
                            ))
                            .foregroundColor(theme.textColor.color.opacity(0.8))
                    }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(white: 0.9), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            
            // 主题信息
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(theme.name)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(white: 0.13))
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if theme.isCustom {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color(white: 0.5))
                    }
                }
                
                HStack(spacing: 4) {
                    Image(systemName: theme.category.icon)
                        .font(.system(size: 10))
                    Text(theme.category.rawValue)
                        .font(.system(size: 11))
                }
                .foregroundColor(Color(white: 0.5))
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            // 可以在这里添加点击预览的功能
            themeViewModel.selectedTheme = theme
            
            // 发送通知给 MainCardView
            NotificationCenter.default.post(
                name: Notification.Name("ApplyTheme"),
                object: nil,
                userInfo: ["theme": theme]
            )
        }
    }
}

#Preview {
    ThemeGridItemView(
        theme: Theme(
            name: "示例主题",
            backgroundColor: .blue,
            textColor: .white,
            category: .custom
        )
    )
    .environmentObject(ThemeViewModel())
    .frame(width: 180)
    .padding()
}