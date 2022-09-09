//
//  UrgentRequestViewController.swift
//  Gajeongtongsin
//
//  Created by Youngwoong Choi on 2022/07/28.
//

import UIKit

protocol UrgentRequestViewControllerDelegate: AnyObject {
    func showToast()
}

class UrgentRequestViewController: BaseViewController {
    //MARK: - Properties
    weak var delegate: UrgentRequestViewControllerDelegate?
    
    private let cancelBtn: UIButton = {
        let label = UIButton()
        label.setTitle("취소", for: .normal)
        label.setTitleColor(UIColor.Action, for: .normal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let submitBtn: UIButton = {
        let label = UIButton()
        label.setTitle("신청", for: .normal)
        label.setTitleColor(UIColor.lightGray, for: .normal)
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let viewTitle: UILabel = {
        let label = UILabel()
        label.text = "긴급상담 신청"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let reasonTitle: UILabel = {
        let label = UILabel()
        label.text = "상담용건"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textPlaceHolder: String = "정말 급한 상담인지 한 번 더 생각해주세요!\n선생님의 소중한 개인시간일 수 있습니다."
    
    private let reasonText: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        textView.isEditable = true
        textView.textColor = .lightGray
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        textView.layer.cornerRadius = 10
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        reasonText.text = textPlaceHolder
        reasonText.delegate = self
    }
    
    //MARK: - Funcs
    override func render() {
        view.addSubview(cancelBtn)
        cancelBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        cancelBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        cancelBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.addSubview(viewTitle)
        viewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        viewTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.addSubview(submitBtn)
        submitBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        submitBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        submitBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(reasonTitle)
        reasonTitle.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 45).isActive = true
        reasonTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true

        view.addSubview(reasonText)
        reasonText.topAnchor.constraint(equalTo: reasonTitle.bottomAnchor, constant: 10).isActive = true
        reasonText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        reasonText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        reasonText.heightAnchor.constraint(equalToConstant: 240).isActive = true
    }
    
    //신청, 취소 버튼
    override func configUI() {
        view.backgroundColor = .Background
        cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        submitBtn.addTarget(self, action: #selector(submit), for: .touchUpInside)

    }
    @objc func cancel() {
        self.dismiss(animated: true)
    }
    @objc func submit() {
        let emergencyContent = reasonText.text ?? ""
        
        // 파이어베이스 긴급알림업로드.
        let parentUserId = UserDefaults.standard.string(forKey: "ParentUser")!
        let childName = UserDefaults.standard.string(forKey: "ChildName")!

        let emergencyNoti = Notification(id: parentUserId,
                                        postId: "2",
                                        type: .emergency,
                                        childName: childName,
                                         content: emergencyContent,
                                         time: Date().toString())

        FirebaseManager.shared.uploadNotification(notification: emergencyNoti)
        PushNotificationManager.sendPushNotification(to: appDelegate.teacherToken, title: "학부모 긴급 알림입니다.", body: emergencyContent)
//        self.dismiss(animated: true)
//        showToast(message: "긴급상담신청이 완료되었습니다.\n선생님께서 직접 연락드릴 예정입니다.", font: UIFont.systemFont(ofSize: 15))
        
        willDismiss()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.reasonText.endEditing(true)
    }
    
    func willDismiss() {
        delegate?.showToast()
        self.dismiss(animated: true)
    }
}

//MARK: - Extensions
extension UrgentRequestViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    //텍스트뷰 편집 종료 시 내용이 있으면 전송버튼 활성화, 내용이 없으면 플레이스홀더 원복시키고 전송버튼 비활성화 (내용 없이 날아가는 긴급요청 방지)
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textPlaceHolder
            textView.textColor = .lightGray
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        //글자수 300자 제한
        if reasonText.text.count > 300 {
            reasonText.deleteBackward()
        }
        
        if textView.text.isEmpty {
            textView.text = textPlaceHolder
            textView.textColor = .lightGray
            textView.resignFirstResponder()
            submitBtn.setTitleColor(.black, for: .normal)
            submitBtn.isUserInteractionEnabled = false
        } else {
            if !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                submitBtn.setTitleColor(.Action, for: .normal)
                submitBtn.isUserInteractionEnabled = true
            }
        }
    }
}
