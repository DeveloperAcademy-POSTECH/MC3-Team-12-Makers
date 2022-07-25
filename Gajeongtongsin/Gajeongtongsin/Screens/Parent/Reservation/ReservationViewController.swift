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
    
    private let reserveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "calendar.badge.plus"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: reserveButton)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: viewTitle)
    }

    
    //MARK: - Funcs
    override func render() {
        view.addSubview(textLabel)
        textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(reserveButton)
        reserveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        reserveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 180).isActive = true
    }

    override func configUI() {
        view.backgroundColor = .primaryBackground
        
        //신청버튼 메뉴에 따라 액션 분리
        reserveButton.menu = UIMenu(options: .displayInline, children: [
            UIAction(title: "상담예약", handler: { _ in
                self.present(ParentsCalenderViewController(), animated: true)
            }),
            UIAction(title: "긴급신청", handler: { _ in
                let alert = UIAlertController(title: "긴급 상담 요청", message: "정말 급한 상담인지 다시 한 번 생각해주세요", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                let okayAction = UIAlertAction(title: "신청", style: .default) { _ in
                    let text: String = alert.textFields?[0].text ?? ""
//                    print(text)
                }
                alert.addAction(cancelAction)
                alert.addAction(okayAction)
                alert.addTextField()
                alert.textFields?[0].placeholder = "상담 요건 작성"
                self.present(alert, animated: true)
                

            })
        ])
    }
}

