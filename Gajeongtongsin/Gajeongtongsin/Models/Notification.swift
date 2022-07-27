//
//  Notification.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/19.
//

import Foundation



struct Notification: Codable {
    let id: String // 보낸사람 아이디
    let postId: String
    let type: NotificationType
    let childName: String
    let content: String
    //var time: Date? = Date() //    임시로 옵셔널 및 값 넣음.
    
}

enum NotificationType: Int, Codable {
    case emergency
    case reservation
    case message
    
    var notificationMessage: String {
        switch self {
        case .emergency:
            return "긴급 상담 요청입니다. 빠른 시간 내에 학부모님께 연락주세요!"
        case .reservation:
            return "전화상담 예약 요청입니다."
        case .message:
            return "쪽지가 도착했습니다."
        }
    }
    
}

