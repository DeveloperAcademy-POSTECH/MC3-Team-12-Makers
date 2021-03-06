//
//  SentMessageTableViewCell.swift
//  Gajeongtongsin
//
//  Created by Youngwoong Choi on 2022/07/23.
//

import UIKit

class sentMessageTableViewCell: BaseTableViewCell {
    
    //MARK: - Properties
    static let identifier = "SentMessageTableViewCell"
    
    var currentParent: ParentUser {
        return mainTeacher.parentUserIds[0]
    }
    
    let messageInfo: UILabel = {
       let messageInfo = UILabel()
        messageInfo.translatesAutoresizingMaskIntoConstraints = false
        messageInfo.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        messageInfo.textColor = UIColor.black
        return messageInfo
    }()

    let content: UILabel = {
       let content = UILabel()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        content.textColor = UIColor.black
        return content
    }()
    
    private let checkIndicator: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Funcs
    override func render() {
        contentView.addSubview(messageInfo)
        messageInfo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28).isActive = true
        messageInfo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true

        contentView.addSubview(content)
        content.topAnchor.constraint(equalTo: messageInfo.bottomAnchor, constant: 10).isActive = true
        content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true

        contentView.addSubview(checkIndicator)
        checkIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        checkIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
    }
    
    override func configUI() {
        checkIndicator.image = UIImage(systemName: "checkmark.square")
        
        
    }
    
    
    
    func configure(index: Int) {
        
        func msgType() -> String {
            switch currentParent.sendingMessages[index].type {
                case .absence : return "??????"
                case .earlyLeave : return "??????"
            case .emergency: return ""
            }
        }
        
        messageInfo.text = "\(currentParent.childName) / \(msgType()) / \(currentParent.sendingMessages[index].expectedDate)"
        
        content.text = "\(currentParent.sendingMessages[index].content)"
    }
//    func cellTextMap(parent: ParentUser, message: Message) {
//        messageInfo.text = "\(parent.childName) / \(message.type) / \(message.expectedDate)"
//        content.text = "\(message.content)"
//    }
}

