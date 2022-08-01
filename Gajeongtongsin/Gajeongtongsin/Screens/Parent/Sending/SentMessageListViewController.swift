//
//  SentMessageListViewController.swift
//  Gajeongtongsin
//
//  Created by Youngwoong Choi on 2022/07/22.
//

import UIKit

class SentMessageListViewController: BaseViewController {
    //MARK: - Properties
    
    //화면에 뿌려줄 메시지 리스트를 곧바로 'messageList#'으로 지정하지 않고, 부모 유저(여기선 parent1)에 속한 것으로 불러옴
//    var currentParent: ParentUser {
//        return mainTeacher.parentUsers[0]
//    }
    var allMessages: [Message] = []
    private let viewTitle: UILabel = {
        let label = UILabel()
        label.text = "전송내역"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let writeMessageButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "plus.message"), for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let sentMessageList: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(SentMessageTableViewCell.self, forCellReuseIdentifier: SentMessageTableViewCell.identifier)
        table.rowHeight = 100
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sentMessageList.delegate = self
        sentMessageList.dataSource = self

        navigationBar()
        writeMessageButton.addTarget(self, action: #selector(writeButton), for: .touchUpInside)
        
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
        view.addSubview(sentMessageList)
        sentMessageList.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        sentMessageList.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        sentMessageList.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sentMessageList.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    override func configUI() {
        view.backgroundColor = .Background
    }
    
    func navigationBar() {
//        self.navigationItem.title = "전송내역nav"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: viewTitle)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.message"), style: .plain, target: self, action: #selector(writeButton))
    }
    
    @objc func writeButton() {
        let vc = SendingViewController()
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        vc.delegate = self
        present(vc, animated: true)
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
        cell.configure( message: allMessages[indexPath.row])
        return cell
    }
}



extension SentMessageListViewController: SendingViewControllerDelegate {
    func reloadTable() {
        self.allMessages = []
        sentMessageList.reloadData()
    }
}
