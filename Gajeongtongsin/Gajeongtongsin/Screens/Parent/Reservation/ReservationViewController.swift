//
//  ReservationViewController.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

class ReservationViewController: BaseViewController {
    //MARK: - Properties
    var allSchedules: [Schedule] = []
    
    private let navBar: CustomNavigationBar = {
        let bar = CustomNavigationBar(title: "예약내역", titleSize: 28, imageName: "calendar.badge.plus", imageSize: 20)
        return bar
    }()

    private let noScheduleLabel: UILabel = {
        let label = UILabel()
        label.text = "예정된 상담이 없어요 :)"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .black
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reservedScheduleList: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.identifier)
        table.backgroundColor = .Background
        table.rowHeight = 60
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        reservedScheduleList.delegate = self
        reservedScheduleList.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.topItem?.title = ""
        
        FirebaseManager.shared.fetchParentReservations { [weak self] schedules in
            if let schedules = schedules {
                self?.allSchedules = []
                self?.allSchedules = schedules
                self?.reservedScheduleList.reloadData()
            }
            self?.scheduleToggle()
        }
    }

    //MARK: - Funcs
    override func render() {
        view.addSubview(navBar)
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navBar.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(reservedScheduleList)
        reservedScheduleList.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 30).isActive = true
        reservedScheduleList.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        reservedScheduleList.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        reservedScheduleList.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        view.addSubview(noScheduleLabel)
        noScheduleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noScheduleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    override func configUI() {
        view.backgroundColor = .Background
        calendarBtnAct()
    }
    
    //스케줄 없을 시 예약 없다는 문구 표출
    func scheduleToggle() {
        if allSchedules.isEmpty {
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
    
    func showToastHere() {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-150, width: 200, height: 50))
        toastLabel.backgroundColor = .Confirm
        toastLabel.textColor = UIColor.black
        toastLabel.font = .systemFont(ofSize: 12)
        toastLabel.textAlignment = .center;
        toastLabel.text = "긴급상담신청이 완료되었습니다.\n선생님이 직접 연락드릴 예정입니다."
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        self.view.superview?.addSubview(toastLabel)
        UIView.animate(withDuration: 6.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

//MARK: - Extensions

extension ReservationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ReservationDetailViewController()
        vc.configure(row: indexPath.row,schedules: allSchedules)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ReservationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSchedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell
        cell.configure(indexPath.row, allSchedules[indexPath.row])
        return cell
    }
}

extension ReservationViewController: UrgentRequestViewControllerDelegate {
    func showToast() {
        self.showToastHere()
    }
}
