//
//  CalenderViewCell.swift
//  Gajeongtongsin
//
//  Created by Beone on 2022/07/19.
//

import UIKit

class CalenderViewCell: BaseCollectionViewCell {

    static let identifier = "CalenderViewCell"
//    var delegate: CalenderViewCellDelegate?
    private var isClicked: Bool = false

    private let acceptLable: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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
        contentView.addSubview(acceptLable)
            acceptLable.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            acceptLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    override func configUI() {
        // Override ConfigUI
        contentView.layer.borderWidth = 0.7
        contentView.layer.borderColor = UIColor.LightLine.cgColor
    }
    
    func getClick(clicked: Bool) {
        if clicked {
            acceptLable.text = "확정하기"
        } else {
            acceptLable.text = ""
        }
        
    }
}
