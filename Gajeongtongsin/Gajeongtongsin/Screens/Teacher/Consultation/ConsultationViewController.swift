//
//  ConsultationViewController.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

class ConsultationViewController: BaseViewController {

    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "선생님 상담예약 준비중입니다 😎"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func render() {
        view.addSubview(textLabel)
        textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    override func configUI() {
        view.backgroundColor = .primaryBackground
    }
    


}
