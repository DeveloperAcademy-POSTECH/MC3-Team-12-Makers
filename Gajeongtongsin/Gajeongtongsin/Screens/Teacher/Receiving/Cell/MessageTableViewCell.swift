//
//  MessageTableViewCell.swift
//  Gajeongtongsin
//
//  Created by uiskim on 2022/07/23.
//

import UIKit

class MessageTableViewCell: BaseTableViewCell {
    
    // MARK: - Properties
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                checkBox.backgroundColor = UIColor.Confirm
                stateLabel.text = "처리완료"
                stateLabel.textColor = UIColor.DarkText
            } else {
                checkBox.backgroundColor = UIColor.Action
                stateLabel.text = "처리하기"
                stateLabel.textColor = UIColor.white
            }
        }
    }
    private var msg: Message?

    static let identifier = "ProfileTableViewCell"
    
    private let checkBox: UIImageView = {
        let checkBox = UIImageView()
        checkBox.frame = CGRect(x: 274, y: 18, width: 100, height: 30)
        checkBox.backgroundColor = UIColor.Action
        checkBox.layer.cornerRadius = 10
        return checkBox
    }()
    
    private let stateLabel: UILabel = {
        let stateLabel = UILabel()
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.textAlignment = .center
        stateLabel.font = UIFont.systemFont(ofSize: 16)
        return stateLabel
    }()
    
    private let messageInfo: UILabel = {
       let messageInfo = UILabel()
        messageInfo.translatesAutoresizingMaskIntoConstraints = false
        messageInfo.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        messageInfo.textColor = UIColor.black
        return messageInfo
    }()
    
    private let content: UILabel = {
       let content = UILabel()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        content.textColor = UIColor.black
        return content
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
        messageInfo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9).isActive = true
        messageInfo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        
        contentView.addSubview(content)
        content.topAnchor.constraint(equalTo: messageInfo.bottomAnchor, constant: 10).isActive = true
        content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        
        checkBox.addSubview(stateLabel)
        stateLabel.centerXAnchor.constraint(equalTo: checkBox.centerXAnchor).isActive = true
        stateLabel.centerYAnchor.constraint(equalTo: checkBox.centerYAnchor).isActive = true
        
        contentView.addSubview(checkBox)
        
    }
    
    override func configUI() {
        stateLabel.text = "처리하기"
        stateLabel.textColor = .white
        contentView.backgroundColor = .Background
    }

    
//    func configure(indexPath: IndexPath) {
//        let message: MessagesWithChildName = sortedMessages[indexPath.section]
//        messageInfo.text = "\(message[indexPath.row].message.expectedDate) \(message[indexPath.row].message.type.rawValue) \(message[indexPath.row].childName)"
//        content.text = "\(message[indexPath.row].message.content)"
//    }
    func configure(childName: String, message:Message){
        
        msg = message
        guard let msg = msg else {return}
        
        messageInfo.text = "\(msg.expectedDate) \(msg.type.rawValue) \(childName)"
                content.text = "\(msg.content)"
        

        stateLabel.text = msg.isCompleted ? "처리완료" : "처리하기"
        stateLabel.textColor = msg.isCompleted ? .DarkText : .white
        checkBox.backgroundColor = msg.isCompleted ? .Confirm : .Action
        isChecked = msg.isCompleted
    }
    
    func changeState() {
        self.isChecked = true
        
    }
    
    func getMessage() -> Message? {
        return msg
    }
    
    func messageCompleted() {
        msg?.isCompleted = true
    }
}
