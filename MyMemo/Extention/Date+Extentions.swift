//
//  Date+Extentions.swift
//  MyMemo
//
//  Created by bro on 2022/05/20.
//

import Foundation

extension Date {
    
    func toString() -> String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(self) {
            formatter.dateFormat = "a HH:mm"
        } else if isInSameWeek(as: self) {
            formatter.dateFormat = "EEEE"
        } else {
            formatter.dateFormat = "yyyy. MM. dd. a hh:mm"
        }
        
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ko-KR")
        return formatter.string(from: self)
    }

    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
            calendar.isDate(self, equalTo: date, toGranularity: component)
        }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }

}

extension String {
    
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ko-KR")
        formatter.dateFormat = "yyyy.MM.dd a HH:mm"
        return formatter.date(from: self)
    }
}


