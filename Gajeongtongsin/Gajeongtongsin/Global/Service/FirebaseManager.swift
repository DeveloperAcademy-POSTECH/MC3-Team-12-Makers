//
//  FirebaseManager.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseDatabase

final class FirebaseManager {
    // MARK: - Properties
    
    static let shared = FirebaseManager()
    private let db = Database.database().reference()
    // MARK: - Init
    private init() {
        
    }
    // MARK: - Funcs
    
    // 파이어베이스업로드 함수
    
    /// 초기 교사 정보 업로드하기
    func initializeTeacher() {
        guard let teacherUid = UserDefaults.standard.string(forKey: "TeacherUser") else {return}
        
        let data : [String: Any] = [
            "id": teacherUid]

        db.child("TeacherUsers/\(teacherUid)")
            .setValue(data)
    }
    
    /// 초기 학부모 정보 업로드하기
    func initializeParent() {
        guard let homeroomTeacherUid = UserDefaults.standard.string(forKey: "HomeroomTeacher") else {return}
        guard let childName = UserDefaults.standard.string(forKey: "ChildName") else {return}
        guard let parentUid = UserDefaults.standard.string(forKey: "ParentUser") else {return}

        let data : [String: Any] = [
            "id": parentUid,
            "childName": childName]
    
        db.child("TeacherUsers/\(homeroomTeacherUid)/parentUsers/\(parentUid)")
            .setValue(data)
    }
    
    /// 학부모 예약 업로드
    func uploadReservations(schedule: Schedule) {
        guard let homeroomTeacherUid = UserDefaults.standard.string(forKey: "HomeroomTeacher") else {return}
        guard let parentUid = UserDefaults.standard.string(forKey: "ParentUser") else {return}
        
        var scheduleInfoCollection : [[String : Any]] = []

        for scheduleInfo in schedule.scheduleList {
            let scheduleInfoData : [String: Any] = [
                "consultingDate": scheduleInfo.consultingDate,
                "startTime" : scheduleInfo.startTime,
                "isReserved" : scheduleInfo.isReserved ]
            
            scheduleInfoCollection.append(scheduleInfoData)
        }
        let data : [String: Any] = [
            "reservedDate": schedule.reservedDate ,
            "content": schedule.content,
            "scheduleList": scheduleInfoCollection]
        
        let scheduleDB = db.child("TeacherUsers/\(homeroomTeacherUid)/parentUsers/\(parentUid)/schedules/").childByAutoId()
            scheduleDB.setValue(data)
    }
    
    /// 학부모 메시지 업로드하기
    func uploadMessage(message: Message){
        guard let homeroomTeacherUid = UserDefaults.standard.string(forKey: "HomeroomTeacher") else {return}
        guard let parentUid = UserDefaults.standard.string(forKey: "ParentUser") else {return}
        
        let data : [String: Any] = [
            "type": message.type.rawValue,
            "sentDate": message.sentDate,
            "expectedDate": message.expectedDate,
            "content": message.content,
            "isCompleted": message.isCompleted
        ]
        
        db.child("TeacherUsers/\(homeroomTeacherUid)/parentUsers/\(parentUid)/sendingMessages").childByAutoId()
            .updateChildValues(data)
        
    }
    
    /// 알림 업로드하기
    func uploadNotification(notification: Notification){
        guard let homeroomTeacherUid = UserDefaults.standard.string(forKey: "HomeroomTeacher") else {return}
        
        let data: [String: Any] = [
            "id" : notification.id,
            "postId" : notification.postId,   // FIXME: - 꼭 필요한가?
            "type" : notification.type.rawValue,
            "childName" : notification.childName,
            "content" : notification.content,
            "time" : "7월20일" // 수정 필요
        ]

        db.child("Notifications/\(homeroomTeacherUid)").child("notificationList").childByAutoId()
            .setValue(data)
        
        //업로드과정에서 에러찾을때 사용하는 코드
//            { error, _ in
//                if let error = error {
//                    print("Error writing user document: \(error)")
//                } else {
//                    print("User document successfsiully written!")
//                }
//            }
    }
    
    /// 선생님 확정된 예약 업로드하기
    func uploadConfirmedReservation(){
        
    }
    
    // 파이어베이스가져오기 함수
    
    /// 예약정보들 가져오기
    func fetchReservations() {
        
    }
    /// 학부모,선생님 메시지들 가져오기
    func fetchMessages(){
        
    }
    
    /// 알림들 가져오기
    func fetchNotifications(){
        
    }
    
}
