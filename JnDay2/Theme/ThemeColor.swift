//
//  ThemeColor.swift
//  JnDay2
//
//  Created by RebuildCode on 2025/5/2.
//

import SwiftUI

extension UIColor {
    convenience init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            red: CGFloat((hex >> 16) & 0xff) / 255,
            green: CGFloat((hex >> 8) & 0xff) / 255,
            blue: CGFloat(hex & 0xff) / 255,
            alpha: alpha
        )
    }
    
    func adjustBrightness(by factor: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue,
                          saturation: saturation,
                          brightness: brightness * (1 + factor),
                          alpha: alpha)
        }
        return self
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(UIColor(hex: hex, alpha: alpha))
    }
    // MARK: - 主题色
    static let _primaryTheme = Color(UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ?
            UIColor(hex: 0xFF8787) : UIColor(hex: 0xFF6B6B)
    })
    static let _secondaryTheme = Color(UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ?
            UIColor(hex: 0xFFB996) : UIColor(hex: 0xFFA07A)
    })
    
    // MARK: - 背景色
    static let _backgroundPrimary = Color(UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ?
            UIColor(hex: 0x1C1C1E) : UIColor(hex: 0xFFFFFF)
    })
    static let _backgroundSecondary = Color(UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ?
            UIColor(hex: 0x2C2C2E) : UIColor(hex: 0xF5F5F5)
    })
    
    // MARK: - 文本色
    static let _textPrimary = Color(UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ?
            UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x333333)
    })
    static let _textSecondary = Color(UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ?
            UIColor(hex: 0xAEAEB2) : UIColor(hex: 0x666666)
    })
    
    // MARK: - 功能色
    static let _success = Color(UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ?
            UIColor(hex: 0x4CAF50).adjustBrightness(by: 0.2) : UIColor(hex: 0x4CAF50)
    })
    static let _warning = Color(UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ?
            UIColor(hex: 0xFFC107).adjustBrightness(by: -0.2) : UIColor(hex: 0xFFC107)
    })
    static let _error = Color(UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ?
            UIColor(hex: 0xF44336).adjustBrightness(by: 0.2) : UIColor(hex: 0xF44336)
    })
    
    // MARK: - 分割线和边框
    static let _separator = Color(UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ?
            UIColor(hex: 0x48484A) : UIColor(hex: 0xE0E0E0)
    })
    static let _border = Color(UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ?
            UIColor(hex: 0x3A3A3C) : UIColor(hex: 0xDDDDDD)
    })
}
