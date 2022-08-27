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
        
    //Text Labels
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
        button.setTitle("용건 선택   ", for: .normal)
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
    
    //메시지 전송 버튼 (primary button 활용)
    private var sendButton: PrimaryButton = {
        let button = PrimaryButton(buttonTitle: "전송", buttonState: .disabled)
        return button
    }()
    
    //Date 입력 관련
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.isHidden = true
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ko_KR")
        picker.timeZone = TimeZone(identifier: "ko_KR")
        picker.minuteInterval = 30
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    
    //사유 입력하는 Text Field View
    private let textFieldForReason: UITextField = {
        let textF = UITextField()
        let leftMargin = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: textF.frame.height))
        textF.isHidden = true
        textF.placeholder = "결석사유를 입력해주세요 (20자)"
        textF.leftView = leftMargin
        textF.leftViewMode = .always
        textF.clearButtonMode = .whileEditing
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
        textFieldForReason.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = ""
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
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
        sendButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    override func configUI() {
        view.backgroundColor = .Background
        sendButton.addTarget(self, action: #selector(sendAlert), for: .touchUpInside)
        
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
    }
    
    //용건 기입 마칠 때 내용있는지 여부 체크해서 전송버튼 활성화
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textFieldForReason.endEditing(true)
    }

    func msgType() -> MessageType {
        let msgType = messageTypeButton.currentTitle == "결석" ? MessageType.absence : MessageType.earlyLeave
        return msgType
    }
    
    func dateType() -> String {
        let dateType = messageTypeButton.currentTitle == "결석" ? "\(datePicker.date.toString())" : "\(datePicker.date.toStringWithTime())"
        return dateType
    }
    
    @objc func sendAlert() {
        let alert = UIAlertController(title: "쪽지를 전송하시겠습니까?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let okayAction = UIAlertAction(title: "전송", style: .default) { _ in
            self.sendMessage()
        }
        alert.addAction(cancelAction)
        alert.addAction(okayAction)
        self.present(alert, animated: true)
    }
    
    func sendMessage() {
        let newMsg = Message(type: msgType(),

                             sentDate: Date().toString(),
                             expectedDate: dateType(),
                             content: textFieldForReason.text ?? "",
                             isCompleted: false)
        
        FirebaseManager.shared.uploadMessage(message: newMsg)
        delegate?.reloadTable()
        navigationController?.popViewController(animated: true)
    }
    
    //텍스트 필드 검사 후 변경 적용
    @objc func textFieldDidChange() {
        if textFieldForReason.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            sendButton.changeState(buttonState: .normal)
        } else {
            sendButton.changeState(buttonState: .disabled)
        }
    }

}

//MARK: - Extensions
extension SendingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //글자수 20자 도달했을 때 백스페이스 감지 (코드 이해 못함)
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        //글자수 20자 제한
        guard textField.text?.count ?? 0 < 20 else { return false }

        let textDetector = textFieldForReason.text
        if textDetector?.count != 0 {
            sendButton.changeState(buttonState: .normal)
        } else {
            sendButton.changeState(buttonState: .disabled)
        }

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
