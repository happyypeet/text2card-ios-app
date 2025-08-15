//
//  ClaudeTheme.swift
//  text2card
//
//  Created by Claude on 5/16/25.
//

import SwiftUI

// Claude 主题颜色定义
extension Color {
    struct Claude {
        // 亮色主题
        static let background = Color(white: 0.98)
        static let surface = Color.white
        static let text = Color(white: 0.09)
        static let textSecondary = Color(white: 0.4)
        static let accent = Color(white: 0.95)
        static let primary = Color(white: 0.13)
        static let primaryForeground = Color(white: 0.97)
        static let border = Color(white: 0.9)
        
        // 暗色主题
        struct Dark {
            static let background = Color(white: 0.09)
            static let surface = Color(white: 0.13)
            static let text = Color(white: 0.97)
            static let textSecondary = Color(white: 0.6)
            static let accent = Color(white: 0.2)
            static let primary = Color(white: 0.8)
            static let primaryForeground = Color(white: 0.13)
            static let border = Color(white: 0.2)
        }
    }
}

// Claude 主题样式常量
struct ClaudeStyle {
    static let cornerRadius: CGFloat = 10 // 0.625rem ≈ 10pt
    static let shadowRadius: CGFloat = 4
    static let shadowOpacity: Double = 0.1
    static let shadowY: CGFloat = 2
    static let borderWidth: CGFloat = 1
}