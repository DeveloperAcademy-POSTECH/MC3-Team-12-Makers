//
//  ScheduleTableViewCell.swift
//  Gajeongtongsin
//
//  Created by Youngwoong Choi on 2022/07/26.
//

import UIKit

class ScheduleTableViewCell: BaseTableViewCell {
    
    //MARK: - Properties
    static let identifier = "ScheduleTableViewCell"
    
    var currentParent: ParentUser {
        return mainTeacher.parentUsers[0]
    }
    
    private let scheduleInfo: UILabel = {
        let scheduleInfo = UILabel()
        scheduleInfo.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        scheduleInfo.textColor = UIColor.black
        scheduleInfo.translatesAutoresizingMaskIntoConstraints = false
        return scheduleInfo
    }()
    
    private let content: UILabel = {
       let content = UILabel()
        content.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        content.textColor = UIColor.black
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()
    
    private let checkIndicator: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Funcs
    override func render() {
        contentView.addSubview(scheduleInfo)
        scheduleInfo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28).isActive = true
        scheduleInfo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true

//        contentView.addSubview(content)
//        content.topAnchor.constraint(equalTo: scheduleInfo.bottomAnchor, constant: 10).isActive = true
//        content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true

        contentView.addSubview(checkIndicator)
        checkIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        checkIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
    }
    
    override func configUI() {
        checkIndicator.image = UIImage(systemName: "questionmark.circle")
    }
    
    func configure(section: Int, row: Int) {
        
        
        var appointment: Schedule = currentParent.schedules[section]

        scheduleInfo.text = appointment.scheduleList[row].consultingDate + " " + appointment.scheduleList[row].startTime + " 상담"

        //예약내역 view 에서 사유를 띄울 시에 content 속성 사용 예정
        content.text = appointment.content
        
        //약속시간 중 첫 번째가 교사에 의해 확정되었다고 가정할 때 indicator 변화 확인하기 위한 시험 코드 (추후 삭제)
        appointment.scheduleList[0].isReserved = true
        
        //인디케이터 디자인 확정 후 변경
        guard appointment.scheduleList[row].isReserved == true else {return}
        checkIndicator.image = UIImage(systemName: "exclamationmark.circle")
    }
}
