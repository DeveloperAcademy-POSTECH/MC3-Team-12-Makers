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
        table.register(UITableViewCell.self, forCellReuseIdentifier: sentMessageTableViewCell.identifier)
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
//        view.addSubview(navigationBar)
//        navigationBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
//        navigationBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
//        view.addSubview(viewTitle)
//        viewTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
//        viewTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//        viewTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        view.addSubview(writeMessageButton)
//        writeMessageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        writeMessageButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        writeMessageButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
//        writeMessageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
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
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: sentMessageTableViewCell.identifier, for: indexPath)
        
        let parent = mainTeacher.parentUserIds[indexPath.section]

//        cell.configure(childName: parent.childName, message: messageList[indexPath.row])

        cell.imageView?.image = UIImage(systemName: "plus")
        return cell
    }
}
