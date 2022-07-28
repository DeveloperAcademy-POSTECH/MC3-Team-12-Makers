//
//  MessageVIewController.swift
//  Gajeongtongsin
//
//  Created by uiskim on 2022/07/23.
//

import UIKit

typealias MessagesWithChildName = [(childName: String, message: Message)]

class MessageViewController: BaseViewController {
    
    // MARK: - Properties
    let messagesWithChildName = mainTeacher.parentUsers.flatMap({$0.getMessagesWithChildName()})
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - View Life Cycle
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
    
    // MARK: - Funcs
    func navigationBar() {
        self.navigationItem.title = "수신내역"
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func chunkedMessages(_ messages: MessagesWithChildName) -> [MessagesWithChildName] {
        var messagesByDate: [MessagesWithChildName] = []
        var currentDateMessages: MessagesWithChildName = []
        
        for message in messagesWithChildName {
            if let lastElement = currentDateMessages.last {
                if lastElement.message.sentDate != message.message.sentDate {
                    messagesByDate.append(currentDateMessages)
                    currentDateMessages = []
                }
            }
            currentDateMessages.append(message)
        }
        return messagesByDate
        
    }

}

extension MessageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesWithChildName.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as? MessageTableViewCell else { return UITableViewCell()}
        
        let messageInfo = messagesWithChildName[indexPath.row]
        cell.configure(childName: messageInfo.childName, message: messageInfo.message)  
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


extension MessageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let alert = UIAlertController(title: "처리완료하시겠습니까?", message: "확인을누르면 블라블라", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let okayAction = UIAlertAction(title: "확인", style: .default) { _ in
            let cell = tableView.cellForRow(at: indexPath) as? MessageTableViewCell
            cell?.changeState()
        }
        alert.addAction(cancelAction)
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
}

