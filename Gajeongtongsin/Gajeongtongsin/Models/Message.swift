//
//  Message.swift
//  Gajeongtongsin
//
//  Created by uiskim on 2022/07/19.
//

import Foundation
struct Message {
    let type: MessageType      //요구하는task(enum) -> 우선 조퇴랑 결석만
    let expectedDate: Date     //(->String)학부모가 요구하는(조퇴나 결석) 날짜
    let content: String        //메세지 내용
    let isCompleted: Bool      //task완료 여부(교사의 체크)
}

enum MessageType {
    case absent
    case earlyLeave
}
