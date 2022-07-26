//
//  StartViewController.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

class StartViewController: BaseViewController {
    
    // MARK: - Properties
    
    private lazy var parentButton: UIButton = {
        let button = UIButton()
        button.setTitle("학부모님", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 10
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(parentTap), for: .touchUpInside)
        return button
    }()
    private lazy var teacherButton: UIButton = {
        let button = UIButton()
        button.setTitle("선생님", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 10
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(teacherTap), for: .touchUpInside)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Funcs
    override func render() {
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        stackView.addArrangedSubview(parentButton)
        stackView.addArrangedSubview(teacherButton)
        parentButton.heightAnchor.constraint(equalToConstant: 200).isActive = true
        teacherButton.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    override func configUI() {
        view.backgroundColor = .primaryBackground
    }
    
    @objc func parentTap() {
        UserDefaults.standard.set(getUid(), forKey: "ParentUser")
        let vc = TabBarViewController(role: .parent)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    @objc func teacherTap() {
        UserDefaults.standard.set(getUid(), forKey: "TeacherUser")
        let vc = TabBarViewController(role: .teacher)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func getUid()-> String{
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        let uidIndex = uuid.index(uuid.startIndex, offsetBy: 5)
        return String(uuid[...uidIndex])
    }
}
