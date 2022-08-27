//
//  Constants.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

struct Constants {
    // MARK: - Properties
    static let secondsInDay = 86400
    static let weekDays = 5
    static let MAX_LENGTH = 6     // 최대 글자수
    static let calenderTopPadding = CGFloat(200.0)
    static let calenderSidePadding = [CGFloat(50.0),CGFloat(20.0)]
    static let calenderHeigit = CGFloat(300.0)
    static let interval = CGFloat((UIScreen.main.bounds.width-(calenderSidePadding[0]+calenderSidePadding[1]))/5)
    static var todayOfTheWeek: Int{
        let formatter = DateFormatter()
        formatter.dateFormat = "e"    //e는 1~7(sun~sat)
        let day = formatter.string(from:Date())
        var interval = Int(day)
        if interval == 1 { interval = 8 }
        return interval!
    }
    
    // MARK: - Funcs
    static func hourLabelMaker() -> [UILabel] {
        var labelList: [UILabel] = []
        for hour in 14...17 {
            let label = UILabel()
            label.text = String(hour)+"h"
            label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            label.textColor = .darkText
            label.translatesAutoresizingMaskIntoConstraints = false
            labelList.append(label)
        }
        return labelList
    }
    //날자 레이블 메이커
    static func dateLabelMaker() -> [[UILabel]] {
        var labelList: [[UILabel]] = Array(repeating: [], count: 5)
        let formatter = DateFormatter()
        formatter.dateFormat = "d-EEE"
        
        for day in 0..<5 {
            let dayAdded = (86400 * (2+day-todayOfTheWeek+7))
            let oneDayString = formatter.string(from: Date(timeIntervalSinceNow: TimeInterval(dayAdded))).components(separatedBy: "-")
            oneDayString.forEach {
                let label = UILabel()
                label.text = $0
                label.translatesAutoresizingMaskIntoConstraints = false
                labelList[day].append(label)
            }
            labelList[day][0].font = UIFont.systemFont(ofSize: 18, weight: .regular)
            labelList[day][0].textColor = .darkText
            
            labelList[day][1].font = UIFont.systemFont(ofSize: 13, weight: .regular)
            labelList[day][1].textColor = .LightText
        }
        return labelList
    }
    
    //다음 일주일의 날짜 리스트를 저장하는 연산 프로퍼티, 아래의 dayIndex 함수에 사용함
    static var nextWeek: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월dd일"
        formatter.timeZone = TimeZone(identifier: "ko_KR")
        var nextWeek = [String]()
        for dayCount in 0..<Constants.weekDays {
            //let dayAdded = (86400 * (2+dayCount-todayOfTheWeek))
            //캘린더뷰가 다음주를 표시하는 경우 +7
            let dayAdded = (86400 * (2+dayCount-Constants.todayOfTheWeek + 7))
            let oneDayString = formatter.string(from: Date(timeIntervalSinceNow: TimeInterval(dayAdded)))
            nextWeek.append(oneDayString)
        }
        return nextWeek
    }
    
    //선택한 학부모의 신청 요일(날자)를 정수(인덱스) 리스트로 반환해주는 함수
    static func dateStringToIndex(selected parentSchedules : [Schedule]) -> [Int] {
        var dateString: [String] = []
        var dateIndex: [Int] = []
        parentSchedules[0].scheduleList.forEach{
            dateString.append($0.consultingDate)
        }
        for day in dateString.indices { //String을 Index로 바꿔줌
            for nextWeekDay in Constants.nextWeek.indices {
                if dateString[day] == Constants.nextWeek[nextWeekDay] {
                    dateIndex.append(nextWeekDay)
                }
            }
        }
        return dateIndex
    }
    //선택한 학부모의 신청 시간을 정수(인덱스) 리스트로 반환해주는 함수
    static func timeStringToIndex(selected parentSchedules: [Schedule]) -> [Int] {
        var startTime:[Int] = []
        parentSchedules[0].scheduleList.forEach{
            let timeList = $0.startTime.components(separatedBy: "시")  //[14, 00], [14, 30], [15, 00], ...
            let hour = Int(timeList[0])!-14 // 14, 14, 15, 15, 16, 16 ... -> 0, 0, 1, 1, 2, 2 ...
            let minute = Int(timeList[1].replacingOccurrences(of: "분", with: ""))!/30 // 00, 30, 00, 30 ... -> 0, 1, 0, 1, ...
            startTime.append(hour*2 + minute)
        }
        
        return startTime
    }
    
    static func dateIndexToString(index: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월dd일"
        formatter.timeZone = TimeZone(identifier: "ko_KR")
        let daysAfterToday = (2+(index % Constants.weekDays) - Constants.todayOfTheWeek+7) //+2는 dateFormat 보정(월요일이 2), +7은 다음주 캘린더가 표시되도록
        let consultingDateDate = Date(timeIntervalSinceNow: TimeInterval((Constants.secondsInDay * daysAfterToday)))
        let consultingDate = formatter.string(from: consultingDateDate)
        return consultingDate
    }
    
    static func timeIndexToString(index: Int) -> String {
        let rowInCalender = index / Constants.weekDays
        let hour = String(14 + (rowInCalender)/2) //14시 + @
        let minute: String = (rowInCalender) % 2 == 0 ? "00" : "30" //짝수줄은 정각, 홀수줄은 30분
        let startTime = hour+"시"+minute+"분"
        return startTime
    }
}

// MARK: - Enumerations
 // 탭 페이지
enum TabPage {
    case reservation
    case suggestion
    case profile
    
    var title: String {
        switch self {
        case .reservation:
            return "상담예약"
        case .suggestion:
            return "쪽지건의"
        case .profile:
            return "프로필"
        }
    }
    func getTabBarIcon() -> UIImage {
        let iconName: String
        
        switch self {
        case .reservation:
            iconName = "calendar"
        case .suggestion:
            iconName = "envelope"
        case .profile:
            iconName = "person.crop.circle"
        }
    
        return UIImage.load(systemName: iconName)
    }
}

 // 유저 Role
enum Role {
    case parent
    case teacher
}

// Button 활성화 여부
enum ButtonState {
    case normal
    case disabled
    
}



