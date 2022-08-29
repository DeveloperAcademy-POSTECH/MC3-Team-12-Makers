//
//  CalenderSlotMockData.swift
//  Gajeongtongsin
//
//  Created by Beone on 2022/08/29.
//

import Foundation

func calenderSlotDataMaker() -> CalenderSlotData {
    var blockedSlot: [[Bool]] =  Array(repeating: Array(repeating: false, count: 18), count:weekDays)
    for section in 0..<weekDays {
        for index in 0..<3 {
            blockedSlot[section][index].toggle()
        }
        for index in 12..<18 {
            blockedSlot[section][index].toggle()
        }
    }
//    CalenderSlotData(blockedSlot: [], addedSlot: [])
    return CalenderSlotData(blockedSlot: blockedSlot)
}

var calenderSlotData: CalenderSlotData = calenderSlotDataMaker()
