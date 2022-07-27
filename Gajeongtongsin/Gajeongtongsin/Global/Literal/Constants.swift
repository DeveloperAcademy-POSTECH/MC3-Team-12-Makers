//
//  Constants.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

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

// ParentsCalenderViewController 상수
let secondsInDay = 86400
let weekDays = 5


var todayOfTheWeek: Int{
    let formatter = DateFormatter()
    formatter.dateFormat = "e"    //e는 1~7(sun~sat)
    let day = formatter.string(from:Date())
    var interval = Int(day)
    if interval == 1 { interval = 8 }
    return interval!
}

