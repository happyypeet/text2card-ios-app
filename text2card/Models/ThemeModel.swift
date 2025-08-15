//
//  ThemeModel.swift
//  text2card
//
//  Created by Claude on 5/16/25.
//

import SwiftUI

// 主题分类
enum ThemeCategory: String, CaseIterable, Codable {
    case claude = "Claude"
    case classic = "经典"
    case gradient = "渐变"
    case custom = "自定义"
    
    var icon: String {
        switch self {
        case .claude: return "c.circle.fill"
        case .classic: return "paintpalette.fill"
        case .gradient: return "rectangle.righthalf.filled"
        case .custom: return "plus.circle.fill"
        }
    }
}

// 扩展的主题模型
struct Theme: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var backgroundColor: CodableColor
    var textColor: CodableColor
    var accentColor: CodableColor?
    var font: String
    var fontSize: CGFloat
    var category: ThemeCategory
    var isCustom: Bool
    var isFavorite: Bool
    var createdDate: Date
    var gradientColors: [CodableColor]? // 渐变主题使用
    var gradientStartPoint: CodableUnitPoint?
    var gradientEndPoint: CodableUnitPoint?
    
    // 便利初始化器
    init(
        name: String,
        backgroundColor: Color,
        textColor: Color,
        accentColor: Color? = nil,
        font: String = "System",
        fontSize: CGFloat = 16,
        category: ThemeCategory = .custom,
        isCustom: Bool = true,
        isFavorite: Bool = false
    ) {
        self.name = name
        self.backgroundColor = CodableColor(color: backgroundColor)
        self.textColor = CodableColor(color: textColor)
        self.accentColor = accentColor != nil ? CodableColor(color: accentColor!) : nil
        self.font = font
        self.fontSize = fontSize
        self.category = category
        self.isCustom = isCustom
        self.isFavorite = isFavorite
        self.createdDate = Date()
    }
    
    // 渐变主题初始化器
    init(
        name: String,
        gradientColors: [Color],
        textColor: Color,
        font: String = "System",
        fontSize: CGFloat = 16,
        startPoint: UnitPoint = .topLeading,
        endPoint: UnitPoint = .bottomTrailing,
        category: ThemeCategory = .gradient,
        isCustom: Bool = true,
        isFavorite: Bool = false
    ) {
        self.name = name
        self.backgroundColor = CodableColor(color: gradientColors.first ?? .white)
        self.textColor = CodableColor(color: textColor)
        self.accentColor = nil
        self.font = font
        self.fontSize = fontSize
        self.category = category
        self.isCustom = isCustom
        self.isFavorite = isFavorite
        self.createdDate = Date()
        self.gradientColors = gradientColors.map { CodableColor(color: $0) }
        self.gradientStartPoint = CodableUnitPoint(unitPoint: startPoint)
        self.gradientEndPoint = CodableUnitPoint(unitPoint: endPoint)
    }
    
    // 转换为 CardTemplate
    func toCardTemplate() -> CardTemplate {
        return CardTemplate(
            name: name,
            backgroundColor: backgroundColor.color,
            textColor: textColor.color,
            font: font,
            fontSize: fontSize
        )
    }
}

// 可编码的颜色
struct CodableColor: Codable, Equatable {
    let red: Double
    let green: Double
    let blue: Double
    let opacity: Double
    
    init(color: Color) {
        let uiColor = UIColor(color)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.red = Double(r)
        self.green = Double(g)
        self.blue = Double(b)
        self.opacity = Double(a)
    }
    
    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}

// 可编码的 UnitPoint
struct CodableUnitPoint: Codable, Equatable {
    let x: Double
    let y: Double
    
    init(unitPoint: UnitPoint) {
        self.x = unitPoint.x
        self.y = unitPoint.y
    }
    
    var unitPoint: UnitPoint {
        UnitPoint(x: x, y: y)
    }
}

// 预设主题
extension Theme {
    static let defaultThemes: [Theme] = [
        // Claude 系列
        Theme(name: "Claude Light", backgroundColor: .white, textColor: Color(white: 0.09), category: .claude, isCustom: false),
        Theme(name: "Claude Dark", backgroundColor: Color(white: 0.09), textColor: Color(white: 0.97), category: .claude, isCustom: false),
        Theme(name: "Claude Accent", backgroundColor: Color(white: 0.95), textColor: Color(white: 0.13), category: .claude, isCustom: false),
        Theme(name: "Claude Primary", backgroundColor: Color(white: 0.13), textColor: Color(white: 0.97), category: .claude, isCustom: false),
        
        // 经典系列
        Theme(name: "海洋蓝", backgroundColor: .blue, textColor: .white, category: .classic, isCustom: false),
        Theme(name: "森林绿", backgroundColor: .green, textColor: .white, category: .classic, isCustom: false),
        Theme(name: "活力橙", backgroundColor: .orange, textColor: .white, category: .classic, isCustom: false),
        Theme(name: "神秘紫", backgroundColor: .purple, textColor: .white, category: .classic, isCustom: false),
        Theme(name: "浪漫粉", backgroundColor: .pink, textColor: .white, category: .classic, isCustom: false),
        Theme(name: "热情红", backgroundColor: .red, textColor: .white, category: .classic, isCustom: false),
        Theme(name: "优雅黑", backgroundColor: .black, textColor: .white, category: .classic, isCustom: false),
        Theme(name: "简约白", backgroundColor: .white, textColor: .black, category: .classic, isCustom: false),
        
        // 渐变系列
        Theme(name: "日落", gradientColors: [.orange, .pink, .purple], textColor: .white, category: .gradient, isCustom: false),
        Theme(name: "海洋", gradientColors: [.blue, .cyan, .teal], textColor: .white, category: .gradient, isCustom: false),
        Theme(name: "森林", gradientColors: [.green, Color(red: 0.4, green: 0.7, blue: 0.2)], textColor: .white, category: .gradient, isCustom: false),
        Theme(name: "彩虹", gradientColors: [.red, .orange, .yellow, .green, .blue, .purple], textColor: .white, category: .gradient, isCustom: false),
    ]
}