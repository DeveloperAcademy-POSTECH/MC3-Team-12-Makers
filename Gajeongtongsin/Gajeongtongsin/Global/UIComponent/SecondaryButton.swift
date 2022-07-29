//
//  SecondaryButton.swift
//  Gajeongtongsin
//
//  Created by 부재원 on 2022/07/29.
//

import UIKit

class SecondaryButton: UIButton {
    
    init(buttonTitle: String, buttonState: ButtonState) {
        super.init(frame: CGRect(x: 0, y: 0, width: 1000, height: 50))
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.setTitle("SecondaryButton", for: .normal)
        self.layer.cornerRadius = 10
        switch buttonState {
        case.normal:
            self.setTitleColor(.white, for: .normal)
            self.backgroundColor = .Action
        case .disabled:
            self.setTitleColor(.Confirm, for: .normal)
            self.backgroundColor = .black
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

