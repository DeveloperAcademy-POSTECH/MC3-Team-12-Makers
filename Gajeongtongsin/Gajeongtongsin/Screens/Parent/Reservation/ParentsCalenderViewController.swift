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
//    private var consultingDateDate: Date
    private var consultingDateList: String = ""
    private var consultingDate: String = "" //consultingDateDate -> consultingDateList -> consultingDate 순으로 탑다운
    private var startTime: String = ""
    
//    private var panddedCellList: [Int] = mainTeacher.parentUsers.flatMap{
//        $0.schedules[0].scheduleList.flatMap{
//            $0.consultingDate
//        }
//    }
    private var allSchedules: [(name: String, schedule: [Schedule]?)] = []
    
    //다음 일주일의 날짜 리스트를 저장하는 연산 프로퍼티, 아래의 dayIndex 함수에 사용함
    //TODO: 교사 캘린더뷰에서 같이 쓰는 상수이므로 공용화시킬 수 있음
    var nextWeek: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월dd일"
        formatter.timeZone = TimeZone(identifier: "ko_KR")
        var nextWeek = [String]()
         
        for dayCount in 0..<weekDays {
//            let dayAdded = (86400 * (2+dayCount-todayOfTheWeek+7))
            let dayAdded = (86400 * (2+dayCount-todayOfTheWeek))
            let oneDayString = formatter.string(from: Date(timeIntervalSinceNow: TimeInterval(dayAdded)))
            nextWeek.append(oneDayString)
        }
        return nextWeek
    }
    
    //모든 예약일정이 저장되는 리스트
    private lazy var submittedData: [Int] = submittedDataMaker()

    
    // 캘린더뷰
    private let calenderView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CalenderViewCell.self, forCellWithReuseIdentifier: CalenderViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false //필수 !!
        return collectionView
    }()

    
    // 신청/취소 버튼
    private let dismissBtn: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let submitBtn: UIButton = {
        let button = UIButton()
        button.setTitle("신청", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
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
        let note = UITextView()
        note.text = "어떤 내용으로 상담을 신청하시나요?"
        note.textColor = .LightText
        note.font = .systemFont(ofSize: 15)
        note.clearsOnInsertion = false
        note.layer.borderWidth = 0.5
        note.layer.borderColor = UIColor.LightLine.cgColor
        note.translatesAutoresizingMaskIntoConstraints = false
        return note
    }()
    
    //캘린더 시간 레이블
    lazy private var hourLabel: [UILabel] = Constants.hourLabelMaker()
    
    //캘린더 날자 레이블
    lazy private var dateLabel: [[UILabel]] = Constants.dateLabelMaker()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        calenderView.delegate = self
        calenderView.dataSource = self
        
        submitBtn.addTarget(self, action: #selector(onTapButton), for: .touchUpInside)
        dismissBtn.addTarget(self, action: #selector(cancelSubmit), for: .touchUpInside)
        
        FirebaseManager.shared.fetchParentsReservations { [weak self] schedules in
            if let schedules = schedules {
                self?.allSchedules = []
                self?.allSchedules = self!.scheduledParentsListConVerter(schedules)
                self?.calenderView.reloadData()
            }
        }
    }
        
    //MARK: - Funcs
    
    func scheduledParentsListConVerter(_ allSchedules: [String:[Schedule]]) -> [(String, [Schedule]?)] {
        var scheduledParentsList: [(String, [Schedule]?)] = []
        for key in allSchedules.keys {
                scheduledParentsList.append((key,allSchedules[key]))
        }
        return scheduledParentsList
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
                    dateIndex.append(nextWeekDay)
                }
            }
        }
        return dateIndex
    }
    
    //선택한 학부모의 신청 시간을 정수(인덱스) 리스트로 반환해주는 함수
    //TODO: 파베 연결전 교사뷰의 동명 함수와 동일함, 파베 연결된 함수로 공용화
    func timeStringToIndex(parentIndex: Int) -> [Int] {
        var startTime:[Int] = []
        guard let parentSchedules = allSchedules[parentIndex].schedule else { return []}
        parentSchedules[0].scheduleList.forEach{
            let timeList = $0.startTime.components(separatedBy: "시")  //[14, 00], [14, 30], [15, 00], ...
            let hour = Int(timeList[0])!-14 // 14, 14, 15, 15, 16, 16 ... -> 0, 0, 1, 1, 2, 2 ...
            let minute = Int(timeList[1].replacingOccurrences(of: "분", with: ""))!/30 // 00, 30, 00, 30 ... -> 0, 1, 0, 1, ...
            startTime.append(hour*2 + minute)
        }
        
        return startTime
    }
    
    //모든 예약일정을 인덱스로 저장해주는 함수, 교사뷰의 동명 함수와 다름!!
    func submittedDataMaker() -> [Int] {
    var calenderData: [Int] = []
        
        for parentsIndex in 0 ..< allSchedules.count {
            guard let parentShedules = allSchedules[parentsIndex].schedule else { return []}

            for scheduleIndex in 0 ..< parentShedules[0].scheduleList.count {
                
                    let rowIndex = timeStringToIndex(parentIndex: parentsIndex)[scheduleIndex] * weekDays
                    let columnIndex = dateStringToIndex(parentsIndex: parentsIndex)[scheduleIndex]
                    calenderData.append(rowIndex + columnIndex)
            }
            
        }
        return calenderData
    }
    
    func dateIndexToString(index: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월dd일"
        formatter.timeZone = TimeZone(identifier: "ko_KR")
        let daysAfterToday = (7+(index%weekDays+2)-todayOfTheWeek) //+2는 dateFormat 보정(월요일이 2), +7은 다음주 캘린더가 표시되도록
        let consultingDateDate = Date(timeIntervalSinceNow: TimeInterval((secondsInDay * daysAfterToday)))
        
        consultingDateList = formatter.string(from: consultingDateDate) //Date -> [String]
        consultingDate = consultingDateList //[String] -> String
        return consultingDate
    }
    
    func timeIndexToString(index: Int) -> String {
        let rowInCalender = index/weekDays
        let hour = String(14 + (rowInCalender)/2) //14시 + @
        let minute: String = (rowInCalender) % 2 == 0 ? "00" : "30" //짝수줄은 정각, 홀수줄은 30분
        startTime = hour+"시"+minute+"분"
        
        return startTime
    }
    
    //신청하기 누르면 리로드 & 신청요일, 시간 mackdata에 추가 / print
    @objc func onTapButton() {
        
        appendScheduleList = []
        submitIndexList = choicedCells.enumerated().compactMap { (idx, element) in element ? idx : nil }
        
        for index in submitIndexList {
            appendScheduleList.append(ScheduleInfo(

                consultingDate: dateIndexToString(index: index),
                startTime: timeIndexToString(index: index),
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
    let calenderTopPadding = CGFloat(140.0)
    let calenderSidePadding = [CGFloat(50.0),CGFloat(20.0)]
    let calenderHeigit = CGFloat(300.0)
    
    override func render() {
        view.addSubview(dismissBtn)
        dismissBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        dismissBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true

        view.addSubview(submitBtn)
        submitBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        submitBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true

        view.addSubview(calenderView)

        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: calenderTopPadding).isActive = true
        calenderView.heightAnchor.constraint(equalToConstant: calenderHeigit).isActive = true
        calenderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: calenderSidePadding[0]).isActive = true
        calenderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -calenderSidePadding[1]).isActive = true

        
        view.addSubview(noteTitle)
        noteTitle.topAnchor.constraint(equalTo: calenderView.topAnchor, constant: 330).isActive = true
        noteTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        noteTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        noteTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(reasonNote)
        reasonNote.topAnchor.constraint(equalTo: noteTitle.topAnchor, constant: 35).isActive = true
        reasonNote.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        reasonNote.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        reasonNote.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        for index in 0..<hourLabel.count {
            view.addSubview(hourLabel[index])
            hourLabel[index].centerYAnchor.constraint(equalTo: calenderView.topAnchor, constant: CGFloat(index*100)).isActive = true
            hourLabel[index].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        }
        
        let interval = CGFloat((UIScreen.main.bounds.width-(calenderSidePadding[0]+calenderSidePadding[1]))/5)
        
        for index in 0..<dateLabel.count {
            view.addSubview(dateLabel[index][0])
            dateLabel[index][0].topAnchor.constraint(equalTo: calenderView.topAnchor, constant: -70).isActive = true
            dateLabel[index][0].centerXAnchor.constraint(equalTo: calenderView.leadingAnchor, constant: CGFloat(index)*interval+interval/2).isActive = true
            
            view.addSubview(dateLabel[index][1])
            dateLabel[index][1].topAnchor.constraint(equalTo: calenderView.topAnchor, constant: -40).isActive = true
            dateLabel[index][1].centerXAnchor.constraint(equalTo: calenderView.leadingAnchor, constant: CGFloat(index)*interval+interval/2).isActive = true
        }
    }

    override func configUI() {
        view.backgroundColor = .Background
    }
    
    //캘린더뷰 신청 취소
    @objc func cancelSubmit() {
        self.dismiss(animated: true)
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
        return CGSize(width: (UIScreen.main.bounds.width-(calenderSidePadding[0]+calenderSidePadding[1]))/5, height: 50)
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
