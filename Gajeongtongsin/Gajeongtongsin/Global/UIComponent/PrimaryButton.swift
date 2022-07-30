//
//  PrimaryButton.swift
//  Gajeongtongsin
//
//  Created by 부재원 on 2022/07/29.
//

import UIKit

class PrimaryButton: UIButton {
    
    // MARK: - Init
    init(buttonTitle: String, buttonState: ButtonState) {
        super.init(frame: CGRect(x: 0, y: 0, width: 1000, height: 50))
        
        switch buttonState {
        case .normal:
            self.setTitleColor(.white, for: .normal) //버튼 타이틀 색깔
            self.backgroundColor = .Action      // 버튼 배경화면 색깔
        case .disabled:
            self.setTitleColor(.lightText, for: .normal) //버튼 타이틀 색깔
            self.backgroundColor = .LightLine      // 버튼 배경화면 색깔
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Funcs
    func render() {
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.setTitle("PrimaryButton", for: .normal)  // 버튼 타이틀
        self.layer.cornerRadius = 3// 버튼 cornerRadius
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 358).isActive = true
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
