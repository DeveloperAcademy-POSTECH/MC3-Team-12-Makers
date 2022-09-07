//
//  TeacherUser.swift
//  Gajeongtongsin
//
//  Created by uiskim on 2022/07/19.
//

import Foundation
struct TeacherUser {
    let teacherName: String                //교사이름
    var parentUsers: [ParentUser]          //교사가 담당해야할 학부모 ->파베할떈 String
    let notificationList: [Notification]
    
    var token: String?                     //임시(옵셔널) : 긴급상담 요청시 로컬알람띄우기 위한 토큰
    var consultStartTime: String = "14시"
    var consultEndTime: String = "17시"
}
