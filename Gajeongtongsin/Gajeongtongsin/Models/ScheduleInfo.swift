//
//  ScheduleInfo.swift
//  Gajeongtongsin
//
//  Created by uiskim on 2022/07/19.
//

import Foundation
struct ScheduleInfo {
    let consultingDate: String         //상담원하는날짜
    let startTime: String              //상담시작시간(단위시간이 정해져있어서 끝나는시간은 안넣음)
    let isReserved: Bool               //false = 예약불가, true = 완료
}
