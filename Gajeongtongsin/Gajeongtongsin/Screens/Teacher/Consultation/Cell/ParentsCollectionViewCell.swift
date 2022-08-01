//
//  CalenderViewCell.swift
//  Gajeongtongsin
//
//  Created by Beone on 2022/07/19.
//

import UIKit

class ParentsCollectionViewCell: BaseCollectionViewCell {
    

    static let identifier = "ParentsCollectionViewCell"
    var newData: [TeacherCalenderData] = []
    var delegate: ParentsCollcetionViewCellDelegate?
    
    private let messageInfo: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "OOO 학부모님"
        label.textColor = .black
        return label
    }()
    
    private let content: UILabel = {
       let content = UILabel()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        content.textColor = UIColor.black
        return content
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

//MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(corder:) has not been implemented")
    }
    
// MARK: - Funcs
    
    override func render() {
        
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
        
        contentView.addSubview(messageInfo)
        messageInfo.translatesAutoresizingMaskIntoConstraints = false
        messageInfo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        messageInfo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        ContentButton.addTarget(self, action: #selector(contentOnTapButton), for: .touchUpInside)
        ScheduleButton.addTarget(self, action: #selector(scheduleOnTapButton), for: .touchUpInside)
    }
    
    @objc func contentOnTapButton() {
        delegate?.present(message: content.text!)
    }
    
    @objc func scheduleOnTapButton() {
        delegate?.drowDisplayData(cellSchedulData: newData)
    }
    
    override func configUI() {
        
        contentView.backgroundColor = .Background
        contentView.layer.cornerRadius = 10
//        contentView.frame.size = CGSize(width:140, height:150)
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowOpacity = 0.16
        contentView.layer.shadowRadius = 4.0
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
    
    func sendDataToCell(displayData: [TeacherCalenderData]) {

        newData = displayData
    }
}
