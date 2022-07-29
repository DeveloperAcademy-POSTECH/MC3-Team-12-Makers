//
//  Color+Extension.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

extension UIColor {
    
    static var Background: UIColor {
        .load(name: "Background")
    }
    static var Action: UIColor {
        .load(name: "Action")
    }
    static var Urgent: UIColor {
        .load(name: "Urgent")
    }
    static var Confirm: UIColor {
        .load(name: "Confirm")
    }
    static var LightLine: UIColor {
        .load(name: "LightLine")
    }
    static var DarkLine: UIColor {
        .load(name: "DarkLine")
    }
    static var LightText: UIColor {
        .load(name: "LightText")
    }
    static var DarkText: UIColor {
        .load(name: "DarkText")
    }
    

}


extension UIColor {
    static func load(name: String) -> UIColor {
        guard let color = UIColor(named: name) else {
            assert(false, "\(name) 컬러 로드 실패")
            return UIColor()
        }
        return color
    }
}
