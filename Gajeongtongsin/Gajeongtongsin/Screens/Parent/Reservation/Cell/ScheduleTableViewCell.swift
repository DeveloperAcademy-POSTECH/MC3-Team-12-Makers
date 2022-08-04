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
    }
    
    override func configUI() {
        self.backgroundColor = .Background

    }
    
    func printSchedule(_ appointment:Schedule) {
        var text = ""
        for i in 0..<appointment.scheduleList.count {
            text.append(appointment.scheduleList[i].consultingDate + " " + appointment.scheduleList[i].startTime + "\n")
        }
        scheduleInfo.text = text
    }


    func configure(_ row: Int,_ schedule: Schedule){
        scheduleInfo.text = "예약 \(row + 1)"
        for scheduleInfo in schedule.scheduleList {
            if scheduleInfo.isReserved {
                statusIndicator.setTitle("확정", for: .normal)
                statusIndicator.changeState(buttonState: .disabled)
                printSchedule(schedule)
                break
            }
        }
    }
}
