//
//  Date+Extension.swift
//  Gajeongtongsin
//
//  Created by uiskim on 2022/07/29.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월d일"
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
    func toStringWithTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월d일 HH시mm분"
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
}
