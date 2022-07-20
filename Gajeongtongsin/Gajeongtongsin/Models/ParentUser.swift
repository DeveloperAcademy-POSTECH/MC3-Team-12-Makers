//
//  ParentUser.swift
//  Gajeongtongsin
//
//  Created by uiskim on 2022/07/19.
//

import Foundation

struct ParentUser {
    let id: String                    //유저아이디
    let sendingMessages: [Message]    //보내는문자
    let childName: String             //자녀이름
    let schedules: [Schedule]         //상담일정
}
