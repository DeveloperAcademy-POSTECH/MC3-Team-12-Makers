//
//  MockData.swift
//  Gajeongtongsin
//
//  Created by uiskim on 2022/07/20.
//

import Foundation

var mainTeacher = TeacherUser(teacherName: "밀선생", parentUsers: parentList, notificationList: notifications)

var parentList: [ParentUser] = [parent1, parent2, parent3, parent4]
var parent1 = ParentUser(id: "1", sendingMessages: messageList1, childName: "김유쓰", schedules: scheduleList1)
var parent2 = ParentUser(id: "2", sendingMessages: messageList2, childName: "부니카", schedules: scheduleList2)
var parent3 = ParentUser(id: "3", sendingMessages: messageList3, childName: "최히로", schedules: scheduleList3)
var parent4 = ParentUser(id: "4", sendingMessages: messageList3, childName: "허결결", schedules: scheduleList4)

var messageList1 = [
    Message(type: .absence, sentDate: "2022-03-01", expectedDate: "7월21일", content: "김유쓰배아픔", isCompleted: false),
    Message(type: .earlyLeave, sentDate: "2022-03-04", expectedDate: "7월22일", content: "김유쓰놀이공원", isCompleted: false),
    Message(type: .earlyLeave, sentDate: "2022-03-19", expectedDate: "7월28일", content: "김유쓰할머니댁", isCompleted: true)
]

var messageList2 = [
    Message(type: .absence, sentDate: "2022-03-04", expectedDate: "7월23일", content: "부니카제주도", isCompleted: false),
    Message(type: .earlyLeave, sentDate: "2022-03-07", expectedDate: "7월24일", content: "부니카서울", isCompleted: false),
    Message(type: .earlyLeave, sentDate: "2022-03-15", expectedDate: "7월24일", content: "부니카애플아카데미", isCompleted: false)
]

var messageList3 = [
    Message(type: .absence, sentDate: "2022-03-01", expectedDate: "7월25일", content: "최히로소개팅", isCompleted: false),
    Message(type: .earlyLeave, sentDate: "2022-03-07", expectedDate: "7월26일", content: "최히로레브랑데이트", isCompleted: false),
    Message(type: .earlyLeave, sentDate: "2022-03-15", expectedDate: "7월26일", content: "최히로번개만남", isCompleted: false)
]

var messageList4 = [
    Message(type: .absence, sentDate: "실시간", expectedDate: "7월25일", content: "최히로소개팅", isCompleted: false),
    Message(type: .earlyLeave, sentDate: "실시간", expectedDate: "7월26일", content: "최히로레브랑데이트", isCompleted: false)
]

var scheduleList1 = [
    Schedule(reservedDate: "8월1일",
             scheduleList: [
                ScheduleInfo(consultingDate: "8월01일", startTime: "14시00분", isReserved: true)],
             content: "김유쓰영어성적문의")
]

var scheduleList2 = [
    Schedule(reservedDate: "8월2일",
             scheduleList: [
                ScheduleInfo(consultingDate: "8월02일", startTime: "15시30분", isReserved: false),
                ScheduleInfo(consultingDate: "8월02일", startTime: "16시00분", isReserved: false),
                ScheduleInfo(consultingDate: "8월02일", startTime: "16시30분", isReserved: false)],
             content: "부니카수학성적문의")
]

var scheduleList3 = [
    Schedule(reservedDate: "8월3일",
             scheduleList: [
                ScheduleInfo(consultingDate: "8월03일", startTime: "14시00분", isReserved: false),
                ScheduleInfo(consultingDate: "8월03일", startTime: "15시30분", isReserved: false),
                ScheduleInfo(consultingDate: "8월03일", startTime: "16시00분", isReserved: false)],
             content: "최히로체육성적문의")
]
var notifications: [Notification] = []
//var notifications: [Notification] = [noti1, noti2, noti3, noti4, noti5, noti6, noti7, noti8, noti9, noti10, noti11]

var scheduleList4 = [
    Schedule(reservedDate: "8월3일",
             scheduleList: [
                ScheduleInfo(consultingDate: "8월04일", startTime: "14시00분", isReserved: false),
                ScheduleInfo(consultingDate: "8월04일", startTime: "15시30분", isReserved: false),
                ScheduleInfo(consultingDate: "8월04일", startTime: "16시00분", isReserved: false)],
             content: "허결출결문의제발")
]

//var notifications: [Notification] = [noti1, noti2, noti3, noti4, noti5, noti6, noti7, noti8, noti9, noti10, noti11]
//
//let noti1 = Notification(id: "1", postId: "11", type: .message, childName: "김유쓰", content: "11")
//let noti2 = Notification(id: "1", postId: "11", type: .message, childName: "김유쓰", content: "22")
//let noti3 = Notification(id: "1", postId: "11", type: .emergency, childName: "김유쓰", content: "아이가실종되었습니다")
//let noti4 = Notification(id: "1", postId: "11", type: .reservation, childName: "김유쓰", content: "44")
//
//let noti5 = Notification(id: "2", postId: "22", type: .message, childName: "부니카", content: "55")
//let noti6 = Notification(id: "2", postId: "22", type: .message, childName: "부니카", content: "66")
//let noti7 = Notification(id: "2", postId: "22", type: .emergency, childName: "부니카", content: "아이가깡패랑싸우고있습니다")
//let noti8 = Notification(id: "2", postId: "22", type: .reservation, childName: "부니카", content: "88")
//
//let noti9 = Notification(id: "3", postId: "33", type: .message, childName: "최히로", content: "99")
//let noti10 = Notification(id: "3", postId: "33", type: .message, childName: "최히로", content: "1010")
//let noti11 = Notification(id: "3", postId: "33", type: .reservation, childName: "최히로", content: "1111")
//
