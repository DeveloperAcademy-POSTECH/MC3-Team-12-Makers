//
//  MessageTableViewCell.swift
//  Gajeongtongsin
//
//  Created by uiskim on 2022/07/23.
//

import UIKit

class MessageTableViewCell: BaseTableViewCell {
    
    // MARK: - Properties
    private var isChecked: Bool = false {
        didSet {
            checkBox.tintColor = isChecked ? .red : .gray
        }
    }

    static let identifier = "ProfileTableViewCell"
    
    private let checkBox: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
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
        content.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
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
        messageInfo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28).isActive = true
        messageInfo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        
        contentView.addSubview(content)
        content.topAnchor.constraint(equalTo: messageInfo.bottomAnchor, constant: 10).isActive = true
        content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        
        contentView.addSubview(checkBox)
        checkBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        checkBox.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true

        
    }
    
    override func configUI() {
        checkBox.image = UIImage(systemName: "flame.fill")
        checkBox.tintColor = .gray

    }

    func configure(childName: String, message: Message) {
        messageInfo.text = "\(childName) / \(message.type.rawValue) / \(message.expectedDate)"
        content.text = "\(message.content)"

    }
    
    func aa(section: Int, row: Int) {
        let aa: MessagesWithChildName = sortedMessages[section]
        messageInfo.text = "\(aa[row].childName) / \(aa[row].message.type.rawValue) / \(aa[row].message.expectedDate)"
        content.text = "\(aa[row].message.content)"
    }
    
    func changeState() {
        self.isChecked.toggle()
        
    }
}
