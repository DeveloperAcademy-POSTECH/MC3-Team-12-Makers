//
//  String+Extension.swift
//  Gajeongtongsin
//
//  Created by uiskim on 2022/07/29.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")

        guard let date = dateFormatter.date(from: self) else {return nil}
        return date
    }
}
