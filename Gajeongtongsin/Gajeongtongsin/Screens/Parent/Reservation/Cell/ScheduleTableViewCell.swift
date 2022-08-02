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
    
    private var statusIndicator: SecondaryButton = {
        let btn = SecondaryButton(buttonTitle: "대기중", buttonState: .normal)
        return btn
    }()
    
    //MARK: - Funcs
    override func render() {
        contentView.addSubview(statusIndicator)
        statusIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        statusIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        statusIndicator.widthAnchor.constraint(equalToConstant: 70).isActive = true
        statusIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true

        
        contentView.addSubview(scheduleInfo)
        scheduleInfo.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        scheduleInfo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 100).isActive = true

//        contentView.addSubview(content)
//        content.topAnchor.constraint(equalTo: scheduleInfo.bottomAnchor, constant: 10).isActive = true
//        content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        

    }
    
    override func configUI() {

    }
    
    func configure(index: IndexPath) {

        let appointment: Schedule = currentParent.schedules[index.row]
        
        scheduleInfo.text = "예약 \(index.row + 1)"
        
//        //약속시간 중 첫 번째가 교사에 의해 확정되었다고 가정할 때 indicator 변화 확인하기 위한 시험 코드 (추후 삭제)
//        appointment.scheduleList[0].isReserved = true
        
        //인디케이터
       if appointment.scheduleList[index.row].isReserved {
           statusIndicator.setTitle("확정", for: .normal)
           statusIndicator.changeState(buttonState: .disabled)
        }
    }
}
