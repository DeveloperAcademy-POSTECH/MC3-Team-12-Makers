//
//  NotificationTableViewCell.swift
//  Gajeongtongsin
//
//  Created by uiskim on 2022/07/24.
//
import UIKit

class NotificationTableViewCell: BaseTableViewCell {
    
    
    // MARK: - Properties
    static let identifier: String = "NotificationTableViewCell"
    
    private let messageInfo: UILabel = {
       let messageInfo = UILabel()
        messageInfo.translatesAutoresizingMaskIntoConstraints = false
        messageInfo.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        return messageInfo
    }()
    
    private let senderName: UILabel = {
       let senderName = UILabel()
        senderName.translatesAutoresizingMaskIntoConstraints = false
        senderName.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        senderName.textColor = UIColor.black
        return senderName
    }()
    
    private let sendingTime: UILabel = {
       let sendingTime = UILabel()
        sendingTime.translatesAutoresizingMaskIntoConstraints = false
        sendingTime.font = UIFont.systemFont(ofSize: 12, weight: .light)
        sendingTime.textColor = UIColor.black
        return sendingTime
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Funcs
    override func render() {
        contentView.addSubview(messageInfo)
        messageInfo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        messageInfo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        
        contentView.addSubview(senderName)
        senderName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 41).isActive = true
        senderName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        
        contentView.addSubview(sendingTime)
        sendingTime.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 66).isActive = true
        sendingTime.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
    }
    
    func configure(childName: String, message: Message) {
        switch message.type {
        case .emergency :
            messageInfo.text = "?????? ?????? ???????????????. ?????? ?????? ?????? ??????????????? ???????????????!"
            messageInfo.textColor = .red
        case .absence:
            messageInfo.text = "???????????? ?????? ???????????????."
            messageInfo.textColor = .gray
        case .earlyLeave:
            messageInfo.text = "????????? ??????????????????."
            messageInfo.textColor = .gray
        }
        
        senderName.text = "\(childName) ????????????"
        sendingTime.text = "5?????????"
    }

}
