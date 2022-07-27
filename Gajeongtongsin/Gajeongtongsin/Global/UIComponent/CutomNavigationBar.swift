//
//  CutomNavigationBar.swift
//  Gajeongtongsin
//
//  Created by uiskim on 2022/07/27.
//

import UIKit

class CutomNavigationBar: UIView {
    
    var delegate: CustomNavigationBarDelegate?
    var title: String = ""
    var imageName: String = ""
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rightButtonItem : UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    init(title: String, imageName: String){
        super.init(frame: .zero)
        self.title = title
        self.imageName = imageName
        render()
        configUI()

        rightButtonItem.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() {
        addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 16).isActive = true
        
        addSubview(rightButtonItem)
        rightButtonItem.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        rightButtonItem.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -16).isActive = true
    }
    
    func configUI() {
        titleLabel.text = title
        rightButtonItem.setImage(UIImage(systemName: imageName), for: .normal)
    }
    @objc func tapButton(){
        delegate?.tapButton()
    }
    

}
