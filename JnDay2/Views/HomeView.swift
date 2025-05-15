//
//  HomeView.swift
//  JnDay2
//
//  Created by RebuildCode on 2025/5/2.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var anniversaries: [Anniversary]
    
    @State private var searchText = ""
    @State private var selectedType: AnniversaryType?
    
    // 获取纪念日距离今天的天数（使用缓存）
    func getDaysUntil(for anniversary: Anniversary) -> Int {
        return anniversary.daysUntilNextAnniversary
    }
    
    var filteredAnniversaries: [Anniversary] {
        var filtered = anniversaries
        
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        
        if let type = selectedType {
            filtered = filtered.filter { $0.type == type }
        }
        
        // 按照剩余天数排序，剩余天数少的排在前面
        return filtered.sorted { getDaysUntil(for: $0) < getDaysUntil(for: $1) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 搜索栏
            SearchBar(text: $searchText)
                .padding()
            
            // 分类标签
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    FilterButton(title: "全部", isSelected: selectedType == nil) {
                        selectedType = nil
                    }
                    
                    FilterButton(title: AnniversaryType.birthday.rawValue,
                               isSelected: selectedType == .birthday) {
                        selectedType = .birthday
                    }
                    
                    FilterButton(title: AnniversaryType.anniversary.rawValue,
                               isSelected: selectedType == .anniversary) {
                        selectedType = .anniversary
                    }
                    
                    FilterButton(title: AnniversaryType.festival.rawValue,
                               isSelected: selectedType == .festival) {
                        selectedType = .festival
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
            
            // 纪念日列表
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(filteredAnniversaries) { anniversary in
                        AnniversaryCard(anniversary: anniversary)
                    }
                }
                .padding()
            }
            .overlay {
                if filteredAnniversaries.isEmpty {
                    ContentUnavailableView("没有纪念日", systemImage: "calendar.badge.exclamationmark", description: Text("点击底部的加号添加您的第一个纪念日"))
                }
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name("RefreshHomeView"),
                object: nil,
                queue: .main
            ) { _ in
                // 使用SwiftData的Query自动更新机制
                // @Query属性包装器会自动处理数据更新
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self)
        }
        .background(Color.clear)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Anniversary.self, inMemory: true)
}
