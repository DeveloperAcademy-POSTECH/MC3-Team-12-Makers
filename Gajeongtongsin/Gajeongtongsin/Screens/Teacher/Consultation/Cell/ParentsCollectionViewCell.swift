//
//  CalenderViewCell.swift
//  Gajeongtongsin
//
//  Created by Beone on 2022/07/19.
//

import UIKit

class ParentsCollectionViewCell: BaseCollectionViewCell {
    

    static let identifier = "ParentsCollectionViewCell"
    var delegate: ParentsCollcetionViewCellDelegate?
    
    private let messageInfo: UILabel = {
       let messageInfo = UILabel()
        messageInfo.translatesAutoresizingMaskIntoConstraints = false
        messageInfo.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        messageInfo.textColor = UIColor.black
        return messageInfo
    }()
    
    private let content: UILabel = {
       let content = UILabel()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        content.textColor = UIColor.black
        return content
    }()
    
    private let seeContent: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .lightGray
        button.setTitle("용건보기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
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
        contentView.addSubview(messageInfo)
        messageInfo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28).isActive = true
        messageInfo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        
        contentView.addSubview(seeContent)
        seeContent.topAnchor.constraint(equalTo: messageInfo.bottomAnchor, constant: 10).isActive = true
        seeContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        seeContent.addTarget(self, action: #selector(seeContentOnTapButton), for: .touchUpInside)
        
    }
    
    @objc func seeContentOnTapButton() {
        delegate?.present(message: content.text!)
    }
    
    
    override func configUI() {
        // Override ConfigUI
        self.backgroundColor = .gray
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = .init(gray: 255, alpha: 255)
    }
    
    func configure(childName: String, schedule: Schedule) {
        
        var dateAndTime: String {
            var dateAndTime: String = ""
            var specificSchedule: String = ""
            
            schedule.scheduleList.forEach {
                specificSchedule = $0.consultingDate+", "+$0.startTime
                dateAndTime += " | "+specificSchedule
            }
            return dateAndTime
        }
        
        messageInfo.text = "\(childName)"
        content.text = "\(schedule.content)"
        
    }
}
