//
//  ReservationDetailViewController.swift
//  Gajeongtongsin
//
//  Created by Youngwoong Choi on 2022/07/28.
//

import UIKit

class ReservationDetailViewController: BaseViewController {
    //MARK: - Properties
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
        content.backgroundColor = .Background
        content.isScrollEnabled = true
        content.isEditable = false
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()
    
    private var statusIndicator: SecondaryButton = {
        let btn = SecondaryButton(buttonTitle: "대기중", buttonState: .normal)
        return btn
    }()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = "전체예약"
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
        
        view.addSubview(statusIndicator)
        statusIndicator.topAnchor.constraint(equalTo: scheduleTitle.bottomAnchor, constant: 35).isActive = true
        statusIndicator.leadingAnchor.constraint(equalTo: scheduleLabel.trailingAnchor, constant: 20).isActive = true
        statusIndicator.widthAnchor.constraint(equalToConstant: 70).isActive = true
        statusIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
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
        view.backgroundColor = .Background
        navigationController?.navigationBar.tintColor = .black
    }
    
    func configure(row: Int, schedules: [Schedule]) {
        scheduleLabel.text = "신청 내역"
        reasonLabel.text = "예약 용건"
        scheduleTitle.text = "예약 \(row + 1)"
        
        let appointment = schedules[row]
        reasonContent.text = appointment.content
        printSchedule(appointment)
        
        if appointment.scheduleList[row].isReserved {
            statusIndicator.setTitle("확정", for: .normal)
            statusIndicator.changeState(buttonState: .disabled)
            scheduleTitle.text = scheduleCandidates.text
            printSchedule(appointment)
        }
    }
    
    func printSchedule(_ appointment:Schedule) {
        var text = ""
        for i in 0..<appointment.scheduleList.count {
            text.append(appointment.scheduleList[i].consultingDate + " " + appointment.scheduleList[i].startTime + "\n")
        }
        scheduleCandidates.text = text
    }
}
