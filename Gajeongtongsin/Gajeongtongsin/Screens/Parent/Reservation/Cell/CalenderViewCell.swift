//
//  CalenderViewCell.swift
//  Gajeongtongsin
//
//  Created by Beone on 2022/07/19.
//

import UIKit

class CalenderViewCell: BaseCalenderViewCell {

    static let identifier = "CalenderViewCell"

//MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(corder:) has not been implemented")
    }
    
//MARK: -
    
    
    
    
// MARK: - Funcs
    
    override func render() {
        // Override Layout
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = .init(gray: 255, alpha: 255)
    }
    
    override func configUI() {
        // Override ConfigUI
        self.backgroundColor = .gray
    }
}
