//
//  ThemeManager.swift
//  JnDay2
//
//  Created by RebuildCode on 2025/5/2.
//

import SwiftUI

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @AppStorage("themeColor") private var themeColor: String = "blue"
    @AppStorage("customThemeColor") private var customThemeColor: String = "#FF6B6B"
    
    private init() {
        // 初始化时加载自定义主题颜色
        if currentTheme == "custom" {
            updateCustomThemeColors()
        }
    }
    
    // 主题色值映射
    private var themeColors: [String: (primary: UInt, secondary: UInt)] = [
        "blue": (0x4A90E2, 0x74B1FF),
        "purple": (0x9B59B6, 0xB07CC6),
        "green": (0x2ECC71, 0x54D98C),
        "red": (0xE74C3C, 0xF76D5E),
        "coral": (0xFF6B6B, 0xFF8787),
        "custom": (0xFF6B6B, 0xFF8787) // 自定义主题色，初始值为"#FF6B6B"
    ]
    
    // 当前主题色
    var currentTheme: String {
        get { themeColor }
        set {
            themeColor = newValue
            if newValue == "custom" {
                updateCustomThemeColors()
            }
        }
    }
    
    // 更新自定义主题颜色
    private func updateCustomThemeColors() {
        if let hexValue = UInt(customThemeColor.replacingOccurrences(of: "#", with: ""), radix: 16) {
            let lighterHex = calculateLighterColor(from: hexValue)
            themeColors["custom"] = (hexValue, lighterHex)
        }
    }
    
    // 计算更亮的颜色
    private func calculateLighterColor(from hex: UInt) -> UInt {
        let r = CGFloat((hex >> 16) & 0xFF) / 255.0
        let g = CGFloat((hex >> 8) & 0xFF) / 255.0
        let b = CGFloat(hex & 0xFF) / 255.0
        
        let lighterR = min(r + 0.1, 1.0)
        let lighterG = min(g + 0.1, 1.0)
        let lighterB = min(b + 0.1, 1.0)
        
        let newR = UInt(lighterR * 255) << 16
        let newG = UInt(lighterG * 255) << 8
        let newB = UInt(lighterB * 255)
        
        return newR | newG | newB
    }
    
    // 设置自定义主题颜色
    func setCustomThemeColor(_ hexColor: String) {
        customThemeColor = hexColor
        updateCustomThemeColors()
        currentTheme = "custom"
        objectWillChange.send()
    }
    
    // 获取所有可用主题
    var availableThemes: [String] {
        Array(themeColors.keys)
    }
    
    // 主色调
    var primaryColor: Color {
        Color(hex: themeColors[themeColor]?.primary ?? themeColors["blue"]!.primary)
    }
    
    // 次要色调
    var secondaryColor: Color {
        Color(hex: themeColors[themeColor]?.secondary ?? themeColors["blue"]!.secondary)
    }
    
    // 获取指定主题的主色调
    func getPrimaryColor(for theme: String) -> Color {
        Color(hex: themeColors[theme]?.primary ?? themeColors["blue"]!.primary)
    }
    
    // 获取指定主题的次要色调
    func getSecondaryColor(for theme: String) -> Color {
        Color(hex: themeColors[theme]?.secondary ?? themeColors["blue"]!.secondary)
    }
    
    // 切换主题
    func setTheme(_ theme: String) {
        currentTheme = theme
    }
}
