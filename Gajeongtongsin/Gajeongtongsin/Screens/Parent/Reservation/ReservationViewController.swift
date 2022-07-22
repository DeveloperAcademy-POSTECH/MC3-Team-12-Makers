//
//  ReservationViewController.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

class ReservationViewController: BaseViewController {

    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "학부모님 상담예약 준비중입니다 😎"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("상담예약 캘린더뷰 버튼", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button.addTarget(self, action: #selector(onTapButton), for: .touchUpInside)
    }
    

    @objc func onTapButton() {
        let vc = ParentsCalenderViewController()
        present(vc, animated: true)
    }
    
    //MARK: - Funcs
    override func render() {
        view.addSubview(textLabel)
        textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(button)
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 180).isActive = true
    }

    override func configUI() {
        view.backgroundColor = .primaryBackground
    }
}
