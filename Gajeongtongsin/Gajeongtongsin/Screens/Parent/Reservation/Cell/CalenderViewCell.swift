//
//  CalenderViewCell.swift
//  Gajeongtongsin
//
//  Created by Beone on 2022/07/19.
//

import UIKit

class CalenderViewCell: BaseCollectionViewCell {

    static let identifier = "CalenderViewCell"

//MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(corder:) has not been implemented")
    }
    
// MARK: - Funcs
    
    override func render() {
        // Override Layout
    }
    
    override func configUI() {
        // Override ConfigUI
//        self.backgroundColor = .gray
        contentView.layer.borderWidth = 0.7
        contentView.layer.borderColor = UIColor.LightLine.cgColor
    }
}
