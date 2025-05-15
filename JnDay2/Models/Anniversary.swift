//
//  Anniversary.swift
//  JnDay2
//
//  Created by RebuildCode on 2025/5/2.
//

import Foundation
import SwiftData
import LunarSwift

@Model
class Anniversary {
    var title: String
    var date: Date
    var imageData: Data?
    var type: AnniversaryType
    var createdAt: Date
    var isLunar: Bool
    var reminderEnabled: Bool
    var reminderTime: Date?
    var reminderDaysBefore: Int
    
    // 缓存字段
    var cachedDaysUntil: Int?
    var cachedNextAnniversaryDate: Date?
    var lastCacheUpdateDate: Date?
    
    init(title: String, date: Date, imageData: Data? = nil, type: AnniversaryType, isLunar: Bool = false) {
        self.title = title
        self.date = date
        self.imageData = imageData
        self.type = type
        self.createdAt = Date()
        self.isLunar = isLunar
        self.reminderEnabled = true
        
        // 设置默认提醒时间为早上9点
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.hour = 9
        components.minute = 0
        self.reminderTime = Calendar.current.date(from: components) ?? date
        
        // 默认提前1天提醒
        self.reminderDaysBefore = 1
        
        // 初始化缓存字段
        self.cachedDaysUntil = nil
        self.cachedNextAnniversaryDate = nil
        self.lastCacheUpdateDate = nil

    }
}

enum AnniversaryType: String, Codable {
    case birthday = "生日"
    case anniversary = "纪念日"
    case festival = "节日"
}

extension Anniversary {
    // 更新缓存的方法
    func updateCache() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if self.isLunar {
            if let nextDate = DateConverter.getNextLunarAnniversaryDate(from: today, anniversaryDate: self.date) {
                self.cachedNextAnniversaryDate = nextDate
                self.cachedDaysUntil = Calendar.current.dateComponents([.day], from: today, to: nextDate).day
            }
        } else {
            let targetDate = Calendar.current.startOfDay(for: self.date)
            var components = Calendar.current.dateComponents([.year], from: today)
            components.month = Calendar.current.component(.month, from: targetDate)
            components.day = Calendar.current.component(.day, from: targetDate)
            
            if let thisYearDate = Calendar.current.date(from: components) {
                var daysUntil = Calendar.current.dateComponents([.day], from: today, to: thisYearDate).day ?? 365
                
                if daysUntil < 0 {
                    components.year = components.year! + 1
                    if let nextYearDate = Calendar.current.date(from: components) {
                        daysUntil = Calendar.current.dateComponents([.day], from: today, to: nextYearDate).day ?? 365
                        self.cachedNextAnniversaryDate = nextYearDate
                    }
                } else {
                    self.cachedNextAnniversaryDate = thisYearDate
                }
                
                self.cachedDaysUntil = daysUntil
            }
        }
        
        self.lastCacheUpdateDate = today
    }
    
    // 获取距离下一个纪念日的天数
    var daysUntilNextAnniversary: Int {
        let today = Calendar.current.startOfDay(for: Date())
        
        // 如果缓存不存在或者已过期（不是今天的数据），则更新缓存
        if cachedDaysUntil == nil || lastCacheUpdateDate == nil ||
           !Calendar.current.isDate(lastCacheUpdateDate!, inSameDayAs: today) {
            updateCache()
        }
        
        return cachedDaysUntil ?? 365
    }
    
    // 获取下一个纪念日的日期
    var nextAnniversaryDate: Date? {
        let today = Calendar.current.startOfDay(for: Date())
        
        // 如果缓存不存在或者已过期（不是今天的数据），则更新缓存
        if cachedNextAnniversaryDate == nil || lastCacheUpdateDate == nil ||
           !Calendar.current.isDate(lastCacheUpdateDate!, inSameDayAs: today) {
            updateCache()
        }
        
        return cachedNextAnniversaryDate
    }
}
