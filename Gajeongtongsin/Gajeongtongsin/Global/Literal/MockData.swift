//
//  MockData.swift
//  Gajeongtongsin
//
//  Created by uiskim on 2022/07/20.
//

import Foundation

var mainTeacher = TeacherUser(teacherName: "밀선생", parentUserIds: parentList)

var parentList: [ParentUser] = [parent1, parent2, parent3]
var parent1 = ParentUser(id: "1", sendingMessages: messageList1, childName: "김유쓰", schedules: scheduleList1)
var parent2 = ParentUser(id: "2", sendingMessages: messageList2, childName: "부니카", schedules: scheduleList2)
var parent3 = ParentUser(id: "3", sendingMessages: messageList3, childName: "최히로", schedules: scheduleList3)

var messageList1 = [
    Message(type: .absence, sentDate: Date(), expectedDate: "7월21일", content: "김유쓰배아픔", isCompleted: false),
    Message(type: .earlyLeave, sentDate: Date(), expectedDate: "7월22일", content: "김유쓰놀이공원", isCompleted: false),
    Message(type: .emergency, sentDate: Date(), expectedDate: "7월25일", content: "김유쓰실종", isCompleted: false)
]

var messageList2 = [
    Message(type: .absence, sentDate: Date(), expectedDate: "7월23일", content: "부니카제주도", isCompleted: false),
    Message(type: .earlyLeave, sentDate: Date(), expectedDate: "7월24일", content: "부니카서울", isCompleted: false),
    Message(type: .emergency, sentDate: Date(), expectedDate: "7월25일", content: "부니카1:10패싸움중(부니카가 1ㅋ)", isCompleted: false)
    ]

var messageList3 = [
    Message(type: .absence, sentDate: Date(), expectedDate: "7월25일", content: "최히로소개팅", isCompleted: false),
    Message(type: .earlyLeave, sentDate: Date(), expectedDate: "7월26일", content: "최히로레브랑데이트", isCompleted: false)
]

var scheduleList1 = [
    Schedule(reservedDate: "8월1일",
             scheduleList: [
                ScheduleInfo(consultingDate: "7월27일", startTime: "14시00분", isReserved: nil),
                ScheduleInfo(consultingDate: "7월27일", startTime: "14시30분", isReserved: nil),
                ScheduleInfo(consultingDate: "7월27일", startTime: "15시00분", isReserved: nil)],
             content: "김유쓰영어성적문의")
]

var scheduleList2 = [
    Schedule(reservedDate: "8월2일",
             scheduleList: [
                ScheduleInfo(consultingDate: "7월27일", startTime: "15시30분", isReserved: nil),
                ScheduleInfo(consultingDate: "7월26일", startTime: "16시00분", isReserved: nil),
                ScheduleInfo(consultingDate: "7월25일", startTime: "16시30분", isReserved: nil)],
             content: "부니카수학성적문의")
]

var scheduleList3 = [
    Schedule(reservedDate: "8월3일",
             scheduleList: [
                ScheduleInfo(consultingDate: "7월25일", startTime: "14시00분", isReserved: nil),
                ScheduleInfo(consultingDate: "7월26일", startTime: "15시30분", isReserved: nil),
                ScheduleInfo(consultingDate: "7월28일", startTime: "16시00분", isReserved: nil)],
             content: "최히로체육성적문의")
]
