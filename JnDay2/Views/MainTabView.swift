//
//  MainTabView.swift
//  JnDay2
//
//  Created by RebuildCode on 2025/5/2.
//

import SwiftUI



struct MainTabView: View {
    @StateObject private var themeManager = ThemeManager.shared
    @State private var selectedTab = 0
    @State private var showingAddAnniversary = false
    var body: some View {
        ZStack {
            // 添加全局背景
            BackgroundView()
                .ignoresSafeArea()
            
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("首页")
                    }
                    .tag(0)
                
                CalendarView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("日历")
                    }
                    .tag(1)
                Spacer()
                    .allowsHitTesting(false)
                NotificationView()
                    .tabItem {
                        Image(systemName: "bell.fill")
                        Text("提醒")
                    }
                    .tag(2)
                
                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("设置")
                    }
                    .tag(3)
            }
            .background(Color.clear)
            .scrollContentBackground(.hidden)
            .tint(ThemeManager.shared.primaryColor)
            
            Button(action: {
                showingAddAnniversary = true
            }) {
                ZStack {
                    Circle()
                        .fill(ThemeManager.shared.primaryColor)
                        .frame(width: 60, height: 60)
                        .shadow(color: ThemeManager.shared.primaryColor.opacity(0.3), radius: 4)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundColor(.white)
                }
                .shadow(color:ThemeManager.shared.primaryColor,radius: 10)
            }
            .offset(y: -10)
            }
        }
        .sheet(isPresented: $showingAddAnniversary) {
            AddAnniversaryView()
        }
    }
}

#Preview {
        MainTabView()
            .modelContainer(for: Anniversary.self, inMemory: true)
    }
