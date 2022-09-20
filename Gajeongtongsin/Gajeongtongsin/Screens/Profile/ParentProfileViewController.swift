//
//  ParentProfileViewController.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/09/09.
//

import UIKit

class ParentProfileViewController: BaseViewController {

    // MARK: - Properties
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 화면 준비중입니다 😎"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func render() {
        view.addSubview(textLabel)
        textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true


    }

    override func configUI() {
        view.backgroundColor = .Background
    }



}
