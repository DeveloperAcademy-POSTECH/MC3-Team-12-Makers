//
//  SendingViewController.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

class SendingViewController: BaseViewController {
    
    var typed: MessageType = .absence
    var opacityInt: Float = 0.0
    
    //MARK: - Text Labels (Switch 구문 써서 더 줄일 수 있을지?)
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
        label.text = "일시"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let textLabelReason: UILabel = {
        let label = UILabel()
        label.text = "사유"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties & Func (Message Type 선택 후 Date picker 다르게 노출)
    private let messageTypes: [UIAction] = [
        //TODO: - Messasge Type의 Absence, EarlyLeave와 연결하여 후속 작업 필요. "용건 선택" -> 결석 or 조퇴로 텍스트 변환. Date Picker 띄우기, 사유 쓰기, 데이터를 String으로 보내기 -> Firebase
        UIAction(title: "결석", handler: { _ in
            print("결석 누름")
            }),
        UIAction(title: "조퇴", handler: { _ in
            print("조퇴 누름")
            })
    ]

    //TODO: - 메시지 버튼 내 text와 image 간격 조정, 사이 구분선 삽입
    private lazy var messageTypeButton: UIButton = {
        var button = UIButton()
        button.setTitle("용건 선택", for: .normal)
        button.setTitle("결석", for: .selected)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .secondarySystemFill
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 10
        button.tintColor = .systemGray
        button.addAction(UIAction(handler: { _ in
            self.opacityInt = 1.0
        }), for: .touchUpInside)
        button.menu = UIMenu(options: UIMenu.Options.displayInline,
                             children: messageTypes)
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Date Picker Propoerties
    //TODO: - messagetype 에서 결석을 선택할 때와 조퇴를 선택할 때 pickermode 변경
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ko-KR")
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    //MARK: - 사유 입력 Text Field Property
    //TODO: - Text Field 내 여백 padding 값 조절, 글자수 제한, 박스 외부 클릭했을 때 커서와 키보드 사라지게 등등
    let textFieldForReason: UITextField = {
        let textF = UITextField()
        textF.text = "기본텍스트입니다"
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

    }
    //MARK: - Funcs
    override func render() {
        //MARK: - 결석, 조퇴 선택
        view.addSubview(textLabelPurpose)
        textLabelPurpose.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textLabelPurpose.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        textLabelPurpose.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        view.addSubview(messageTypeButton)
        messageTypeButton.topAnchor.constraint(equalTo: textLabelPurpose.bottomAnchor).isActive = true
        messageTypeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        messageTypeButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        messageTypeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        //MARK: - 날짜 (시간) 선택
        
        view.addSubview(textLabelDate)
        textLabelDate.layer.opacity = 1.0 //opacityInt
        textLabelDate.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textLabelDate.topAnchor.constraint(equalTo: messageTypeButton.bottomAnchor, constant: 20).isActive = true
        textLabelDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        view.addSubview(datePicker)
        datePicker.layer.opacity = 1.0 //opacityInt
        datePicker.topAnchor.constraint(equalTo: textLabelDate.bottomAnchor).isActive = true
        messageTypeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 40).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        //MARK: - 사유 입력
        view.addSubview(textLabelReason)
        textLabelReason.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textLabelReason.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20).isActive = true
        textLabelReason.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true

        view.addSubview(textFieldForReason)
        textFieldForReason.topAnchor.constraint(equalTo: textLabelReason.bottomAnchor).isActive = true
        textFieldForReason.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textFieldForReason.widthAnchor.constraint(equalToConstant: 350).isActive = true
        textFieldForReason.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    }

    override func configUI() {
        view.backgroundColor = .primaryBackground

    }
}

extension SendingViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        true
    }
}
