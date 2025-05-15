//
//  NotificationView.swift
//  JnDay2
//
//  Created by RebuildCode on 2025/5/2.
//

import SwiftUI

struct NotificationView: View {
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        VStack {
            ContentUnavailableView("提醒功能开发中", 
                systemImage: "bell.badge", 
                description: Text("此功能将在未来版本中推出"))
            .foregroundColor(ThemeManager.shared.primaryColor)
        }
    }
}

#Preview {
    NotificationView()
}
