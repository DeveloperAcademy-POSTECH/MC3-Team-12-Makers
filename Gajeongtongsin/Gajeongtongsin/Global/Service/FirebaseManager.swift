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
    
    /// 초기 교사 정보 업로드하기
    func initializeTeacher() {
        guard let teacherUid = UserDefaults.standard.string(forKey: "TeacherUser") else {return}
        print(teacherUid)
        let data : [String: Any] = [
            "id": teacherUid]

        db.child("TeacherUsers/\(teacherUid)")
            .setValue(data) { error, _ in
                if let error = error {
                    print("Error writing user document: \(error)")
                } else {
                    print("User document successfsiully written!")
                }
            }
    }
    /// 초기 학부모 정보 업로드하기
    func initializeParent(teacherUid: String,childName: String) {
        guard let parentUid = UserDefaults.standard.string(forKey: "ParentUser") else {return}

        let data : [String: Any] = [
            "id": parentUid,
            "childName": childName]
    
        db.child("TeacherUsers/\(teacherUid)/parentUserIds/\(parentUid)")
            .setValue(data) { error, _ in
                if let error = error {
                    print("Error writing user document: \(error)")
                } else {
                    print("User document successfsiully written!")
                }
            }
    }
    
    /// 학부모 예약 업로드
    func uploadReservations(teacherUid: String,scheduleInfos: [ScheduleInfo]) {
        guard let parentUid = UserDefaults.standard.string(forKey: "ParentUser") else {return}
        
        var scheduleInfoCollection : [[String : Any]] = []

        for scheduleInfo in scheduleInfos {
            
            let scheduleInfoData : [String: Any] = [
                "consultingDate": scheduleInfo.consultingDate,
                "startTime" : scheduleInfo.startTime,
                "isReserved" : scheduleInfo.isReserved ?? false] // isReserved bool?이 아니라 string 0,1,2로 해야할듯.
            
            scheduleInfoCollection.append(scheduleInfoData)
           
        }
        let data : [String: Any] = [
            "reservedDate": "7월28일" , // Date -> String으로 바꿔야함.
            "content": "내용",
            "scheduleList": scheduleInfoCollection]
        
       
        
        let scheduleDB = db.child("TeacherUsers/\(teacherUid)/parentUserIds/\(parentUid)/schedules/").childByAutoId()
            print(scheduleDB)
            scheduleDB.setValue(data) { error, _ in
                if let error = error {
                    print("Error writing user document: \(error)")
                } else {
                    print("User document successfsiully written!")
                }
            }

    }
    /// 예약정보들 가져오기
    func fetchReservations() {
        
    }
    /// 학부모 메시지 업로드하기
    func uploadMessage(teacherUid:String, message: Message){
        guard let parentUid = UserDefaults.standard.string(forKey: "ParentUser") else {return}
        let data : [String: Any] = [
            "sendingMessages": message]
        
        db.child("TeacherUsers/\(teacherUid)/parentUserIds\(parentUid)")
            .updateChildValues(data)
        
    }
    /// 학부모,선생님 메시지들 가져오기
    func fetchMessages(){
        
    }
    /// 선생님 확정된 예약 업로드하기
    func uploadConfirmedReservation(){
        
    }
    // TODO: - 코드 안돌아감 수정필요함
    /// 알림 업로드하기
    func uploadNotification(teacherUid:String ,parentUserId: String, childName: String, content: String, type:NotificationType){ // FIXME: -  파라미터개수 줄이는 수정 필요

        let data: [String: Any] = [
            "id" : parentUserId,
            "postId" : "1",
            "type" : type.rawValue,
            "childName" : childName,
            "content" : content,
            "time" : "7월20일" // 수정 필요
        ]

        db.child("Notifications/\(teacherUid)").child("notificationList").childByAutoId()
            .setValue(data) { error, _ in
                if let error = error {
                    print("Error writing user document: \(error)")
                } else {
                    print("User document successfsiully written!")
                }
            }
    }
    /// 알림들 가져오기
    func fetchNotifications(){
        
    }
    
}
