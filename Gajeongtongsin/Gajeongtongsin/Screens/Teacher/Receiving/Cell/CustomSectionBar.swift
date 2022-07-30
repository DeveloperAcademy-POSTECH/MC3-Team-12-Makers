////
////  CustomNotificationSection.swift
////  Gajeongtongsin
////
////  Created by uiskim on 2022/07/29.
////
//
import UIKit

class CustomSectionBar: UIView {

    // MARK: - Properties
    private let title: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 11)
        title.textColor = UIColor.darkGray
        return title
    }()
    
    private let separatorView1: UIView = {
        let separatorView1 = UIView()
        separatorView1.translatesAutoresizingMaskIntoConstraints = false
        separatorView1.backgroundColor = UIColor.darkGray
        return separatorView1
    }()
    
    private let separatorView2: UIView = {
        let separatorView2 = UIView()
        separatorView2.translatesAutoresizingMaskIntoConstraints = false
        separatorView2.backgroundColor = UIColor.darkGray
        return separatorView2
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Funcs
    func render() {
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.widthAnchor.constraint(equalToConstant: 41).isActive = true
        title.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        addSubview(separatorView1)
        separatorView1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        separatorView1.trailingAnchor.constraint(equalTo: title.leadingAnchor, constant: -13).isActive = true
        separatorView1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView1.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(separatorView2)
        separatorView2.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 13).isActive = true
        separatorView2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        separatorView2.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        separatorView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func configure(section: Int) {
        title.text = sections[section]
    }
}
