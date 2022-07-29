////
////  CustomNotificationSection.swift
////  Gajeongtongsin
////
////  Created by uiskim on 2022/07/29.
////
//
//import UIKit
//
//class CustomNotificationSection: UIView {
//
//    // MARK: - Properties
//    var title: String = ""
//    
//    var titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    dra
//    
//    
//    // MARK: - Init
//    init(title: String){
//        self.title = title
//        super.init(frame: .zero)
//        render()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Funcs
//    func render() {
//        addSubview(titleLabel)
//        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 29).isActive = true
//        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
//        titleLabel.widthAnchor.constraint(equalToConstant: 148).isActive = true
//        titleLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
//
//    }
//    
//    func configUI(title: String) {
//        titleLabel.text = title
//    }
//    
//
//    
//
//}
