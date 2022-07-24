//
//  SentMessageListViewController.swift
//  Gajeongtongsin
//
//  Created by Youngwoong Choi on 2022/07/22.
//

import UIKit

class SentMessageListViewController: BaseViewController {
    //MARK: - Properties
    let messageList: [Message] = mainTeacher.parentUserIds.flatMap({$0.sendingMessages})
//        .filter({$0.type != .emergency})
    
    //화면에 뿌려줄 메시지 리스트를 곧바로 'messageList#'으로 지정하지 않고, 부모 유저(여기선 parent1)에 속한 것으로 불러옴
    let currentParent = parent1

    
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
        table.register(sentMessageTableViewCell.self, forCellReuseIdentifier: sentMessageTableViewCell.identifier)
        table.rowHeight = 100
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sentMessageList.delegate = self
        sentMessageList.dataSource = self
        navigationBar()
        writeMessageButton.addTarget(self, action: #selector(writeButton), for: .touchUpInside)
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
        view.backgroundColor = .primaryBackground
//        navigationBar.delegate = self
    }
    
    func navigationBar() {
//        self.navigationItem.title = "전송내역nav"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: viewTitle)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.message"), style: .plain, target: self, action: #selector(writeButton))
    }
    
    @objc func writeButton() {
        let vc = SendingViewController()
        present(vc, animated: true)
    }
}

extension SentMessageListViewController: UITableViewDelegate {
    
}

extension SentMessageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentParent.sendingMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMessageTableViewCell", for: indexPath) as! sentMessageTableViewCell
        
        let messagesToView = currentParent.sendingMessages[indexPath.row]
        
        func msgType() -> String {
            switch messagesToView.type {
                case .absence : return "결석"
                case .earlyLeave : return "조퇴"
            case .emergency : return "긴급"
            }
        }
        
        cell.messageInfo.text = "\(currentParent.childName) / \(msgType()) / \(messagesToView.expectedDate)"
        
        cell.content.text = "\(messagesToView.content)"

        return cell
    }
}




