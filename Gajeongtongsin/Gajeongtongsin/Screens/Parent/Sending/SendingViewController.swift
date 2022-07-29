//
//  SendingViewController.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

protocol SendingViewControllerDelegate: AnyObject {
    func reloadTable()
}

class SendingViewController: BaseViewController {
    
    //MARK: - Properties
    weak var delegate: SendingViewControllerDelegate?
    
    var currentParent: ParentUser {
        return mainTeacher.parentUsers[0]
    }
    
    //Text Labels (Switch 구문 써서 더 줄일 수 있을지?)
    private let textLabelPurpose: UILabel = {
        let label = UILabel()
        label.text = "용건을 알려주세요"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let textLabelDate: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "일시"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let textLabelReason: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "사유"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    //TODO: -
    //메시지 버튼 내 text와 image 간격 조정, 사이 구분선 삽입
    private let messageTypeButton: UIButton = {
        let button = UIButton()
        button.setTitle("용건 선택", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .secondarySystemFill
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 10
        button.tintColor = .systemGray
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //메시지 내용 전송 버튼
    private let sendButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setTitle("전송", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //Date 입력 관련
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.isHidden = true
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ko-KR")
        picker.minuteInterval = 30
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    
    //사유 입력하는 Text Field View
    //TODO: -
    //Text Field 내 여백 padding 값 조절, 글자수 제한, 박스 외부 클릭했을 때 커서와 키보드 사라지게 등등
    private let textFieldForReason: UITextField = {
        let textF = UITextField()
        textF.isHidden = true
        textF.placeholder = "기본텍스트입니다"
        textF.textColor = .black
        textF.font = .systemFont(ofSize: 17, weight: .medium)
        textF.backgroundColor = .secondarySystemFill
        textF.layer.cornerRadius = 10
        textF.translatesAutoresizingMaskIntoConstraints = false
        return textF
    }()

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldForReason.delegate = self
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        navigationBar()
    }
    
    //MARK: - Funcs
    override func render() {

        view.addSubview(textLabelPurpose)
        textLabelPurpose.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textLabelPurpose.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        textLabelPurpose.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        view.addSubview(messageTypeButton)
        messageTypeButton.topAnchor.constraint(equalTo: textLabelPurpose.bottomAnchor).isActive = true
        messageTypeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        messageTypeButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        messageTypeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
                
        view.addSubview(textLabelDate)
        textLabelDate.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textLabelDate.topAnchor.constraint(equalTo: messageTypeButton.bottomAnchor, constant: 20).isActive = true
        textLabelDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: textLabelDate.bottomAnchor).isActive = true
        messageTypeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 40).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        view.addSubview(textLabelReason)
        textLabelReason.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textLabelReason.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20).isActive = true
        textLabelReason.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true

        view.addSubview(textFieldForReason)
        textFieldForReason.topAnchor.constraint(equalTo: textLabelReason.bottomAnchor).isActive = true
        textFieldForReason.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textFieldForReason.widthAnchor.constraint(equalToConstant: 350).isActive = true
        textFieldForReason.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        view.addSubview(sendButton)
        sendButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 350).isActive = true
        sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true

    }

    override func configUI() {
        view.backgroundColor = .Background
        
        //Message Type 버튼과 선택에 따른 컴포넌트 노출 차이
        messageTypeButton.menu = UIMenu(options: .displayInline, children: [
            UIAction(title: "결석", handler: { [weak self] _ in
                self?.messageTypeButton.setTitle("결석", for: .normal)
                self?.textLabelDate.isHidden = false
                self?.datePicker.isHidden = false
                self?.datePicker.datePickerMode = .date
                self?.textLabelReason.isHidden = false
                self?.textFieldForReason.isHidden = false
                self?.sendButton.isHidden = false
            }),
            UIAction(title: "조퇴", handler: { [weak self] _ in
                self?.messageTypeButton.setTitle("조퇴", for: .normal)
                self?.textLabelDate.isHidden = false
                self?.datePicker.isHidden = false
                self?.datePicker.datePickerMode = .dateAndTime
                self?.textLabelReason.isHidden = false
                self?.textFieldForReason.isHidden = false
                self?.sendButton.isHidden = false
            })
        ])
        
        //프로퍼티 옵저버 구현 고려 중 (날짜, 시간 값이 세팅되어야 사유 입력창 등장)
//        var selectedDate: Date = datePicker.date {
//            didSet {
//                self.textLabelReason.isHidden = false
//                self.textFieldForReason.isHidden = false
//            }
//        }
    }
    
    func navigationBar() {
        self.navigationItem.title = "문자작성"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel)
    }
    
    func msgType() -> MessageType {
        let msgType = messageTypeButton.currentTitle == "결석" ? MessageType.absence : MessageType.earlyLeave
        return msgType
    }
  
    @objc func sendMessage() {
        let newMsg = Message(type: msgType(),
                             sentDate: "Date()",
                             expectedDate: "\(datePicker.date)",
                             content: textFieldForReason.text ?? "",
                             isCompleted: false)
        
        FirebaseManager.shared.uploadMessage(message: newMsg)
        
        mainTeacher.parentUsers[0].sendingMessages.append(newMsg)
        delegate?.reloadTable()
        dismiss(animated: true)
    }
}

extension SendingViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        true
    }
}
