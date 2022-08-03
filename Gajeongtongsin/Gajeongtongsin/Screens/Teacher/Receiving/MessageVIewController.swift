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
    private var customNavigationBar: CustomNavigationBar = {
        let customNavigationBar = CustomNavigationBar(title: "수신내역", imageName: "bell", imageSize: 20)
        customNavigationBar.backgroundColor = .white
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        return customNavigationBar
    }()
    private var allMessages: MessagesWithChildName = []
    
    var sortedMessages:[MessagesWithChildName] {
         chunkedMessages(messages: allMessages.sorted(by: {$0.message.sentDate > $1.message.sentDate}))
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        customNavigationBar.delegate = self
        configUI()
        
        FirebaseManager.shared.fetchParentsMessages { [weak self] messages in
            if let messages = messages {
                self?.allMessages = []
                self?.allMessages = messages
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    
    override func render() {
        
        view.addSubview(customNavigationBar)
        customNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        customNavigationBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    // MARK: - Funcs
    
    func setupNavigationBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .black
    }
    
    override func configUI() {
        setupNavigationBackButton()
        view.backgroundColor = .systemBackground
    }
}

extension MessageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("섹션갯수\(sortedMessages)")
        return sortedMessages.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(sortedMessages[section].count)
        return sortedMessages[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if !sortedMessages[section].isEmpty {
        return "\(sortedMessages[section][0].message.sentDate)에 수신하신 쪽지입니다"
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as? MessageTableViewCell else { return UITableViewCell()}
    
        let messageTuple: MessagesWithChildName = sortedMessages[indexPath.section]
        let childName = messageTuple[indexPath.row].childName
        let message = messageTuple[indexPath.row].message
        cell.configure(childName: childName, message: message)
        

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
    }
}

    // MARK: - Extensions
extension MessageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let clickedCell = tableView.cellForRow(at: indexPath) as? MessageTableViewCell
        let alert = UIAlertController(title: "처리완료하시겠습니까?", message: "확인을누르면 블라블라", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let okayAction = UIAlertAction(title: "확인", style: .default) { _ in
            let cell = tableView.cellForRow(at: indexPath) as? MessageTableViewCell
            cell?.changeState()
            cell?.messageCompleted()
            FirebaseManager.shared.uploadMessageComplete(message: cell?.getMessage())
        }
        alert.addAction(cancelAction)
        alert.addAction(okayAction)
        
        if clickedCell?.isChecked == false {
            present(alert, animated: true, completion: nil)
        }
    }
}

func chunkedMessages(messages: [(childName: String, message: Message)]) -> [MessagesWithChildName] {
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

extension MessageViewController : CustomNavigationBarDelegate {
    func tapButton() {
        let vc = NotificationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
