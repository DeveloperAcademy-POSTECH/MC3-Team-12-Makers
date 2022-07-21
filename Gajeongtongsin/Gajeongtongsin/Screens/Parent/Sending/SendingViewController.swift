//
//  SendingViewController.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

class SendingViewController: BaseViewController {
    
    //MARK: - Properties
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
//        label.isHidden = true
        label.text = "일시"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let textLabelReason: UILabel = {
        let label = UILabel()
//        label.isHidden = true
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
    
    //MARK: - Propoerties
    //Date 입력 관련
    //TODO: -
    //messagetype 에서 결석을 선택할 때와 조퇴를 선택할 때 pickermode 변경
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
//        picker.isHidden = true
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ko-KR")
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    //MARK: - Properties
    //사유 입력하는 Text Field View
    //TODO: -
    //Text Field 내 여백 padding 값 조절, 글자수 제한, 박스 외부 클릭했을 때 커서와 키보드 사라지게 등등
    private let textFieldForReason: UITextField = {
        let textF = UITextField()
//        textF.isHidden = true
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
    }

    override func configUI() {
        view.backgroundColor = .primaryBackground
        
        //Message Type 버튼과 선택에 따른 컴포넌트 노출 차이
        messageTypeButton.menu = UIMenu(options: .displayInline, children: [
            UIAction(title: "결석", handler: { _ in
                self.messageTypeButton.setTitle("결석", for: .normal)
//                self.textLabelDate.isHidden = false
//                self.datePicker.isHidden = false
                self.datePicker.datePickerMode = .date
                print("결석 누름")
            }),
            UIAction(title: "조퇴", handler: { _ in
                self.messageTypeButton.setTitle("조퇴", for: .normal)
//                self.textLabelDate.isHidden = false
//                self.datePicker.isHidden = false
                self.datePicker.datePickerMode = .dateAndTime
                print("조퇴 누름")
            })
        ])
        
    }
}

extension SendingViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        true
    }
}
