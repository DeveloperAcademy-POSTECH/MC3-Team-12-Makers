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
    var emergancy: [Notification] {
        mainTeacher.notificationList.filter { $0.type == .emergency }
    }
    
    var normal: [Notification] {
        mainTeacher.notificationList.filter { $0.type != .emergency }
    }
    
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


        return tableView
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = .systemBackground
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
  //      tableView.contentInset = UIEdgeInsets(top: 7, left: 0, bottom: 0, right: 0)
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
}

extension NotificationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerContent = UIView()
        
        let title = UILabel()
        title.text = sections[section]
        title.font = UIFont.systemFont(ofSize: 11)
        title.textColor = UIColor.titleGray
        
        headerContent.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: headerContent.centerYAnchor).isActive = true
        title.centerXAnchor.constraint(equalTo: headerContent.centerXAnchor).isActive = true
        title.widthAnchor.constraint(equalToConstant: 41).isActive = true
        title.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        let separatorView1 = UIView()
        separatorView1.translatesAutoresizingMaskIntoConstraints = false
        separatorView1.backgroundColor = UIColor.opGray
        headerContent.addSubview(separatorView1)
        separatorView1.leadingAnchor.constraint(equalTo: headerContent.leadingAnchor, constant: 0).isActive = true
        separatorView1.trailingAnchor.constraint(equalTo: title.leadingAnchor, constant: -13).isActive = true
        separatorView1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView1.centerYAnchor.constraint(equalTo: headerContent.centerYAnchor).isActive = true
        
        let separatorView2 = UIView()
        separatorView2.translatesAutoresizingMaskIntoConstraints = false
        separatorView2.backgroundColor = UIColor.opGray
        headerContent.addSubview(separatorView2)
        separatorView2.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 13).isActive = true
        separatorView2.trailingAnchor.constraint(equalTo: headerContent.trailingAnchor, constant: 0).isActive = true
        separatorView2.centerYAnchor.constraint(equalTo: headerContent.centerYAnchor).isActive = true
        separatorView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
  
        
        return headerContent
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
            return emergancy.count
        }
        return normal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identifier, for: indexPath) as? NotificationTableViewCell else { return UITableViewCell()}
        if indexPath.section == 0 {
            cell.configure(notification: emergancy[indexPath.row])
            cell.backgroundColor = UIColor.emergencyAlertColor
        } else {
            cell.configure(notification: normal[indexPath.row])
            cell.backgroundColor = UIColor.normalAlertColor
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension NotificationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentMessage = emergancy[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let alret = UIAlertController(title: "\(currentMessage.childName) 긴급상담용건", message: currentMessage.content, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "확인", style: .default)
            alret.addAction(okayAction)
            present(alret, animated: true, completion: nil)
        }
    }
}
