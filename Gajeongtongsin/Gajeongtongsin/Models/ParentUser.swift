//
//  ParentUser.swift
//  Gajeongtongsin
//
//  Created by uiskim on 2022/07/19.
//

import Foundation

struct ParentUser : Codable{
    let id: String                    //유저아이디
    var sendingMessages: [Message]    //보내는문자
    let childName: String             //자녀이름
    var schedules: [Schedule]         //상담일정
    var teacherId: String = "19DD4C"
    
    func getMessagesWithChildName() -> [(childName: String, message: Message)] {
        return sendingMessages.map({(childName, $0)})
    }
}
