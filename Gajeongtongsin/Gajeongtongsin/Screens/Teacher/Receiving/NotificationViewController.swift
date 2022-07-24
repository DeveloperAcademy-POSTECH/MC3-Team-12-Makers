//
//  NotificationViewController.swift
//  Gajeongtongsin
//
//  Created by uiskim on 2022/07/24.
//
import UIKit

let sections = ["긴급알림", "일반알림"]

class NotificationViewController: BaseViewController {
    let messagesWithChildName = mainTeacher.parentUserIds.flatMap{ $0.getMessagesWithChildName() }
    
    var emergancy: [(childName: String, message: Message)] {
        messagesWithChildName.filter{ $0.message.type == .emergency }
    }
    var normal: [(childName: String, message: Message)] {
        messagesWithChildName.filter{ $0.message.type != .emergency }
    }
    
    private let noticicationViewTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "알림"
        title.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        title.textColor = UIColor.black
        return title
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        navigationBar()
    }
    
    override func render() {
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    
    }
    
    func navigationBar() {
        self.navigationItem.title = "알림"
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

}

extension NotificationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
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
            cell.configure(childName: emergancy[indexPath.row].childName, message: emergancy[indexPath.row].message)
            cell.backgroundColor = UIColor.red.withAlphaComponent(0.1)
        } else {
            cell.configure(childName: normal[indexPath.row].childName, message: normal[indexPath.row].message)
            cell.backgroundColor = UIColor.blue.withAlphaComponent(0.1)
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

    }
}
