//
//  ProfileViewController.swift
//  Gajeongtongsin
//
//  Created by Beone on 2022/08/29.


import UIKit

class ProfileViewController: BaseViewController {
    
    //MARK: - Properties
    private var choicedCells: [[Bool]] = Array(repeating: Array(repeating: false, count: 18), count:5) //복수선택 및 선택취소를 위한 array
//    private var choicedCells: [Bool] = Array(repeating: false, count:6) //복수선택 및 선택취소를 위한 array
    private var submitIndexList: [[Int]] = [[]] //신청버튼 클릭 후 신청내역 인덱스가 저장되는 리스트
//    private var blockedScheduleList: [ScheduleInfo] = []
    private var blockedSlotList: [[Int]] = []
    private var subDate: [String] = []
//    private var consultingDateDate: Date
    private var consultingDateList: String = ""
    private var consultingDate: String = "" //consultingDateDate -> consultingDateList -> consultingDate 순으로 탑다운
    private var startTime: String = ""
    
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
            let dayAdded = (86400 * (2+dayCount-todayOfTheWeek + 7))
            let oneDayString = formatter.string(from: Date(timeIntervalSinceNow: TimeInterval(dayAdded)))
            nextWeek.append(oneDayString)
        }
        return nextWeek
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

    
    // 확인 버튼
    
    private let submitBtn: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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

        
        FirebaseManager.shared.fetchParentsReservations { [weak self] schedules in
            if let schedules = schedules {
                self?.allSchedules = []
                self?.allSchedules = self!.scheduledParentsListConVerter(schedules)
                self?.submittedData = self!.submittedDataMaker()
                self?.calenderView.reloadData()
            }
        }
    }
    
    func viewDidAppear() {
        calenderView.reloadData()
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
            let hour = Int(timeList[0])!-12 // 14, 14, 15, 15, 16, 16 ... -> 0, 0, 1, 1, 2, 2 ...
            let minute = Int(timeList[1].replacingOccurrences(of: "분", with: ""))!/30 // 00, 30, 00, 30 ... -> 0, 1, 0, 1, ...
            startTime.append(hour*2 + minute)
        }
        
        return startTime
    }
    
    //모든 예약일정을 인덱스로 저장해주는 함수, 교사뷰의 동명 함수와 다름!!
    func submittedDataMaker() -> [[Int]] {
    var calenderData: [[Int]] = []
        
        for parentsIndex in 0 ..< allSchedules.count {
            guard let parentShedules = allSchedules[parentsIndex].schedule else { return []}

            for scheduleIndex in 0 ..< parentShedules[0].scheduleList.count {
                
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
        let hour = String(12+startIndex/2 + (rowInCalender)/2) //14시 + @
        let minute: String = (rowInCalender) % 2 == 0 ? "00" : "30" //짝수줄은 정각, 홀수줄은 30분
        startTime = hour+"시"+minute+"분"
        
        return startTime
    }
    
    //신청하기 누르면 리로드 & 신청요일, 시간 mackdata에 추가 / printㅓㅡㅜㅗㅡㅓㅜㅗㅅ
    @objc func onTapButton() {
        
//        blockedScheduleList = []
//        blockedSlotList = []
        for section in 0..<choicedCells.count {
            let blockedSlotInSection = choicedCells[section].enumerated().compactMap { (idx, element) in element ? idx : nil }
//            submitIndexList.append(blockedSlotInSection)

            for index in blockedSlotInSection {
                calenderSlotData.blockedSlot[section][index].toggle()
            }
        }
//        choicedCells.ForEach {
//            if calenderSlotData.blockedSlot.contains(choicedCells) {
//                calenderSlotData.blockedSlot.remove(at: calenderSlotData.blockedSlot.first(choicedCells))
//            }
//        }
        
        choicedCells = Array(repeating: Array(repeating: false, count: 18), count:5)
        calenderView.reloadData()
    }
    let calenderTopPadding = CGFloat(140.0)
    let calenderSidePadding = [CGFloat(50.0),CGFloat(20.0)]
    let calenderHeigit = CGFloat(550.0)
    
    override func render() {

        view.addSubview(calenderView)

        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: calenderTopPadding).isActive = true
        calenderView.heightAnchor.constraint(equalToConstant: calenderHeigit).isActive = true
        calenderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: calenderSidePadding[0]).isActive = true
        calenderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -calenderSidePadding[1]).isActive = true

        view.addSubview(submitBtn)
        submitBtn.topAnchor.constraint(equalTo: calenderView.bottomAnchor, constant: 20).isActive = true
        submitBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        
        for index in 0...9 {
            view.addSubview(hourLabel[index])
            hourLabel[index].centerYAnchor.constraint(equalTo: calenderView.topAnchor, constant: calenderHeigit/9*CGFloat(index)).isActive = true
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

}

func startTime() -> Int {
    var startTimee = 18
    for section in 0..<weekDays {
        startTimee = min(calenderSlotData.blockedSlot[section].firstIndex(of: false) ?? 0, startTimee)
    }
    return startTimee
}
let startIndex = startTime()
    

//MARK: - Extensions

extension ProfileViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        weekDays
    }
    
    //캘린더 아이템 수, 5일*6단위 = 30
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        18
    }
 }

extension ProfileViewController: UICollectionViewDelegate{
    
    //cell 로드
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           guard let cell = collectionView.dequeueReusableCell(
           withReuseIdentifier: CalenderViewCell.identifier ,
           for: indexPath) as? CalenderViewCell else {
               return UICollectionViewCell()
           }
        if submittedData.contains([indexPath.section, indexPath.item]){
                cell.backgroundColor = .lightGray
                return cell
        } else if calenderSlotData.blockedSlot[indexPath.section][indexPath.item] {
            cell.backgroundColor = .Background

            return cell
        }
        cell.backgroundColor = .white
        return cell
    }
    
    //캘린더 클릭 액션
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CalenderViewCell
        
        if !submittedData.contains([indexPath.section, indexPath.item]) { //빈 셀에 대해
            if !choicedCells[indexPath.section][indexPath.item] && !calenderSlotData.blockedSlot[indexPath.section][indexPath.item] { //블락할 셀
                choicedCells[indexPath.section][indexPath.item].toggle()
                cell?.backgroundColor = .red
            }else if choicedCells[indexPath.section][indexPath.item]{ //한번 클릭한 셀 해제
                choicedCells[indexPath.section][indexPath.item].toggle()
                cell?.backgroundColor = calenderSlotData.blockedSlot[indexPath.section][indexPath.item] ? .Background : .white
            }else if calenderSlotData.blockedSlot[indexPath.section][indexPath.item] { //블락했던 셀
                choicedCells[indexPath.section][indexPath.item].toggle()
                cell?.backgroundColor = .Action
            }
        }
    }
}



extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    //cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: (UIScreen.main.bounds.width-(calenderSidePadding[0]+calenderSidePadding[1]))/5, height: 550/18)
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

