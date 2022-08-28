//
//  ReservationViewController.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

class ParentsCalenderViewController: BaseViewController {
    
    //MARK: - Properties
    private var choicedCells: [Bool] = Array(repeating: false, count:30) //복수선택 및 선택취소를 위한 array
    private var submitIndexList: [Int] = [] //신청버튼 클릭 후 신청내역 인덱스가 저장되는 리스트
    private var appendScheduleList: [ScheduleInfo] = []
    private var subDate: [String] = []
    private var allSchedules: [(name: String, schedule: [Schedule]?)] = []
    private var submittedData: [Int] = []     //모든 예약일정이 저장되는 리스트
    private let textPlaceHolder: String = "어떤 내용으로 상담을 신청하시나요?"
    
    // 캘린더뷰
    private let calenderView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CalenderViewCell.self, forCellWithReuseIdentifier: CalenderViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // 취소 버튼
    private let dismissBtn: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor.Action, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // 신청 버튼
    private let submitBtn: UIButton = {
        let button = UIButton()
        button.setTitle("신청", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.isUserInteractionEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let noteTitle: UILabel = {
        let label = UILabel()
        label.text = "상담용건"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //사유 입력 text view
    private let reasonNote: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        textView.isEditable = true
        textView.textColor = .LightText
        textView.font = .systemFont(ofSize: 15)
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        textView.layer.cornerRadius = 10
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    //캘린더 시간 레이블
     private lazy var hourLabel: [UILabel] = Constants.hourLabelMaker()
    //캘린더 날자 레이블
     private lazy var dateLabel: [[UILabel]] = Constants.dateLabelMaker()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegations()
        reasonNote.text = textPlaceHolder
        
        submitBtn.addTarget(self, action: #selector(onTapButton), for: .touchUpInside)
        dismissBtn.addTarget(self, action: #selector(cancelSubmit), for: .touchUpInside)
        
        FirebaseManager.shared.fetchParentsReservations { [weak self] schedules in
            if let schedules = schedules {
                self?.allSchedules = []
                self?.allSchedules = self!.scheduledParentsListConVerter(schedules)
                self?.submittedData = self!.submittedDataMaker()
                self?.calenderView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotification()
    }
    
    //MARK: - Funcs
    
    // 딜리게이트 설정
    func setDelegations() {
        calenderView.delegate = self
        calenderView.dataSource = self
        reasonNote.delegate = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.reasonNote.endEditing(true)
    }
    
    func scheduledParentsListConVerter(_ allSchedules: [String:[Schedule]]) -> [(String, [Schedule]?)] {
        var scheduledParentsList: [(String, [Schedule]?)] = []
        for key in allSchedules.keys {
            scheduledParentsList.append((key,allSchedules[key]))
        }
        return scheduledParentsList
    }
    
    //모든 예약일정을 인덱스로 저장해주는 함수, 교사뷰의 동명 함수와 다름!!
    func submittedDataMaker() -> [Int] {
        var calenderData: [Int] = []
        
        for parentsIndex in 0 ..< allSchedules.count {
            guard let parentSchedules = allSchedules[parentsIndex].schedule else { return []}
            
            for scheduleIndex in 0 ..< parentSchedules[0].scheduleList.count {
                
                let rowIndex = Constants.timeStringToIndex(selected: parentSchedules)[scheduleIndex] * Constants.weekDays
                let columnIndex = Constants.dateStringToIndex(selected: parentSchedules)[scheduleIndex]
                calenderData.append(rowIndex + columnIndex)
            }
            
        }
        return calenderData
    }
    
    //신청하기 누르면 리로드 & 신청요일, 시간 mackdata에 추가 / print
    @objc func onTapButton() {
        appendScheduleList = []
        submitIndexList = choicedCells.enumerated().compactMap { (idx, element) in element ? idx : nil }
        
        for index in submitIndexList {
            appendScheduleList.append(ScheduleInfo(
                
                consultingDate: Constants.dateIndexToString(index: index),
                startTime: Constants.timeIndexToString(index: index),
                isReserved: false))
        }
        // 파이어베이스 예약업로드 & 알림
        let schedule = Schedule(reservedDate: "실시간",     // FIXME: - 수정 필요
                                scheduleList: appendScheduleList,
                                content: reasonNote.text)
        
        FirebaseManager.shared.uploadReservations(schedule: schedule)
        
        let parentUserId = UserDefaults.standard.string(forKey: "ParentUser")!
        let childName = UserDefaults.standard.string(forKey: "ChildName")!
        
        let reservationNoti = Notification(id: parentUserId,
                                           postId: "2", // FIXME: - 수정 필요
                                           type: .reservation,
                                           childName: childName,
                                           content: reasonNote.text,
                                           time: Date().toString())
        
        FirebaseManager.shared.uploadNotification(notification: reservationNoti)
        
        //TODO : - parentList index를 id 받아서 넣어주어야 함
        choicedCells = Array(repeating: false, count:30)
        calenderView.reloadData()
        self.dismiss(animated: true)
    }
   
    
    override func render() {
        view.addSubview(dismissBtn)
        dismissBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        dismissBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        
        view.addSubview(submitBtn)
        submitBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        submitBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        calenderView.heightAnchor.constraint(equalToConstant: Constants.calenderHeigit).isActive = true
        calenderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.calenderSidePadding[0]).isActive = true
        calenderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.calenderSidePadding[1]).isActive = true
        
        view.addSubview(noteTitle)
        noteTitle.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -250).isActive = true
        noteTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        noteTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        noteTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(reasonNote)
        reasonNote.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110).isActive = true
        reasonNote.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        reasonNote.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        reasonNote.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        for index in hourLabel.indices {
            view.addSubview(hourLabel[index])
            hourLabel[index].centerYAnchor.constraint(equalTo: calenderView.topAnchor, constant: CGFloat(index*100)).isActive = true
            hourLabel[index].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        }
        
        for index in dateLabel.indices {
            view.addSubview(dateLabel[index][0])
            dateLabel[index][0].topAnchor.constraint(equalTo: calenderView.topAnchor, constant: -70).isActive = true
            dateLabel[index][0].centerXAnchor.constraint(equalTo: calenderView.leadingAnchor, constant: CGFloat(index)*Constants.interval+Constants.interval/2).isActive = true
            
            view.addSubview(dateLabel[index][1])
            dateLabel[index][1].topAnchor.constraint(equalTo: calenderView.topAnchor, constant: -40).isActive = true
            dateLabel[index][1].centerXAnchor.constraint(equalTo: calenderView.leadingAnchor, constant: CGFloat(index)*Constants.interval + Constants.interval/2).isActive = true
        }
    }
    
    override func configUI() {
        view.backgroundColor = .Background
    }
    
    //캘린더뷰 신청 취소
    @objc func cancelSubmit() {
        self.dismiss(animated: true)
    }
    
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ noti: NSNotification) {
        //키보드 높이만큼 화면 올리기
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y = ( -keyboardHeight + 50)
        }
    }
    
    @objc func keyboardWillHide(_ noti: NSNotification){
        //키보드 높이만큼 화면 내리기
        self.view.frame.origin.y = 0
    }
    
}


//MARK: - Extensions
extension ParentsCalenderViewController: UICollectionViewDelegate{
    
    //cell 로드
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalenderViewCell.identifier ,
            for: indexPath) as? CalenderViewCell else {
            return UICollectionViewCell()
        }
        //        cell.backgroundColor = submittedData.conta .white
        if submittedData.contains(indexPath.item) {
            cell.backgroundColor = .lightGray
        }
        
        return cell
    }
    
    //캘린더 클릭 액션
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CalenderViewCell
        
        //선택한 슬롯 개수 카운터
        let truCnt = choicedCells.filter({$0 == true}).count
        
        if submittedData.contains(indexPath.item) != true {
            //갯수 3개로 제한 및 선택 토글  +섹션 나눠서 인덱싱 편하게 하기?
            if truCnt<3 && !choicedCells[indexPath.item] {
                choicedCells[indexPath.item].toggle()
                cell?.backgroundColor = .Action
            }else if truCnt<=3 && choicedCells[indexPath[1]]{
                choicedCells[indexPath.item].toggle()
                cell?.backgroundColor = .white
            }
        }
    }
}

extension ParentsCalenderViewController: UICollectionViewDataSource{
    
    //캘린더 아이템 수, 5일*6단위 = 30
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return choicedCells.count
    }
}

extension ParentsCalenderViewController: UICollectionViewDelegateFlowLayout {
    
    //cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: Constants.interval, height: 50)
    }
    
    //cell 횡간 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return CGFloat(0)
    }
    
    //cell 종간 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
}

extension ParentsCalenderViewController: UITextViewDelegate {
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
