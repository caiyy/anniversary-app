//
//  AnniversarySummaryView.swift
//  JnDay2
//
//  Created by RebuildCode on 2025/5/2.
//

import SwiftUI

struct AnniversarySummaryView: View {
    @StateObject private var themeManager = ThemeManager.shared
    let anniversary: Anniversary
    
    private var typeIcon: String {
        switch anniversary.type {
        case .birthday:
            return "birthday.cake"
        case .anniversary:
            return "heart.fill"
        case .festival:
            return "party.popper"
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // 类型图标
            Image(systemName: typeIcon)
                .font(.system(size: 20))
                .foregroundColor(themeManager.primaryColor)
                .frame(width: 24, height: 24)
            
            // 标题
            Text(anniversary.title)
                .font(.system(size: 16, weight: .medium))
                .lineLimit(1)
            
            Spacer()
            
            // 距离天数
            Text("还有\(anniversary.daysUntilNextAnniversary)天")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}