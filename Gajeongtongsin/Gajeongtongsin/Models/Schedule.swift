//
//  Schedule.swift
//  Gajeongtongsin
//
//  Created by uiskim on 2022/07/19.
//

import Foundation
struct Schedule : Codable {
    let reservedDate: String            //상담신청날짜
    var scheduleList: [ScheduleInfo]  //스케줄정보들
    let content: String               //상담내용
}
