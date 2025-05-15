//
//  SettingsView.swift
//  JnDay2
//
//  Created by RebuildCode on 2025/5/2.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var themeManager = ThemeManager.shared
    @AppStorage("preferLunar") private var preferLunar = false
    @AppStorage("notificationEnabled") private var notificationEnabled = true
    @AppStorage("notificationDays") private var notificationDays = 7
    
    private let themeColors = [
        "blue": "蓝色",
        "purple": "紫色",
        "green": "绿色",
        "red": "红色",
        "coral": "珊瑚色",
        "custom": "自定义"
    ]
    
    @State private var showingColorPicker = false
    @State private var selectedColor = Color(.sRGB, red: 1, green: 0.42, blue: 0.42)
    
    var body: some View {
            List {
                Section(header: Text("主题设置").foregroundColor(ThemeManager.shared.primaryColor)) {
                    ForEach(themeManager.availableThemes, id: \.self) { theme in
                        HStack {
                            Circle()
                                .fill(themeManager.getPrimaryColor(for: theme))
                                .frame(width: 20, height: 20)
                            Text(themeColors[theme] ?? "")
                                .foregroundColor(themeManager.getPrimaryColor(for: theme))
                            Spacer()
                            if theme == themeManager.currentTheme {
                                Image(systemName: "checkmark")
                                    .foregroundColor(themeManager.primaryColor)
                            }
                            if theme == "custom" {
                                ColorPicker("", selection: $selectedColor)
                                    .onChange(of: selectedColor) { _, newValue in
                                        let hexColor = "#" + newValue.toHex()
                                        themeManager.setCustomThemeColor(hexColor)
                                    }
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                themeManager.setTheme(theme)
                            }
                        }
                        

                    }
                }
                
                Section(header: Text("关于").foregroundColor(ThemeManager.shared.primaryColor)) {
                    HStack {
                        Text("版本")
                            .foregroundColor(ThemeManager.shared.primaryColor)
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(ThemeManager.shared.primaryColor)
                    }
                    
                    Button(action: {
                        // TODO: 实现反馈功能
                    }) {
                        Label("意见反馈", systemImage: "envelope")
                            .foregroundStyle(ThemeManager.shared.primaryColor)
                    }
                }
            }
            .background(Color.clear)
        }
    
}

#Preview {
    SettingsView()
}
