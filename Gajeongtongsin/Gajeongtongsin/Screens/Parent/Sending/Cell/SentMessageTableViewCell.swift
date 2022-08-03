//
//  SentMessageTableViewCell.swift
//  Gajeongtongsin
//
//  Created by Youngwoong Choi on 2022/07/23.
//

import UIKit

class SentMessageTableViewCell: BaseTableViewCell {
    
    //MARK: - Properties
    static let identifier = "SentMessageTableViewCell"
    
    var currentParent: ParentUser {
        return mainTeacher.parentUsers[0]
    }
    
    private let childName = UserDefaults.standard.string(forKey: "ChildName") ?? ""
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
    
    private var statusIndicator: SecondaryButton = {
        let btn = SecondaryButton(buttonTitle: "처리대기", buttonState: .normal)
        return btn
    }()
    
    //MARK: - Funcs
    override func render() {
        contentView.addSubview(messageInfo)
        messageInfo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28).isActive = true
        messageInfo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true

        contentView.addSubview(content)
        content.topAnchor.constraint(equalTo: messageInfo.bottomAnchor, constant: 10).isActive = true
        content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true

        contentView.addSubview(statusIndicator)
        statusIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        statusIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
    }
    
    override func configUI() {
        self.backgroundColor = .Background
    }
    
    func configure(message: Message){    
        messageInfo.text = "\(childName) / \(message.type.rawValue) / \(message.expectedDate)"
        content.text = "\(message.content)"
        
//    func configure(index: Int) {
        
//        func msgType() -> String {
//            switch currentParent.sendingMessages[index].type {
//            case .absence : return "결석"
//            case .earlyLeave : return "조퇴"
//            }
//        }
//        
//        messageInfo.text = "\(currentParent.childName) / \(msgType()) / \(currentParent.sendingMessages[index].expectedDate)"
//        
//        content.text = "\(currentParent.sendingMessages[index].content)"
        
        //완료 여부 알려주는 인디케이터
        guard message.isCompleted == true else {return} 
        statusIndicator.setTitle("처리완료", for: .normal)
        statusIndicator.changeState(buttonState: .disabled)
    }
}
