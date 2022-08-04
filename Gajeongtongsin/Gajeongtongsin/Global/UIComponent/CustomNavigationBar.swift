//
//  CutomNavigationBar.swift
//  Gajeongtongsin
//
//  Created by uiskim on 2022/07/27.
//

import UIKit

class CustomNavigationBar: UIView {
    
    // MARK: - Properties
    var delegate: CustomNavigationBarDelegate?
    var title: String = ""
    var titleSize: CGFloat
    var imageName: String = ""
    var imageSize: Int

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) var rightButtonItem : UIButton = {
        let button = UIButton()
        button.tintColor = .Action
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: - Init
    init(title: String, titleSize: CGFloat, imageName : String, imageSize: Int){
        self.title = title
        self.imageName = imageName
        self.imageSize = imageSize
        self.titleSize = titleSize
        super.init(frame: .zero)
        render()
        configUI()
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true

        rightButtonItem.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Funcs
    func render() {
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 29).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 148).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        addSubview(rightButtonItem)
        rightButtonItem.topAnchor.constraint(equalTo: self.topAnchor, constant: 33).isActive = true
        rightButtonItem.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -16).isActive = true
        self.backgroundColor = .Background
        self.translatesAutoresizingMaskIntoConstraints = false

    }
    
    func configUI() {
        let config = UIImage.SymbolConfiguration(pointSize: CGFloat(imageSize), weight: .medium, scale: .default)
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: titleSize, weight: .bold)
        rightButtonItem.setImage(UIImage(systemName: imageName, withConfiguration: config), for: .normal)
        
    }
    @objc func tapButton(){
        delegate?.tapButton()
    }
    

}
