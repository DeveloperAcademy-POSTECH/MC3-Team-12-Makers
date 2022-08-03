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
        return mainTeacher.parentUsers[0]
    }
    
    private let navBar: CustomNavigationBar = {
        let bar = CustomNavigationBar(title: "예약내역", imageName: "calendar.badge.plus", imageSize: 20)
        return bar
    }()
    
    private let viewTitle: UILabel = {
        let label = UILabel()
        label.text = "예약내역"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reserveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "calendar.badge.plus"), for: .normal)
        button.tintColor = .Action
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let noScheduleLabel: UILabel = {
        let label = UILabel()
        label.text = "예정된 상담이 없어요 :)"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        scheduleToggle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    //MARK: - Funcs
    override func render() {
        view.addSubview(navBar)
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navBar.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(reservedScheduleList)
        reservedScheduleList.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        reservedScheduleList.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        reservedScheduleList.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        reservedScheduleList.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        view.addSubview(noScheduleLabel)
        noScheduleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noScheduleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    override func configUI() {
        view.backgroundColor = .white
        scheduleToggle()
        calendarBtnAct()
    }
    
    //스케줄 없을 시 예약 없다는 문구 표출
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
        navBar.rightButtonItem.tintColor = .Action
        navBar.rightButtonItem.showsMenuAsPrimaryAction = true
        navBar.rightButtonItem.menu = UIMenu(options: .displayInline, children: [
            UIAction(title: "상담예약", handler: { _ in
                self.present(ParentsCalenderViewController(), animated: true)
            }),
            UIAction(title: "긴급신청", handler: { _ in
                self.present(UrgentRequestViewController(), animated: true)
            })
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        reservedScheduleList.endEditing(true)
    }
}

//MARK: - Extensions

extension ReservationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ReservationDetailViewController()
        vc.configure(index: indexPath)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        tableView.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
}

extension ReservationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentParent.schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell
        cell.configure(index: indexPath)
        return cell
    }
}
