//
//  LabelFieldView.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/30.
//

import UIKit

class LabelFieldView: UIStackView {
    // MARK: - Properties
    private let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var bottomLine: UIView = {
      let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .DarkLine
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // MARK: - Init
    init(titleLabel: String, placeholder: String) {
        super.init(frame: .zero)
        title.text = titleLabel
        textField.placeholder = placeholder
        render()
        configUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Funcs
    func render() {
        self.addArrangedSubview(title)
        self.addArrangedSubview(textField)
        textField.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        textField.addSubview(bottomLine)
        bottomLine.leadingAnchor.constraint(equalTo: textField.leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: textField.trailingAnchor).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: textField.bottomAnchor,constant: 5).isActive = true


    }
    func configUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.alignment = .leading
        self.distribution = .fillEqually
        self.spacing = 20
    }
    /// 텍스트필드 내용
    func getContent() -> String?{
        return textField.text
    }
    /// 텍스트필드 태그 설정하기
    func setTag(_ tag: Int) {
        textField.tag = tag
    }
    /// 텍스트필드 객체 얻어오기
    func getTextField() -> UITextField {
        return textField
    }
}
