//
//  PrimaryButton.swift
//  Gajeongtongsin
//
//  Created by 부재원 on 2022/07/29.
//

import UIKit

class CustomButton: UIButton {
    
    init(buttonTitle: String,textColor : UIColor, backgroundColor: UIColor,textSize: CGFloat) {
        super.init(frame: .zero)
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.setTitle(buttonTitle, for: .normal)  // 버튼 타이틀
        self.layer.cornerRadius = 3              // 버튼 cornerRadius
        self.setTitleColor(.white, for: .normal) //버튼 타이틀 색깔
        self.backgroundColor = backgroundColor      // 버튼 배경화면 색깔
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
