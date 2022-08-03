////
////  MessageTableViewCell.swift
////  Gajeongtongsin
////
////  Created by uiskim on 2022/07/23.
////
//
//import UIKit
//
//class CalenderTableViewCell: BaseTableViewCell {
//    
//    // MARK: - Properties
//    static let identifier = "CalenderTableViewCell"
//    
//    private let messageInfo: UILabel = {
//       let messageInfo = UILabel()
//        messageInfo.translatesAutoresizingMaskIntoConstraints = false
//        messageInfo.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
//        messageInfo.textColor = UIColor.black
//        return messageInfo
//    }()
//    
//    private let content: UILabel = {
//       let content = UILabel()
//        content.translatesAutoresizingMaskIntoConstraints = false
//        content.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
//        content.textColor = UIColor.black
//        return content
//    }()
//    
//    // MARK: - Init
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Funcs
//    override func render() {
//        contentView.addSubview(messageInfo)
//        messageInfo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28).isActive = true
//        messageInfo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
//        
//        contentView.addSubview(content)
//        content.topAnchor.constraint(equalTo: messageInfo.bottomAnchor, constant: 10).isActive = true
//        content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
//        
//        self.layer.borderColor = UIColor.gray.cgColor
//    }
//
//    func configure(childName: String, schedule: Schedule) {
//        
//        var dateAndTime: String {
//            var dateAndTime: String = ""
//            var specificSchedule: String = ""
//            
//            schedule.scheduleList.forEach {
//                specificSchedule = $0.consultingDate+", "+$0.startTime
//                dateAndTime += " | "+specificSchedule
//            }
//            return dateAndTime
//        }
//        
//        messageInfo.text = "\(childName) / \(schedule.content)"
//        content.text = "\(dateAndTime)"
//        
//    }
//}
