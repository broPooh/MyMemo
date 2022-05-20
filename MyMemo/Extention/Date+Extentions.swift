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
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ko-KR")
        formatter.dateFormat = "yyyy.MM.dd a HH:mm"
        return formatter.string(from: self)
    }

}

extension String {
    
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ko-KR")
        formatter.dateFormat = "yyyy.MM.dd a HH:mm"
        return formatter.date(from: self)
    }
}


