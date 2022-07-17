//
//  BaseTableViewCell.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
