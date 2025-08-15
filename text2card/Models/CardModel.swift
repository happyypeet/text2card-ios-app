//
//  CardModel.swift
//  text2card
//
//  Created by Trae AI on 5/16/25.
//

import SwiftUI

struct Card: Identifiable, Codable {
    var id = UUID()
    var text: String
    var backgroundColor: Color
    var textColor: Color
    var font: String
    var fontSize: CGFloat
    var name: String?
    var qrCodeData: String?
    var createdAt: Date
    var isMarkdown: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, text, name, qrCodeData, createdAt, isMarkdown
        case backgroundColor, textColor, font, fontSize
    }
    
    init(text: String, backgroundColor: Color = .blue, textColor: Color = .white, font: String = "Helvetica", fontSize: CGFloat = 16, name: String? = nil, qrCodeData: String? = nil, isMarkdown: Bool = false) {
        self.id = UUID()
        self.text = text
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.font = font
        self.fontSize = fontSize
        self.name = name
        self.qrCodeData = qrCodeData
        self.createdAt = Date()
        self.isMarkdown = isMarkdown
    }
    
    // 颜色编码解码
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        qrCodeData = try container.decodeIfPresent(String.self, forKey: .qrCodeData)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        isMarkdown = try container.decode(Bool.self, forKey: .isMarkdown)
        
        // 颜色需要特殊处理
        let bgColorData = try container.decode(Data.self, forKey: .backgroundColor)
        backgroundColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: bgColorData)?.color ?? .blue
        
        let txtColorData = try container.decode(Data.self, forKey: .textColor)
        textColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: txtColorData)?.color ?? .white
        
        font = try container.decode(String.self, forKey: .font)
        fontSize = try container.decode(CGFloat.self, forKey: .fontSize)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(text, forKey: .text)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(qrCodeData, forKey: .qrCodeData)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(isMarkdown, forKey: .isMarkdown)
        
        // 颜色需要特殊处理
        let bgColorData = try NSKeyedArchiver.archivedData(withRootObject: UIColor(backgroundColor), requiringSecureCoding: false)
        try container.encode(bgColorData, forKey: .backgroundColor)
        
        let txtColorData = try NSKeyedArchiver.archivedData(withRootObject: UIColor(textColor), requiringSecureCoding: false)
        try container.encode(txtColorData, forKey: .textColor)
        
        try container.encode(font, forKey: .font)
        try container.encode(fontSize, forKey: .fontSize)
    }
}

// 卡片模板
struct CardTemplate: Identifiable {
    let id = UUID()
    let name: String
    let backgroundColor: Color
    let textColor: Color
    let font: String
    let fontSize: CGFloat
    
    // 预设模板
    static let templates: [CardTemplate] = [
        // Claude 主题系列
        CardTemplate(name: "Claude Light", backgroundColor: .white, textColor: Color(white: 0.09), font: "System", fontSize: 16),
        CardTemplate(name: "Claude Dark", backgroundColor: Color(white: 0.09), textColor: Color(white: 0.97), font: "System", fontSize: 16),
        CardTemplate(name: "Claude Accent", backgroundColor: Color(white: 0.95), textColor: Color(white: 0.13), font: "System", fontSize: 16),
        CardTemplate(name: "Claude Primary", backgroundColor: Color(white: 0.13), textColor: Color(white: 0.97), font: "System", fontSize: 16),
        
        // 经典配色
        CardTemplate(name: "海洋蓝", backgroundColor: .blue, textColor: .white, font: "System", fontSize: 16),
        CardTemplate(name: "森林绿", backgroundColor: .green, textColor: .white, font: "System", fontSize: 16),
        CardTemplate(name: "活力橙", backgroundColor: .orange, textColor: .white, font: "System", fontSize: 16),
        CardTemplate(name: "神秘紫", backgroundColor: .purple, textColor: .white, font: "System", fontSize: 16),
        CardTemplate(name: "浪漫粉", backgroundColor: .pink, textColor: .white, font: "System", fontSize: 16),
        CardTemplate(name: "热情红", backgroundColor: .red, textColor: .white, font: "System", fontSize: 16),
        CardTemplate(name: "优雅黑", backgroundColor: .black, textColor: .white, font: "System", fontSize: 16),
        CardTemplate(name: "简约白", backgroundColor: .white, textColor: .black, font: "System", fontSize: 16)
    ]
}

// 颜色扩展
extension UIColor {
    var color: Color {
        return Color(self)
    }
}

extension Color {
    var uiColor: UIColor {
        return UIColor(self)
    }
}