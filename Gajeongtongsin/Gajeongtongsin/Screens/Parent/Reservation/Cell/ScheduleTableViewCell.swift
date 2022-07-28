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
        return mainTeacher.parentUserIds[0]
    }
    
    private let scheduleInfo: UILabel = {
        let scheduleInfo = UILabel()
        scheduleInfo.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
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
    
    private let checkIndicator: UILabel = {
        let label = UILabel()
        label.text = "대기중"
        label.backgroundColor = .systemBlue
        label.frame.size = CGSize(width: 50, height: 20)
        label.layer.cornerRadius = 10
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Funcs
    override func render() {
        contentView.addSubview(scheduleInfo)
        scheduleInfo.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        scheduleInfo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true

//        contentView.addSubview(content)
//        content.topAnchor.constraint(equalTo: scheduleInfo.bottomAnchor, constant: 10).isActive = true
//        content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true

        contentView.addSubview(checkIndicator)
        checkIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        checkIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    override func configUI() {

    }
    
    func configure(index: IndexPath) {

        var appointment: Schedule = currentParent.schedules[index.row]
        
        scheduleInfo.text = "예약 \(index.row + 1)"
        
//        //약속시간 중 첫 번째가 교사에 의해 확정되었다고 가정할 때 indicator 변화 확인하기 위한 시험 코드 (추후 삭제)
//        appointment.scheduleList[0].isReserved = true
        
        //인디케이터 디자인 확정 후 변경
        guard appointment.scheduleList[index.row].isReserved == true else {return}
        checkIndicator.text = "확정"
    }
}
