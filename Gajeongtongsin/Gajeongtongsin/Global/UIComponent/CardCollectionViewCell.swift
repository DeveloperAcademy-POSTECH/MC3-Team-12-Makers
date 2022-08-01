//
//  CardCollectionViewCell.swift
//  Gajeongtongsin
//
//  Created by 부재원 on 2022/07/29.
//

import UIKit

class CardCollectionViewCell: BaseCollectionViewCell {
    // MARK: - Properties
    static let identifier = "CustomCollectionViewCell"
    
    private let CardLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "OOO 학부모님"
        label.textColor = .black
        return label
    }()
    
    
    private let ScheduleButton: UIButton = {
        let button = UIButton()
        button.setTitle("예약일정", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.white, for: .normal )
        button.backgroundColor = .Action
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let ContentButton: UIButton = {
        let button = UIButton()
        button.setTitle("내용확인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.white, for: .normal )
        button.backgroundColor = .Action
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Funcs
    override func configUI() {
        contentView.backgroundColor = .Background
        contentView.layer.cornerRadius = 10
        contentView.frame.size = CGSize(width:140, height:150)
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowOpacity = 0.16
        contentView.layer.shadowRadius = 4.0
    }
    
    override func render(){
       
        contentView.addSubview(ScheduleButton)
        ScheduleButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 57).isActive = true
        ScheduleButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        ScheduleButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        ScheduleButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        contentView.addSubview(ContentButton)
        ContentButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18).isActive = true
        ContentButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        ContentButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        ContentButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        contentView.addSubview(CardLabel)
        CardLabel.translatesAutoresizingMaskIntoConstraints = false
        CardLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        CardLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true}
    
    func configure(buttonTitle:String) {
        ScheduleButton.setTitle(buttonTitle, for: .normal)
    }
}
