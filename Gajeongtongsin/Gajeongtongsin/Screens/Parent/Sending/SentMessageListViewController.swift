//
//  SentMessageListViewController.swift
//  Gajeongtongsin
//
//  Created by Youngwoong Choi on 2022/07/22.
//

import UIKit

class SentMessageListViewController: BaseViewController {
    //MARK: - Properties
    
    var allMessages: [Message] = []
    
    private let navBar: CustomNavigationBar = {
        let bar = CustomNavigationBar(title: "전송내역", imageName: "plus.message", imageSize: 20)
        bar.rightButtonItem.tintColor = .Action
        return bar
    }()
    
    private let sentMessageList: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(SentMessageTableViewCell.self, forCellReuseIdentifier: SentMessageTableViewCell.identifier)
        table.backgroundColor = .Background
        table.rowHeight = 100
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Background
        sentMessageList.delegate = self
        sentMessageList.dataSource = self
        navBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
        FirebaseManager.shared.fetchParentMessages { [weak self] messages in
            if let messages = messages {
                self?.allMessages = []
                self?.allMessages = messages
                self?.sentMessageList.reloadData()
            }
        }
    }
    
    //MARK: - Funcs
    override func render() {
        view.addSubview(navBar)
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navBar.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(sentMessageList)
        sentMessageList.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 30).isActive = true
        sentMessageList.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        sentMessageList.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sentMessageList.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    override func configUI() {
    }
}

//MARK: - Extensions

extension SentMessageListViewController: UITableViewDelegate {
    
}

extension SentMessageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMessageTableViewCell", for: indexPath) as! SentMessageTableViewCell
        

//        cell.configure(index: indexPath.row)
        cell.configure( message: allMessages[indexPath.row] )
        return cell
    }
}



extension SentMessageListViewController: SendingViewControllerDelegate {
    func reloadTable() {
        self.allMessages = []
        sentMessageList.reloadData()
    }
}

extension SentMessageListViewController: CustomNavigationBarDelegate {
    func tapButton() {
        let vc = SendingViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}
