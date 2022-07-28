//
//  ReservationViewController.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

class ReservationViewController: BaseViewController {
    //MARK: - Properties

    //화면에 뿌려줄 메시지 리스트를 곧바로 'messageList#'으로 지정하지 않고, 부모 유저(여기선 parent1)에 속한 것으로 불러옴
    var currentParent: ParentUser {
        return mainTeacher.parentUserIds[0]
    }
    
    private let viewTitle: UILabel = {
        let label = UILabel()
        label.text = "예약내역"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let noScheduleLabel: UILabel = {
        let label = UILabel()
        label.text = "예정된 상담이 없어요 :)"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reserveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "calendar.badge.plus"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let reservedScheduleList: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.identifier)
        table.rowHeight = 60
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        reservedScheduleList.delegate = self
        reservedScheduleList.dataSource = self
        navigationController?.navigationBar.topItem?.title = ""
    }

    //MARK: - Funcs
    @objc func onTapButton() {
        let vc = ParentsCalenderViewController()
        present(vc, animated: true)
    }
    
    override func render() {
        view.addSubview(reservedScheduleList)
        reservedScheduleList.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        reservedScheduleList.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        reservedScheduleList.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        reservedScheduleList.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        view.addSubview(noScheduleLabel)
        noScheduleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noScheduleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    override func configUI() {
        view.backgroundColor = .primaryBackground
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: viewTitle)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: reserveButton)
        scheduleToggle()
        calendarBtnAct()
    }
    
    func scheduleToggle() {
        if currentParent.schedules.isEmpty {
            reservedScheduleList.isHidden = true
            noScheduleLabel.isHidden = false
        } else {
            reservedScheduleList.isHidden = false
            noScheduleLabel.isHidden = true
        }
    }
    
    func calendarBtnAct() {
        //신청버튼 메뉴에 따라 액션 분리, 긴급신청은 alert 띄워서 사유 작성 후 전송 -> noti 날림
        //TODO: -
        reserveButton.menu = UIMenu(options: .displayInline, children: [
            UIAction(title: "상담예약", handler: { _ in
                self.present(ParentsCalenderViewController(), animated: true)
            }),
            UIAction(title: "긴급신청", handler: { _ in
                let alert = UIAlertController(title: "긴급 상담 요청", message: "정말 급한 상담인지 다시 한 번 생각해주세요", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                let okayAction = UIAlertAction(title: "신청", style: .default) { _ in
                    //신청 버튼 누를 때 noti로 전송하는 것 구현 필요
                    let _: String = alert.textFields?.first?.text ?? ""
                }
                alert.addAction(cancelAction)
                alert.addAction(okayAction)
                alert.addTextField()
                alert.textFields?[0].placeholder = "상담 용건 작성"
                self.present(alert, animated: true)
            })
        ])
    }
}


//MARK: - Extensions

extension ReservationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ReservationDetailViewController()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .popover
        vc.configure(index: indexPath)
        navigationController?.pushViewController(vc, animated: true)
//        present(vc, animated: true)
    }
}

extension ReservationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentParent.schedules.isEmpty {
            
        } else {
            scheduleToggle()
        }
        return currentParent.schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell
        cell.configure(index: indexPath)
        return cell
    }
}
