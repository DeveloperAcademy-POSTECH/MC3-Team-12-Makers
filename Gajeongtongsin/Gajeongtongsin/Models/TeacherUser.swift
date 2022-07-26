//
//  TeacherUser.swift
//  Gajeongtongsin
//
//  Created by uiskim on 2022/07/19.
//

import Foundation
struct TeacherUser {
    let teacherName: String             //교사이름
    let parentUserIds: [ParentUser]     //교사가 담당해야할 학부모 ->파베할떈 String
    //let parentUsers: [ParentUser]     //이게 맞지 않나...?
    let notificationList: [Notification]
}
