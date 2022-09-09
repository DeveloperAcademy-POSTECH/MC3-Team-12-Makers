//
//  ReservationViewController.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

class ParentsCalenderViewController: BaseViewController {
    
    //MARK: - Properties
    private var choicedCells: [[Bool]] = Array(repeating: Array(repeating: false, count: numberOfSlot), count:5) //복수선택 및 선택취소를 위한 array
//    private var choicedCells: [Bool] = Array(repeating: false, count:6) //복수선택 및 선택취소를 위한 array
    private var submitIndexList: [[Int]] = [[]] //신청버튼 클릭 후 신청내역 인덱스가 저장되는 리스트
    private var appendScheduleList: [ScheduleInfo] = []
    private var subDate: [String] = []
//    private var consultingDateDate: Date
    private var consultingDateList: String = ""
    private var consultingDate: String = "" //consultingDateDate -> consultingDateList -> consultingDate 순으로 탑다운
//    private var startTime: String = ""
    
    private var allSchedules: [(name: String, schedule: [Schedule]?)] = []
    private var startTime: Int = 4
    private var endTime: Int = 10
    private var cellHeight: CGFloat = 0
    private lazy var displayWeek: [String] = nextWeek
    private var displayWeekString: String = "nextWeek"
    
    //다음 일주일의 날짜 리스트를 저장하는 연산 프로퍼티, 아래의 dayIndex 함수에 사용함
    //TODO: 교사 캘린더뷰에서 같이 쓰는 상수이므로 공용화시킬 수 있음
    var nextWeek: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월dd일"
        formatter.timeZone = TimeZone(identifier: "ko_KR")
        var nextWeek = [String]()
         
        for dayCount in 0..<Constants.weekDays {
//            let dayAdded = (86400 * (2+dayCount-todayOfTheWeek+7))
            let dayAdded = (86400 * (2+dayCount-Constants.todayOfTheWeek + 7))
            let oneDayString = formatter.string(from: Date(timeIntervalSinceNow: TimeInterval(dayAdded)))
            nextWeek.append(oneDayString)
        }
        return nextWeek
    }
    
    var thisWeek: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월dd일"
        formatter.timeZone = TimeZone(identifier: "ko_KR")
        var thisWeek = [String]()
         
        for dayCount in 0..<Constants.weekDays {
            let dayAdded = (86400 * (2+dayCount-Constants.todayOfTheWeek))
            let oneDayString = formatter.string(from: Date(timeIntervalSinceNow: TimeInterval(dayAdded)))
            thisWeek.append(oneDayString)
        }
        return thisWeek
    }
    
    //모든 예약일정이 저장되는 리스트
    private lazy var submittedData: [[Int]] = []

    
    // 캘린더뷰
    private let calenderView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
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
    
    private let plusWeek: UIButton = {
        let button = UIButton()
        button.setTitle(">", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.setTitleColor(.LightText, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let minusWeek: UIButton = {
        let button = UIButton()
        button.setTitle("<", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.setTitleColor(.LightText, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegations()
        reasonNote.text = textPlaceHolder
        
        submitBtn.addTarget(self, action: #selector(onTapButton), for: .touchUpInside)
        dismissBtn.addTarget(self, action: #selector(cancelSubmit), for: .touchUpInside)
        plusWeek.addTarget(self, action: #selector(plusWeekTapButton), for: .touchUpInside)
        minusWeek.addTarget(self, action: #selector(minusWeekTapButton), for: .touchUpInside)
        
        startTime = Gajeongtongsin.startTime()
        
        FirebaseManager.shared.fetchParentsReservations { [weak self] schedules in
            if let schedules = schedules {
                self?.allSchedules = []
                self?.allSchedules = self!.scheduledParentsListConVerter(schedules)
                self?.submittedData = self!.submittedDataMaker()
                self?.calenderView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timeResponsiveLabelRander()
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
    
    @objc func plusWeekTapButton() {
        displayWeek = nextWeek
        displayWeekString = "nextWeek"
        for day in 0..<dateLabel.count {
            var date = nextWeek[day].components(separatedBy: "월")
            date = date[1].components(separatedBy: "일")
            dateLabel[day][0].text = date[0]
        }
        
        calenderView.reloadData()
    }
    
    @objc func minusWeekTapButton() {
        displayWeek = thisWeek
        displayWeekString = "thisWeek"
        for day in 0..<dateLabel.count {
            var date = thisWeek[day].components(separatedBy: "월")
            date = date[1].components(separatedBy: "일")
            date = date[0].components(separatedBy: "0")
            dateLabel[day][0].text = date[1]
        }
        calenderView.reloadData()
    }

//선택한 학부모의 신청 요일(날자)를 정수(인덱스) 리스트로 반환해주는 함수
    //TODO: 파베 연결전 교사뷰의 동명 함수와 동일함, 파베 연결된 함수로 공용화
    func dateStringToIndex(parentsIndex: Int) -> [Int] {
        var dateString: [String] = []
        var dateIndex: [Int] = []
        guard let parentSchedules = allSchedules[parentsIndex].schedule else { return []}
        parentSchedules[0].scheduleList.forEach{
            dateString.append($0.consultingDate)
        }
        for day in 0..<dateString.count { //String을 Index로 바꿔줌
            for nextWeekDay in 0..<nextWeek.count {
                if dateString[day] == nextWeek[nextWeekDay] {
                    dateIndex.append(nextWeekDay+5)//임시코드
                }
            }
        }
        return dateIndex
    }
    
    //선택한 학부모의 신청 시간을 정수(인덱스) 리스트로 반환해주는 함수
    //TODO: 파베 연결전 교사뷰의 동명 함수와 동일함, 파베 연결된 함수로 공용화
    func timeStringToIndex(parentIndex: Int) -> [Int] {
        
        var startTimeList:[Int] = []
        guard let parentSchedules = allSchedules[parentIndex].schedule else { return []}
        parentSchedules[0].scheduleList.forEach{
            let timeList = $0.startTime.components(separatedBy: "시")  //[14, 00], [14, 30], [15, 00], ...
            let hour = Int(timeList[0])!-(12+startTime/2) // 14, 14, 15, 15, 16, 16 ... -> 0, 0, 1, 1, 2, 2 ...
            let minute = Int(timeList[1].replacingOccurrences(of: "분", with: ""))!/30 // 00, 30, 00, 30 ... -> 0, 1, 0, 1, ...
            startTimeList.append(hour*2 + minute)
        }
        
        return startTimeList
    }
    
    //모든 예약일정을 인덱스로 저장해주는 함수, 교사뷰의 동명 함수와 다름!!
    func submittedDataMaker() -> [[Int]] {
    var calenderData: [[Int]] = []
        
        for parentsIndex in 0 ..< allSchedules.count {
            guard let parentSchedules = allSchedules[parentsIndex].schedule else { return []}
            
            for scheduleIndex in 0 ..< parentSchedules[0].scheduleList.count {
                
                    let rowIndex = timeStringToIndex(parentIndex: parentsIndex)[scheduleIndex]
                    let columnIndex = dateStringToIndex(parentsIndex: parentsIndex)[scheduleIndex]
                    calenderData.append([columnIndex, rowIndex])

            }
            
        }
        return calenderData
    }
    
    func dateIndexToString(index: Int) -> String {
        return nextWeek[index]
    }
    
    func timeIndexToString(index: Int) -> String {
        
        let rowInCalender = index
        let hour = String(12 + startTime/2 + (rowInCalender)/2) //14시 + @
        let minute: String = (rowInCalender) % 2 == 0 ? "00" : "30" //짝수줄은 정각, 홀수줄은 30분
        let time = hour+"시"+minute+"분"
        
        return time
    }
    //신청하기 누르면 리로드 & 신청요일, 시간 mackdata에 추가 / print
    @objc func onTapButton() {
        appendScheduleList = []
        
        for section in 0..<choicedCells.count {
            let subListInSection = choicedCells[section].enumerated().compactMap { (idx, element) in element ? idx : nil }
            submitIndexList.append(subListInSection)
        
        
        for index in subListInSection {
            appendScheduleList.append(ScheduleInfo(

                consultingDate: dateIndexToString(index: section),
                startTime: timeIndexToString(index: index),
                isReserved: false))
        }
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
        

        choicedCells = Array(repeating: Array(repeating: false, count: numberOfSlot), count:5)

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
        
        view.addSubview(plusWeek)
        plusWeek.topAnchor.constraint(equalTo: calenderView.topAnchor, constant: -70).isActive = true
        plusWeek.centerXAnchor.constraint(equalTo: calenderView.trailingAnchor, constant: 0).isActive = true
        
        view.addSubview(minusWeek)
        minusWeek.topAnchor.constraint(equalTo: calenderView.topAnchor, constant: -70).isActive = true
        minusWeek.centerXAnchor.constraint(equalTo: calenderView.leadingAnchor, constant: -10).isActive = true

        
        for index in dateLabel.indices {
            view.addSubview(dateLabel[index][0])
            dateLabel[index][0].topAnchor.constraint(equalTo: calenderView.topAnchor, constant: -70).isActive = true
            dateLabel[index][0].centerXAnchor.constraint(equalTo: calenderView.leadingAnchor, constant: CGFloat(index)*Constants.interval+Constants.interval/2).isActive = true
            
            view.addSubview(dateLabel[index][1])
            dateLabel[index][1].topAnchor.constraint(equalTo: calenderView.topAnchor, constant: -40).isActive = true
            dateLabel[index][1].centerXAnchor.constraint(equalTo: calenderView.leadingAnchor, constant: CGFloat(index)*Constants.interval + Constants.interval/2).isActive = true
        }
        for index in 0..<9 {
            view.addSubview(hourLabel[index])
        }

    }
    

    
    func timeResponsiveLabelRander() {
        let timeInterval = (endTime-startTime)/2
        let interval: CGFloat = (endTime-startTime)%2 == 0 ? 300/CGFloat(timeInterval) : (300-(300/CGFloat(endTime-startTime)))/CGFloat(timeInterval)
        
        let appendTime: Int = 12+startTime/2
        
        for index in 0..<9 {
            if index<=timeInterval {
                hourLabel[index].centerYAnchor.constraint(equalTo: calenderView.topAnchor, constant: interval*CGFloat(index)).isActive = true
                hourLabel[index].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
                hourLabel[index].text = "\(index+appendTime)"+"h"
            }else {
                hourLabel[index].text = ""
            }
            
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

extension ParentsCalenderViewController: UICollectionViewDataSource{
    
    //섹션 수
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return Constants.weekDays
    }
    
    //섹션 내 아이템 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == calenderView {
            startTime = numberOfSlot
            endTime = 0 //min, max 돌아가기 오류 보정을 위한 초기화
            for section in 0..<Constants.weekDays {
                startTime = min(calenderSlotData.blockedSlot[section].firstIndex(of: false) ?? 0, startTime)
                endTime = max((calenderSlotData.blockedSlot[section].lastIndex(of: false) ?? numberOfSlot)+1, endTime)
            }
            cellHeight = 300.0/(CGFloat(endTime-startTime))
        }
        return endTime-startTime
    }
 }

extension ParentsCalenderViewController: UICollectionViewDelegate{
    
    //cell 로드
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           guard let cell = collectionView.dequeueReusableCell(
           withReuseIdentifier: CalenderViewCell.identifier ,
           for: indexPath) as? CalenderViewCell else {
               return UICollectionViewCell()
           }
        cell.backgroundColor = .white
        
        let correctionIndex = indexPath.item+startTime
        if displayWeekString == "thisWeek" && submittedData.contains([indexPath.section, indexPath.item]) {
            cell.backgroundColor = .lightGray
        }
        if displayWeekString == "nextWeek" && submittedData.contains([indexPath.section+5, indexPath.item]) {
            cell.backgroundColor = .lightGray
        }
        if calenderSlotData.blockedSlot[indexPath.section][correctionIndex] {
            cell.backgroundColor = .Background

        }
        
        return cell
    }
    
    //캘린더 클릭 액션
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CalenderViewCell
        
        //선택한 슬롯 개수 카운터
        let truCnt = choicedCells.flatMap{$0}.filter({$0 == true}).count
        
        if !submittedData.contains([indexPath.section, indexPath.item]) && calenderSlotData.blockedSlot[indexPath.section][indexPath.item] {
            //갯수 3개로 제한 및 선택 토글  +섹션 나눠서 인덱싱 편하게 하기?
            if truCnt<3 && !choicedCells[indexPath.section][indexPath.item]{
                choicedCells[indexPath.section][indexPath.item] = true
                cell?.backgroundColor = .Action
            }else if choicedCells[indexPath.section][indexPath.item]{
                choicedCells[indexPath.section][indexPath.item] = false
                cell?.backgroundColor = .white
            }
        }
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
