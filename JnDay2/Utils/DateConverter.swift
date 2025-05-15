//
//  DateConverter.swift
//  JnDay2
//
//  Created by RebuildCode on 2025/5/2.
//

import Foundation
import LunarSwift

class DateConverter {
    static func lunarToLunar(date: Date) -> String{
        let solar = Solar.fromDate(date: date)
        let lunar = Lunar.fromYmdHms(lunarYear: solar.year, lunarMonth: solar.month, lunarDay: solar.day)
        let toDayLunar = Lunar.fromDate(date: Date())
        let result = toDayLunar.year == lunar.year ?
        "\(lunar.monthInChinese)月\(lunar.dayInChinese)日" :
        "\(lunar.yearInChinese)年\(lunar.monthInChinese)月\(lunar.dayInChinese)日"
        // let result = "\(lunar.yearInChinese)年\(lunar.monthInChinese)月\(lunar.dayInChinese)"
//        print("[日期转换lunarToLunar] 农历转农历 - 输入: \(date), 输出: \(result)")
        return result
    }
    static func solarToSolar(date: Date) -> String {
        let solar = Solar.fromDate(date: date)
        let result = "\(solar.year)年\(solar.month)月\(solar.day)日"
//        print("[日期转换solarToSolar] 公历转公历 - 输入: \(date), 输出: \(result)")
        return result
    }
    static func solarToLunar(date: Date) -> String {
        let solar = Solar.fromDate(date: date)
        let lunar = solar.lunar
        let toDayLunar = Lunar.fromDate(date: Date())
        let result = toDayLunar.year == lunar.year ?
        "\(lunar.monthInChinese)月\(lunar.dayInChinese)号" :
        "\(lunar.yearInChinese)年\(lunar.monthInChinese)月\(lunar.dayInChinese)号"
//        print("[日期转换solarToLunar] 公历转农历 - 输入: \(date), 输出: \(result)")
        return result
    }
    static func lunarToSolar(date: Date) -> String {
        let _solar = Solar.fromDate(date: date)
        let lunar = Lunar.fromYmdHms(lunarYear: _solar.year, lunarMonth: _solar.month, lunarDay: _solar.day)
        let solar = lunar.solar
        let toDaySolar = Solar.fromDate(date: Date())

        let result = toDaySolar.year == solar.year ? "\(solar.month)月\(solar.day)日" : "\(solar.year)年\(solar.month)月\(solar.day)日"
//        print("[日期转换lunarToSolar] 农历转公历 - 输入: \(date), 输出: \(result)")
        return result
    }
    static func _isLunar(isLunar: Bool, Tbox: Int, date: Date, _anniversary: Anniversary) -> String {
        let solar = Solar.fromDate(date: date)
        let today = Solar.fromDate(date: Date())
        var year = today.year
        if(today.month > solar.month || (solar.month == today.month && today.day > solar.day)){
            year += 1
//            print("[日期转换_isLunar] 过了一年\(today)")
        }
        let _date = isNextYear(isLunar: isLunar, date: date)
        var result = ""
        if isLunar {
            result = Tbox == 0 ? lunarToLunar(date: _date!) : lunarToSolar(date: _date!)
        } else {
            result = Tbox == 1 ? solarToSolar(date: _date!) : solarToLunar(date: _date!)
        }
        return result
    }
    static func isNextYear(isLunar:Bool, date: Date) -> Date? {
        let _solar = Solar.fromDate(date: date)
        let toDayLunar = Lunar.fromDate(date: Date())
        let year = _solar.year < toDayLunar.year ? toDayLunar.year : _solar.year
        let month = _solar.month
        let day = _solar.day
        var _lunar = _solar.lunar
        if isLunar {
            if(_solar.month > toDayLunar.month || (_solar.month == toDayLunar.month && _solar.day > toDayLunar.day)){
                _lunar = Lunar.fromYmdHms(lunarYear: year, lunarMonth: month, lunarDay: day)
            }else{
                _lunar = Lunar.fromYmdHms(lunarYear: year + 1, lunarMonth: month, lunarDay: day)
            }
        }else{
            let newSolar = Solar.fromYmdHms(year: year, month: month, day: day)
            let newLunar = newSolar.lunar
//            print("[日期转换_isNextYear] newLunar\(newLunar)")
            if(newLunar.month > toDayLunar.month || (newLunar.month == toDayLunar.month && newLunar.day > toDayLunar.day)){
                _lunar = Lunar.fromYmdHms(lunarYear: year, lunarMonth: month, lunarDay: day)
            }else{
                _lunar = Lunar.fromYmdHms(lunarYear: year + 1, lunarMonth: month, lunarDay: day)
            }
        }
//        print("[日期转换_isNextYear] 输入的日期：\(_solar),转换的当年日期：\(_lunar),当年农历日期：\(toDayLunar)")

        var newDate = DateComponents()
        newDate.calendar = Calendar(identifier:.gregorian)
        newDate.year = _lunar.year
        newDate.month = _lunar.month
        newDate.day = _lunar.day
        let result = newDate.date!
        
//        print("isNextYear：\(result)")
        return result
    }
    static func convertLunarToSolar(date: Date) -> Date? {
        let calendar = Calendar(identifier: .chinese)
        let components = calendar.dateComponents([.year, .month, .day], from: date)
//        print("[日期转换convertLunarToSolar] 输入的日期：\(components)")
        guard let year = components.year,
              let month = components.month,
              let day = components.day else {
//            print("[日期转换] 错误：无法获取农历日期组件")
            return nil
        }
        
        let lunar = Lunar.fromYmdHms(lunarYear: year, lunarMonth: month, lunarDay: day)
        let solar = lunar.solar
        
        var solarComponents = DateComponents()
        solarComponents.calendar = Calendar(identifier: .gregorian)
        solarComponents.year = solar.year
        solarComponents.month = solar.month
        solarComponents.day = solar.day
        
        guard let result = solarComponents.calendar?.date(from: solarComponents) else {
//            print("[日期转换] 错误：无法创建公历日期")
            return nil
        }
        
//        print("[日期转换] 农历日期转公历日期 - 输入: \(date), 输出: \(result)")
        return result
    }
    
    static func getNextLunarAnniversaryDate(from currentDate: Date, anniversaryDate: Date) -> Date? {
//        print("[纪念日计算] 开始计算下一个农历纪念日")
//        print("[纪念日计算] 当前日期: \(currentDate), 纪念日期: \(anniversaryDate)")
        
        // 获取当前日期的农历年份
        let currentSolar = Solar.fromDate(date: currentDate)
        let currentLunar = currentSolar.lunar
        
        // 获取纪念日的农历月日
        let anniversarySolar = Solar.fromDate(date: anniversaryDate)
        
//        print("[纪念日计算] 当前农历年份: \(currentLunar.year), 纪念日农历月: \(anniversaryLunar.month), 日: \(anniversaryLunar.day)")
        
        // 使用lunar-swift创建今年的农历纪念日
        let thisYearLunar = Lunar.fromYmdHms(lunarYear: currentLunar.year, 
                                            lunarMonth: anniversarySolar.month, 
                                            lunarDay: anniversarySolar.day)
        let thisYearSolar = thisYearLunar.solar
        
        // 创建今年的公历日期
        var components = DateComponents()
        components.calendar = Calendar(identifier: .gregorian)
        components.year = thisYearSolar.year
        components.month = thisYearSolar.month
        components.day = thisYearSolar.day
        
        guard let thisYearDate = components.calendar?.date(from: components) else {
//            print("[纪念日计算] 错误：无法创建今年的纪念日日期")
            return nil
        }
        
//        print("[纪念日计算] 今年的纪念日日期: \(thisYearDate)")
        
        // 如果今年的日期已过，计算明年的日期
        if thisYearDate < currentDate {
//            print("[纪念日计算] 今年的纪念日已过，计算明年的日期")
            let nextYearLunar = Lunar.fromYmdHms(lunarYear: currentLunar.year + 1, 
                                                lunarMonth: anniversarySolar.month, 
                                                lunarDay: anniversarySolar.day)
            let nextYearSolar = nextYearLunar.solar
            
            components.year = nextYearSolar.year
            components.month = nextYearSolar.month
            components.day = nextYearSolar.day
            
            guard let nextYearDate = components.calendar?.date(from: components) else {
//                print("[纪念日计算] 错误：无法创建明年的纪念日日期")
                return nil
            }
            
//            print("[纪念日计算] 明年的纪念日日期: \(nextYearDate)")
            return nextYearDate
        }
        
//        print("[纪念日计算] 使用今年的纪念日日期")
        return thisYearDate
    }
}
