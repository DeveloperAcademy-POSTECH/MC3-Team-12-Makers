//
//  ReservationDetailViewController.swift
//  Gajeongtongsin
//
//  Created by Youngwoong Choi on 2022/07/28.
//

import UIKit

class ReservationDetailViewController: BaseViewController {
    //MARK: - Properties

    //화면에 뿌려줄 메시지 리스트를 곧바로 'messageList#'으로 지정하지 않고, 부모 유저(여기선 parent1)에 속한 것으로 불러옴
    var currentParent: ParentUser {
        return mainTeacher.parentUsers[0]
    }

    private let scheduleTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scheduleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let scheduleCandidates: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let reasonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reasonContent: UITextView = {
        let content = UITextView()
        content.font = UIFont.systemFont(ofSize: 17)
        content.textColor = .black
        content.isScrollEnabled = true
        content.isEditable = false
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Funcs
    override func render() {
        view.addSubview(scheduleTitle)
        scheduleTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        scheduleTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        scheduleTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(scheduleLabel)
        scheduleLabel.topAnchor.constraint(equalTo: scheduleTitle.bottomAnchor, constant: 35).isActive = true
        scheduleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        scheduleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(scheduleCandidates)
        scheduleCandidates.topAnchor.constraint(equalTo: scheduleLabel.bottomAnchor, constant: 20).isActive = true
        scheduleCandidates.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        scheduleCandidates.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(reasonLabel)
        reasonLabel.topAnchor.constraint(equalTo: scheduleCandidates.bottomAnchor, constant: 30).isActive = true
        reasonLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        reasonLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(reasonContent)
        reasonContent.topAnchor.constraint(equalTo: reasonLabel.bottomAnchor, constant: 20).isActive = true
        reasonContent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        reasonContent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        reasonContent.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150).isActive = true
    }
    
    override func configUI() {
        view.backgroundColor = .primaryBackground
        navigationController?.navigationBar.topItem?.title = "전체 예약"
        navigationController?.navigationBar.tintColor = .black
    }
    
    func configure(index: IndexPath) {
        scheduleLabel.text = "신청 내역"
        reasonLabel.text = "예약 용건"
        scheduleTitle.text = "예약 \(index.row + 1)"
        
        let appointment: Schedule = currentParent.schedules[index.row]
        reasonContent.text = appointment.content

        //스케줄 리스트 데이터의 갯수만큼 text 정보를 추가해서 여러 줄로 예약 대기 스케줄 표기
        func printSchedule() {
            var text = ""
            for i in 0..<appointment.scheduleList.count {
                text.append(appointment.scheduleList[i].consultingDate + " " + appointment.scheduleList[i].startTime + "\n")
            }
            scheduleCandidates.text = text
        }
        printSchedule()

        //인디케이터 디자인 확정 후 변경
//        guard appointment.scheduleList[index.row].isReserved == true else {return}
//        checkIndicator.text = "확정"
    }
}
