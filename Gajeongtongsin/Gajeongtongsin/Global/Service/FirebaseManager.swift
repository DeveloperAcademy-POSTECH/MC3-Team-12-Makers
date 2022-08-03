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
    
    /// 초기 교사 정보 업로드하기 for 선생님
    func initializeTeacher() {
        guard let teacherUid = UserDefaults.standard.string(forKey: "TeacherUser") else {return}
        
        let data : [String: Any] = [
            "id": teacherUid]
        
        db.child("TeacherUsers/\(teacherUid)")
            .setValue(data)
    }
    
    /// 초기 학부모 정보 업로드하기 for 학부모
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
    
    /// 학부모 예약 업로드 for 학부모
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
        
        let scheduleDB = db.child("TeacherUsers/\(homeroomTeacherUid)/parentUsers/\(parentUid)/schedules/").childByAutoId()
        
        let data : [String: Any] = [
            "id": parentUid,
            "scheduleId": scheduleDB.key!,
            "reservedDate": schedule.reservedDate ,
            "content": schedule.content,
            "scheduleList": scheduleInfoCollection,
            
        ]
        
        scheduleDB.setValue(data)
    }
    
    /// 학부모 메시지 업로드하기 for 학부모
    func uploadMessage(message: Message){
        guard let homeroomTeacherUid = UserDefaults.standard.string(forKey: "HomeroomTeacher") else {return}
        guard let parentUid = UserDefaults.standard.string(forKey: "ParentUser") else {return}
        
        let data : [String: Any] = [
            "id": parentUid,
            "type": message.type.rawValue,
            "sentDate": message.sentDate,
            "expectedDate": message.expectedDate,
            "content": message.content,
            "isCompleted": message.isCompleted
        ]
        
        db.child("TeacherUsers/\(homeroomTeacherUid)/parentUsers/\(parentUid)/sendingMessages").childByAutoId()
            .updateChildValues(data)
        
    }
    
    /// 메시지 처리완료 업로드하기 for 선생님
    func uploadMessageComplete(message: Message?) {
        guard let teacherUserId = UserDefaults.standard.string(forKey: "TeacherUser") else {return}
        guard let message = message else {return}
        db.child("TeacherUsers/\(teacherUserId)/parentUsers/\(message.id ?? "")/sendingMessages/\(message.msgId ?? "")")
            
        
            .updateChildValues(["isCompleted" : message.isCompleted]){ error, _ in
                                if let error = error {
                                    print("Error writing user document: \(error)")
                                } else {
                                    print("User document successfsiully written!")
                                }
                            }

    }
    
    /// 알림 업로드하기 for 학부모
    func uploadNotification(notification: Notification){
        guard let homeroomTeacherUid = UserDefaults.standard.string(forKey: "HomeroomTeacher") else {return}
        
        let data: [String: Any] = [
            "id" : notification.id,
            "postId" : notification.postId,   // FIXME: - 꼭 필요한가?
            "type" : notification.type.rawValue,
            "childName" : notification.childName,
            "content" : notification.content,
            "time" : notification.time // 수정 필요
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
    func uploadConfirmedReservation(childName: String,reservedSchedule: Schedule?,selectedIndex: Int){
        guard let teacherUid = UserDefaults.standard.string(forKey: "TeacherUser") else {return}
        guard let reservedSchedule = reservedSchedule else { return }

        var scheduleInfoCollection : [[String : Any]] = []
        
        for scheduleInfo in reservedSchedule.scheduleList {
            let scheduleInfoData : [String: Any] = [
                "consultingDate": scheduleInfo.consultingDate,
                "startTime" : scheduleInfo.startTime,
                "isReserved" : scheduleInfo.isReserved ]
            
            scheduleInfoCollection.append(scheduleInfoData)
        }
        
        db.child("TeacherUsers/\(teacherUid)/parentUsers/\(reservedSchedule.id!)/schedules/\(reservedSchedule.scheduleId!)/scheduleList")
            .setValue(scheduleInfoCollection)
        
//        db.child("TeacherUsers/\(teacherUid)/parentUsers/\(reservedSchedule.id!)/schedules/\(reservedSchedule.scheduleId!)/scheduleList/\(selectedIndex)")
//            .updateChildValues(["isReserved":reservedSchedule.scheduleList[0].isReserved])


    }
    
    // 파이어베이스가져오기 함수
    
    /// 학부모 여러명의 예약정보들 가져오기 for 선생님
    func fetchParentsReservations(completion: @escaping (([String:[Schedule]]?) -> Void)) {
        
        guard let teacherUserId = UserDefaults.standard.string(forKey: "TeacherUser") else {return}
        
        var allSchedules: [String:[Schedule]] = [:]
        
        db.child("TeacherUsers/\(teacherUserId)/parentUsers")
            .observe(.value) { snapshot in
                guard let parents = snapshot.value as? [String: [String:Any]] else {completion(nil); return}  // [오토키1 : ["키1":"값1", "키2":"값2", 등등], 오토키2 : ~]
                print(parents)
                for parent in parents.values {            //  ["키1":"값1", "키2":"값2",등등    ]
                    
                    guard let childName = parent["childName"] as? String else { completion(nil);return }
                    guard let schedules = parent["schedules"] as? [String: [String:Any]] else { completion(nil); return }// [메시지오토키 : ["키1":"값1", "키2":"값2", 등등   ]]
                    print(schedules)
                    var parentSchedules: [Schedule] = []

                    for key in schedules.keys {
                        do {
                            let scheduleData = try JSONSerialization.data(withJSONObject: schedules[key]!, options: [])
                            let decoder = JSONDecoder()
                            let schedule = try decoder.decode(Schedule.self, from: scheduleData)
                            parentSchedules.append(schedule)
                        } catch let DecodingError.dataCorrupted(context) {
                            print(context)
                            completion(nil)
                        } catch let DecodingError.keyNotFound(key, context) {
                            print("Key '\(key)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                            completion(nil)
                        } catch let DecodingError.valueNotFound(value, context) {
                            print("Value '\(value)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                            completion(nil)
                        } catch let DecodingError.typeMismatch(type, context) {
                            print("Type '\(type)' mismatch:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                            completion(nil)
                        } catch {
                            print("error: ", error)
                            completion(nil)
                        }
                    }
                    allSchedules[childName] = parentSchedules

                }
                completion(allSchedules)

            }
    }
    /// 학부모 1명의 예약정보 가져오기 for 학부모
    func fetchParentReservations(completion: @escaping (([Schedule]?) -> Void)) {
        guard let homeroomTeacherUid = UserDefaults.standard.string(forKey: "HomeroomTeacher") else {completion(nil) ; return}
        guard let parentUid = UserDefaults.standard.string(forKey: "ParentUser") else { completion(nil) ; return}
        
        db.child("TeacherUsers/\(homeroomTeacherUid)/parentUsers/\(parentUid)")
            .observe(.value) { snapshot in
                var scheduleList: [Schedule] = []
                guard let dic = snapshot.value as? NSDictionary else { completion(nil) ;return }
                
                
                guard let schedules = dic["schedules"] as? [String:[String:Any]] else { completion(nil); return }   // [오토키 : ["키1":"값1", "키2":"값2", 등등   ]]
                
                for scheduleVal in schedules.values {
                    
                    do {
                        let scheduleData = try JSONSerialization.data(withJSONObject: scheduleVal, options: [])
                        let decoder = JSONDecoder()
                        let schedule = try decoder.decode(Schedule.self, from: scheduleData)
                        
                        scheduleList.append(schedule)
                    } catch let DecodingError.dataCorrupted(context) {
                        print(context)
                        completion(nil)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        completion(nil)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        completion(nil)
                    } catch let DecodingError.typeMismatch(type, context) {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        completion(nil)
                    } catch {
                        print("error: ", error)
                        completion(nil)
                    }
                }
                completion(scheduleList)
            }
        
    }
    
    
    
    
    /// 학부모 여러명의 메시지들 가져오기 for 선생님
    func fetchParentsMessages(completion: @escaping (([(String,Message)]?) -> Void)) {
        guard let teacherUserId = UserDefaults.standard.string(forKey: "TeacherUser") else { completion(nil); return}
        
        var allMessages: [(String,Message)] = []
        
        db.child("TeacherUsers/\(teacherUserId)/parentUsers")
            .observe(.value) { snapshot in
                allMessages = []
                guard let parents = snapshot.value as? [String: [String:Any]] else { completion(nil); return }  // [오토키1 : ["키1":"값1", "키2":"값2", 등등], 오토키2 : ~]
                 for parent in parents.values {            //  ["키1":"값1", "키2":"값2",등등    ]
 
                    var parentMessages: [(String,Message)] = []
                    guard let sendingMessasges = parent["sendingMessages"] as? [String: [String:Any]]  else { print("sendingMessageserror"); completion(nil); return }// [메시지오토키 : ["키1":"값1", "키2":"값2", 등등   ]]
                    guard let childName = parent["childName"] as? String else { print("childNameerror");completion(nil); return }
                    for messageKey in sendingMessasges.keys {
                        
                        do {
                            
                            let messageData = try JSONSerialization.data(withJSONObject: sendingMessasges[messageKey]!, options: []) // FIXME: - 강제 언래핑
                            let decoder = JSONDecoder()
                            var message = try decoder.decode(Message.self, from: messageData)
                            message.msgId = messageKey // FIXME: - 임시방편. id를 저장하는 완전한 로직 필요.
                            parentMessages.append((childName,message))
                        } catch let DecodingError.dataCorrupted(context) {
                            print(context)
                            completion(nil);
                        } catch let DecodingError.keyNotFound(key, context) {
                            print("Key '\(key)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                            completion(nil);

                        } catch let DecodingError.valueNotFound(value, context) {
                            print("Value '\(value)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                            completion(nil);

                        } catch let DecodingError.typeMismatch(type, context) {
                            print("Type '\(type)' mismatch:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                            completion(nil);

                        } catch {
                            print("error: ", error)
                            completion(nil);

                        }
                    }
                    allMessages += parentMessages
                     
                }
                    completion(allMessages)
            }
    }
    /// 학부모 1명의 메시지들 가져오기 for 학부모
    func fetchParentMessages(completion: @escaping (([Message]?) -> Void)) {
        
        guard let homeroomTeacherUid = UserDefaults.standard.string(forKey: "HomeroomTeacher") else {completion(nil); return}
        guard let parentUid = UserDefaults.standard.string(forKey: "ParentUser") else {completion(nil); return}
        
        var messageList: [Message] = []
        db.child("TeacherUsers/\(homeroomTeacherUid)/parentUsers/\(parentUid)")
            .observe(.value) { snapshot in
                messageList = []
                guard let dic = snapshot.value as? NSDictionary else { completion(nil); return }
                
                guard let messages = dic["sendingMessages"] as? [String:[String:Any]] else {completion(nil); return } // [오토키 : ["키1":"값1", "키2":"값2", 등등   ]]
                
                for messageVal in messages.values {
                    
                    do {
                        let messageData = try JSONSerialization.data(withJSONObject: messageVal, options: [])
                        let decoder = JSONDecoder()
                        let message = try decoder.decode(Message.self, from: messageData)
                        messageList.append(message)
                    } catch let DecodingError.dataCorrupted(context) {
                        completion(nil);
                        print(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        completion(nil);
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        completion(nil);
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context) {
                        completion(nil);
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        completion(nil);
                        print("error: ", error)
                    }
                }
                completion(messageList)
            }
    }
    
    /// 알림들 가져오기 for 선생님
    func fetchNotifications(completion: @escaping ([Notification]?)->Void)   {
        
        guard let teacherUserId = UserDefaults.standard.string(forKey: "TeacherUser") else { completion(nil); return }
        var notificationsList: [Notification] = []
        db.child("Notifications/\(teacherUserId)/notificationList")
            .observe(.value) { snapshot in
                
                guard let notifications = snapshot.value as? [String: [String:Any]] else{ completion(nil); return } // [오토키 : ["키1":"값1", "키2":"값2", 등등   ]]
                
                
                for notificationVal in notifications.values {
                    do {
                        let notificationData = try JSONSerialization.data(withJSONObject: notificationVal, options: [])
                        let decoder = JSONDecoder()
                        let notification = try decoder.decode(Notification.self, from: notificationData)
                        notificationsList.append(notification)
                    } catch let DecodingError.dataCorrupted(context) {
                        print(context)
                        completion(nil)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        completion(nil)

                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        completion(nil)
                    } catch let DecodingError.typeMismatch(type, context) {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        completion(nil)

                    } catch {
                        print("error: ", error)
                        completion(nil)

                    }
                }
                completion(notificationsList)
            }

    }
    
}
