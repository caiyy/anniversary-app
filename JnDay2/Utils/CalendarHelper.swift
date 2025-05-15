//
//  CalendarHelper.swift
//  JnDay2
//
//  Created by RebuildCode on 2025/5/2.
//

import Foundation

class CalendarHelper {
    static let shared = CalendarHelper()
    private let calendar = Calendar.current
    private let lunarCalendar = Calendar(identifier: .chinese)
    
    private init() {}
    
    func firstDayOfMonth(for date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components) ?? date
    }
    
    func daysInMonth(for date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)
        return range?.count ?? 0
    }
    
    func weekday(for date: Date) -> Int {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday ?? 1
    }
    
    func getLunarDate(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = lunarCalendar
        formatter.dateFormat = "MMMMd"
        return formatter.string(from: date)
    }
    
    func date(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return calendar.date(from: components) ?? Date()
    }
    
    func components(_ components: Set<Calendar.Component>, from date: Date) -> DateComponents {
        return calendar.dateComponents(components, from: date)
    }
    
    func isToday(_ date: Date) -> Bool {
        return calendar.isDate(date, inSameDayAs: Date())
    }
    
    func addMonths(to date: Date, months: Int) -> Date {
        return calendar.date(byAdding: .month, value: months, to: date) ?? date
    }
    
    func isDate(_ date1: Date, inSameDayAs date2: Date) -> Bool {
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}