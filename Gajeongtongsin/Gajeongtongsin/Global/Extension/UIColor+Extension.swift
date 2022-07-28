//
//  Color+Extension.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

extension UIColor {
    
    static var primaryBackground: UIColor {
        return UIColor(hex: "#F5F5F5")
    }
    static var borderGray: UIColor {
        return UIColor(hex: "#E5E5EA")
    }
    
    static var emergencyAlertColor: UIColor {
        return UIColor(hex: "#AD3E3E")
    }
    
    static var normalAlertColor: UIColor {
        return UIColor(hex: "#F0E5CF")
    }
    
    static var alertInfoGary: UIColor {
        return UIColor(hex: "#5F5E61")
    }
   
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")

        guard let date = dateFormatter.date(from: self) else {return nil}
        return date
    }
}
