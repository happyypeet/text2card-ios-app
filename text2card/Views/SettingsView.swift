//
//  SettingsView.swift
//  text2card
//
//  Created by Trae AI on 5/16/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var isDarkMode = false
    @State private var language = "简体中文"
    @State private var autoSave = true
    @State private var showQRCode = false
    @State private var fontSize = 16.0
    @State private var email = "user123@example.com"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Form {
                    // 用户信息区域
                    Section {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                            
                            VStack(alignment: .leading) {
                                Text("张小明")
                                    .font(.headline)
                                Text(email)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    
                    // 常规设置
                    Section(header: Text("常规设置")) {
                        HStack {
                            Image(systemName: "globe")
                                .frame(width: 25)
                                .foregroundColor(.blue)
                            Text("语言")
                            Spacer()
                            Text(language)
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Image(systemName: "textformat.size")
                                .frame(width: 25)
                                .foregroundColor(.blue)
                            Text("字体大小")
                            Spacer()
                            Text("\(Int(fontSize))")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // 个性化设置
                    Section(header: Text("个性化设置")) {
                        Toggle(isOn: $isDarkMode) {
                            HStack {
                                Image(systemName: "moon.fill")
                                    .frame(width: 25)
                                    .foregroundColor(.blue)
                                Text("深色模式")
                            }
                        }
                        
                        Toggle(isOn: $autoSave) {
                            HStack {
                                Image(systemName: "square.and.arrow.down")
                                    .frame(width: 25)
                                    .foregroundColor(.blue)
                                Text("自动保存")
                            }
                        }
                    }
                    
                    // 隐私设置
                    Section(header: Text("隐私设置")) {
                        Toggle(isOn: $showQRCode) {
                            HStack {
                                Image(systemName: "qrcode")
                                    .frame(width: 25)
                                    .foregroundColor(.blue)
                                Text("显示个人二维码")
                            }
                        }
                        
                        NavigationLink(destination: Text("隐私政策内容")) {
                            HStack {
                                Image(systemName: "doc.text")
                                    .frame(width: 25)
                                    .foregroundColor(.blue)
                                Text("隐私政策")
                            }
                        }
                    }
                    
                    // 关于
                    Section {
                        NavigationLink(destination: Text("关于我们内容")) {
                            HStack {
                                Image(systemName: "info.circle")
                                    .frame(width: 25)
                                    .foregroundColor(.blue)
                                Text("关于我们")
                            }
                        }
                        
                        NavigationLink(destination: Text("帮助中心内容")) {
                            HStack {
                                Image(systemName: "questionmark.circle")
                                    .frame(width: 25)
                                    .foregroundColor(.blue)
                                Text("帮助中心")
                            }
                        }
                    }
                }
                
                // 移除自定义底部标签栏，使用主应用的TabView
            }
            .navigationBarTitle("设置", displayMode: .inline)
        }
    }
}

#Preview {
    SettingsView()
}