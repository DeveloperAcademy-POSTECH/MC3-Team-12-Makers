//
//  ReservationViewController.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

class ReservationViewController: BaseViewController {
    //TODO: -
    /// 신청내역 리스트 테이블뷰

    private let viewTitle: UILabel = {
        let label = UILabel()
        label.text = "예약내역"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "예정된 상담이 없어요 :)"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "calendar.badge.plus"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: viewTitle)
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
        
        //신청버튼 메뉴에 따라 액션 분리
        button.menu = UIMenu(options: .displayInline, children: [
            UIAction(title: "상담예약", handler: { _ in
                self.present(ParentsCalenderViewController(), animated: true)
                print("상담예약")
            }),
            UIAction(title: "긴급신청", handler: { _ in

                print("긴급신청")
            })
        ])
    }
    
}
