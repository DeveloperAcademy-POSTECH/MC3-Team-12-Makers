//
//  NotificationViewController.swift
//  Gajeongtongsin
//
//  Created by uiskim on 2022/07/24.
//
import UIKit

let sections = ["긴급알림", "일반알림"]

class NotificationViewController: BaseViewController {
    
    // MARK: - Properties

    var emergency: [Notification] {
        allNotifications.filter { $0.type == .emergency }
    }
    
    var normal: [Notification] {
        allNotifications.filter { $0.type != .emergency }
    }
    
    private var allNotifications: [Notification] = []
    
    private let notificationLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "알림"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.identifier)
        tableView.backgroundColor = .white
        tableView.separatorColor = .darkGray


        return tableView
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = .systemBackground
        
        FirebaseManager.shared.fetchNotifications { [weak self] notifications in
            if let notifications = notifications {
                self?.allNotifications = notifications
                self?.tableView.reloadData()
            }
          
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Funcs
    override func render() {

        view.addSubview(notificationLabel)
        notificationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13).isActive = true
        notificationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        notificationLabel.widthAnchor.constraint(equalToConstant: 343).isActive = true
        notificationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: notificationLabel.bottomAnchor, constant: 10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.separatorInset.left = 0
        tableView.separatorColor = .white

    }
}

extension NotificationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customSectionBar = CustomSectionBar()
        customSectionBar.configure(section: section)
        return customSectionBar
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        38
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return emergency.count
        }
        return normal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identifier, for: indexPath) as? NotificationTableViewCell else { return UITableViewCell()}
        if indexPath.section == 0 {

            cell.configure(notification: emergency[indexPath.row])

            cell.backgroundColor = UIColor.Urgent

        } else {
            cell.configure(notification: normal[indexPath.row])
            cell.backgroundColor = UIColor.Confirm

        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension NotificationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let currentMessage = emergency[indexPath.row]
            let alret = UIAlertController(title: "\(currentMessage.childName) 긴급상담용건", message: currentMessage.content, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "확인", style: .default)
            alret.addAction(okayAction)
            present(alret, animated: true, completion: nil)
        }
    }
    
    
}
