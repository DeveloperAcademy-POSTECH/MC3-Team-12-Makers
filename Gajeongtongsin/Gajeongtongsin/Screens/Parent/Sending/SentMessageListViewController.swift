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
    var currentParent: ParentUser {
        return mainTeacher.parentUsers[0]
    }
    
    private let navBar: CustomNavigationBar = {
        let bar = CustomNavigationBar(title: "전송내역", imageName: "plus.message", imageSize: 20)
        bar.rightButtonItem.tintColor = .Action
        return bar
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
        navBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Funcs
    override func render() {
        view.addSubview(navBar)
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navBar.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(sentMessageList)
        sentMessageList.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        sentMessageList.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        sentMessageList.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sentMessageList.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    override func configUI() {
        view.backgroundColor = .white
    }
}

//MARK: - Extensions

extension SentMessageListViewController: UITableViewDelegate {
    
}

extension SentMessageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentParent.sendingMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMessageTableViewCell", for: indexPath) as! SentMessageTableViewCell
        
        cell.configure(index: indexPath.row)

        return cell
    }
}



extension SentMessageListViewController: SendingViewControllerDelegate {
    func reloadTable() {
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
