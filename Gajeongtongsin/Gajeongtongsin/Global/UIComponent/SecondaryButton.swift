//
//  SecondaryButton.swift
//  Gajeongtongsin
//
//  Created by 부재원 on 2022/07/29.
//

import UIKit

class SecondaryButton: UIButton {
    
    // MARK: - Init
    init(buttonTitle: String, buttonState: ButtonState) {
        super.init(frame: CGRect(x: 0, y: 0, width: 1000, height: 50))
        
        self.setTitle(buttonTitle, for: .normal)  // 버튼 타이틀
        changeState(buttonState: buttonState)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Funcs
    func render() {
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        self.layer.cornerRadius = 10
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func changeState(buttonState: ButtonState) {
        switch buttonState {
        case .normal:
            self.setTitleColor(.white, for: .normal) //버튼 타이틀 색깔
            self.backgroundColor = .Action      // 버튼 배경화면 색깔
            self.isUserInteractionEnabled = true // disabled 상태였던 버튼을 normal로 바꾸는 동시에 클릭 가능하게 변경
        case .disabled:
            self.setTitleColor(.black, for: .normal) //버튼 타이틀 색깔
            self.backgroundColor = .Confirm      // 버튼 배경화면 색깔
            self.isUserInteractionEnabled = false // disabled 상태에서는 클릭 불가
        }
    }
    
}

