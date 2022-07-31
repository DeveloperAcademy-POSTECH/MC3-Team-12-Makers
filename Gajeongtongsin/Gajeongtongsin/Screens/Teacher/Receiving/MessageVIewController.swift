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
}

extension MessageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("섹션갯수\(sortedMessages.count)")
        return sortedMessages.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedMessages[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(sortedMessages[section][0].message.sentDate)에 수신하신 쪽지입니다"
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as? MessageTableViewCell else { return UITableViewCell()}
    
        cell.configure(indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
    }
}


extension MessageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let clickedCell = tableView.cellForRow(at: indexPath) as? MessageTableViewCell
        let alert = UIAlertController(title: "처리완료하시겠습니까?", message: "확인을누르면 블라블라", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let okayAction = UIAlertAction(title: "확인", style: .default) { _ in
            let cell = tableView.cellForRow(at: indexPath) as? MessageTableViewCell
            cell?.changeState()
            cell?.selectionStyle = .none
        }
        alert.addAction(cancelAction)
        alert.addAction(okayAction)
        
        if clickedCell?.isChecked == false {
            present(alert, animated: true, completion: nil)
        }
    }
}

func chunkedMessages(messages: MessagesWithChildName) -> [MessagesWithChildName] {
    var messagesByDate: [MessagesWithChildName] = []
    var currentDateMessages: MessagesWithChildName = []
    
    for message in messages {
        if let lastElement = currentDateMessages.last {
            if lastElement.message.sentDate != message.message.sentDate {
                messagesByDate.append(currentDateMessages)
                currentDateMessages = []
            }
        }
        currentDateMessages.append(message)
    }
    messagesByDate.append(currentDateMessages)  //마지막 리스트도 추가하고 리턴해야함
    return messagesByDate
    
}
