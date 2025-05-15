//
//  CalendarView.swift
//  JnDay2
//
//  Created by RebuildCode on 2025/5/2.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @StateObject private var themeManager = ThemeManager.shared
    @Environment(\.modelContext) private var modelContext
    @Query private var anniversaries: [Anniversary]
    
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    
    private let calendarHelper = CalendarHelper.shared
    private let daysOfWeek = ["日", "一", "二", "三", "四", "五", "六"]
    
    @State private var selectedAnniversary: Anniversary?
    @State private var showingAnniversaryDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer(minLength: 0)
            // 月份导航栏
            HStack {
                Button(action: {
                    withAnimation {
                        currentMonth = calendarHelper.addMonths(to: currentMonth, months: -1)
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(themeManager.primaryColor)
                }
                
                Spacer()
                
                let components = calendarHelper.components([.year, .month], from: currentMonth)
                Text(String(format: "%d年%d月", components.year ?? 0, components.month ?? 0))
                    .font(.title2.bold())
                    .foregroundColor(themeManager.primaryColor)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        currentMonth = calendarHelper.addMonths(to: currentMonth, months: 1)
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(themeManager.primaryColor)
                }
            }
            .padding(.horizontal)
            
            // 星期标题行
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(themeManager.primaryColor)
                }
            }
            .padding(.horizontal)
            
            // 获取当前月份的组件
            let components = calendarHelper.components([.year, .month], from: currentMonth)
            
            // 日历网格
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                let firstDay = calendarHelper.firstDayOfMonth(for: currentMonth)
                let daysInMonth = calendarHelper.daysInMonth(for: currentMonth)
                let firstWeekday = calendarHelper.weekday(for: firstDay)
                
                // 填充前置空白
                ForEach((-firstWeekday + 1)...0, id: \.self) { _ in
                    Color.clear
                        .aspectRatio(1, contentMode: .fill)
                }
                
                // 日期单元格
                ForEach(1...daysInMonth, id: \.self) { day in
                    let date = calendarHelper.date(year: components.year ?? 0,
                                                  month: components.month ?? 0,
                                                  day: day)
                    DayCell(date: date,
                           isSelected: calendarHelper.isDate(date, inSameDayAs: selectedDate),
                           isToday: calendarHelper.isToday(date),
                           lunarDate: calendarHelper.getLunarDate(for: date),
                           anniversaries: anniversariesForDate(date))
                        .onTapGesture {
                            withAnimation {
                                selectedDate = date
                            }
                        }
                }
            }
            .padding(.horizontal)
            
            
            // 选中日期的纪念日列表
            VStack(spacing: 8) {
                if !anniversariesForDate(selectedDate).isEmpty {
                    ForEach(anniversariesForDate(selectedDate)) { anniversary in
                        AnniversarySummaryView(anniversary: anniversary)
                            .padding(.horizontal)
                            .onTapGesture {
                                selectedAnniversary = anniversary
                                showingAnniversaryDetail = true
                            }
                    }
                } else {
                    Text("当前日期没有纪念日")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .frame(maxHeight: UIScreen.main.bounds.height * 0.25)
        }
        .sheet(isPresented: $showingAnniversaryDetail) {
            if let anniversary = selectedAnniversary {
                AnniversaryCard(anniversary: anniversary)
                    .presentationDetents([.medium])
            }
        }
        .background(Color.clear)
    }
    
    private func anniversariesForDate(_ date: Date) -> [Anniversary] {
        return anniversaries.filter { anniversary in
            let anniversaryComponents = calendarHelper.components([.month, .day], from: anniversary.date)
            let dateComponents = calendarHelper.components([.month, .day], from: date)
            return anniversaryComponents.month == dateComponents.month &&
                   anniversaryComponents.day == dateComponents.day
        }
    }
}

struct DayCell: View {
    @StateObject private var themeManager = ThemeManager.shared
    private let calendarHelper = CalendarHelper.shared
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let lunarDate: String
    let anniversaries: [Anniversary]
    
    var body: some View {
        VStack(spacing: 2) {
            let calendar = Calendar.current
            let day = calendar.component(.day, from: date)
            
            Text("\(day)")
                .font(.system(size: 16, weight: .medium))
            
            Text(lunarDate)
                .font(.system(size: 10))
                .foregroundColor(.gray)
            
            if !anniversaries.isEmpty {
                Circle()
                    .fill(themeManager.primaryColor)
                    .frame(width: 6, height: 6)
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fill)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? themeManager.primaryColor.opacity(0.2) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isToday ? themeManager.primaryColor : Color.clear, lineWidth: 1)
        )
    }
}

#Preview {
    CalendarView()
        .modelContainer(for: Anniversary.self, inMemory: true)
}
