//
//  BaseCalenderViewCell.swift
//  Gajeongtongsin
//
//  Created by Beone on 2022/07/19.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell{

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Funcs
    
    func render() {
        // Override Layout
    }
    
    func configUI() {
        // Override ConfigUI
    }
}
