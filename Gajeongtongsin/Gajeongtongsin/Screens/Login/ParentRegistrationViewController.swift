//
//  ParentRegistrationViewController.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/30.
//

import UIKit
import SwiftUI

class ParentRegistrationViewController: BaseViewController {
    
    var homeroomTeacherUid: String = ""
    var childName: String = ""
    
    // MARK: - Properties
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "학부모님, 안녕하세요!"
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false // 필요한가
        return label
    }()
    
    private let invitationCodeView: LabelFieldView = {
        let view = LabelFieldView(titleLabel: "초대 코드",
                                  placeholder: "초대코드 6자리를 입력해주세요.")
        view.setTag(0)
        view.translatesAutoresizingMaskIntoConstraints = false // 필요한가
        return view
    }()
    
    private let childNameView: LabelFieldView = {
        let view = LabelFieldView(titleLabel: "자녀 확인",
                                  placeholder: "자녀 분 성함을 입력해주세요.")
        view.translatesAutoresizingMaskIntoConstraints = false // 필요한가
        view.setTag(1)
        return view
    }()
    private let registrationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .LightLine
        button.setTitle("가입하기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.isUserInteractionEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 3
        return button
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        invitationCodeView.getTextField().delegate = self
        childNameView.getTextField().delegate = self
        
        registrationButton.addTarget(self,
                                     action: #selector(registerTap),
                                     for: .touchUpInside)
        
    }
    // MARK: - Funcs
    override func render() {
        view.addSubview(greetingLabel)
        greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        greetingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true
        greetingLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: 64).isActive = true
        
        view.addSubview(invitationCodeView)
        invitationCodeView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        invitationCodeView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true
        invitationCodeView.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor,constant: 42).isActive = true
        
        view.addSubview(childNameView)
        childNameView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        childNameView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true
        childNameView.topAnchor.constraint(equalTo: invitationCodeView.bottomAnchor,constant: 45).isActive = true
        
        view.addSubview(registrationButton)
        registrationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        registrationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true
        registrationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -40).isActive = true
        registrationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override func configUI() {
        view.backgroundColor = .Background
    }
    
    @objc func registerTap(){
        
        homeroomTeacherUid = invitationCodeView.getContent() ?? ""
        childName = childNameView.getContent() ?? ""
        UserDefaults.standard.set(homeroomTeacherUid, forKey: "HomeroomTeacher")
        UserDefaults.standard.set(childName, forKey: "ChildName")
        
        FirebaseManager.shared.initializeParent()
        
        let vc = TabBarViewController(role: .parent)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
// MARK: - Extensions
extension ParentRegistrationViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // TODO: - 서버에 선생님 코드가 존재하는지 안하는지 체크필요함
        // FIXME: - MAX_LENGTH에서 -2 안하는 로직 다시.
        if homeroomTeacherUid.count  >= MAX_LENGTH - 2 && !childName.isEmpty {
            registrationButton.isUserInteractionEnabled = true
            registrationButton.backgroundColor = .Action
        } else {
            registrationButton.isUserInteractionEnabled = false
            registrationButton.backgroundColor = .LightLine
            
        }
        
        if textField.tag == 0 {
            
            guard let text = textField.text else {return false}
            homeroomTeacherUid = text
            
            // backSpace 허용
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if isBackSpace == -92 {
                    return true
                }
            }
            // 글자수 6글자를 넘어가면 입력제한
            return text.count >= MAX_LENGTH ? false : true
            
            
        } else {
            guard let text = textField.text else {return false}
            childName = text
            return true
        }
        
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            childNameView.getTextField().becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            //  registerTap()  Return키 누르고 바로 버튼 이벤트 발생시킬 때
        }
        return true
    }
    
}
