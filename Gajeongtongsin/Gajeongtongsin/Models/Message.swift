//
//  Message.swift
//  Gajeongtongsin
//
//  Created by uiskim on 2022/07/19.
//

import Foundation
struct Message {
    let type: MessageType      //요구하는task(enum) -> 우선 조퇴랑 결석만
    let sentDate: Date         //메세지 보내는 시간
    let expectedDate: String     //(->String)학부모가 요구하는(조퇴나 결석) 날짜
    let content: String        //메세지 내용
    let isCompleted: Bool      //task완료 여부(교사의 체크)
}

enum MessageType: String {
    case absence = "결석"
    case earlyLeave = "조퇴"
    case emergency = "긴급"
}
