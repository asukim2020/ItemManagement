//
//  Date.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/09.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

extension Date {
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(
            from: gregorian.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: self)
            ) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }

    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(
            from: gregorian.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: self)
            ) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
    
//    func startOfDay() -> Date {
//        let calendar = Calendar.current
//        var components = calendar.dateComponents(
//        [.calendar,
//         .timeZone,
//         .era,
//         .quarter,
//         .year, .month, .day, .hour, .minute, .second,
//         .nanosecond,
//         .weekday,
//         .weekdayOrdinal,
//         .weekOfMonth,
//         .weekOfYear,
//         .yearForWeekOfYear],
//        from: self)
//
//        components.hour = 0
//        components.minute = 0
//        components.second = 0
//
//        return components.date!
//    }
}
