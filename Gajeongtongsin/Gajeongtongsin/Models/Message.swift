//
//  Message.swift
//  Gajeongtongsin
//
//  Created by uiskim on 2022/07/19.
//

import Foundation
struct Message : Codable {
    var id: String? // 누가보냈는지.
    var msgId: String?
    let type: MessageType      //요구하는task(enum) -> 우선 조퇴랑 결석만
    let sentDate: String       //메세지 보내는 시간
    let expectedDate: String   //(->String)학부모가 요구하는(조퇴나 결석) 날짜
    let content: String        //메세지 내용
    var isCompleted: Bool      //task완료 여부(교사의 체크)
}

enum MessageType: String, Codable {
    case absence = "결석"
    case earlyLeave = "조퇴"
}

var messagesWithChildName = mainTeacher.parentUsers.flatMap({$0.getMessagesWithChildName()})
//var sortedMessages = chunkedMessages(messages: messagesWithChildName.sorted(by: {$0.message.sentDate > $1.message.sentDate}))
