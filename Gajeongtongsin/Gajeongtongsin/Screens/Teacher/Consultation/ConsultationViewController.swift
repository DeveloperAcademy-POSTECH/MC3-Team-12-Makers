//
//  ReservationViewController.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

class ConsultationViewController: BaseViewController {
    
    //MARK: - Properties
    private var choicedCells: [Bool] = Array(repeating: false, count:30)
    private var displayData: [TeacherCalenderData] = []
    private var cellColor: UIColor = .white
    private var clickedCell: Int?
    private var selectedIndex: Int?
    private var parentId: Int = -1
    private var selectedTableRow:IndexPath?
    private var cellHeight:CGFloat = 50
    private var startTime = 4
    private var endTime = 10
    
    private var allSchedules: [(name: String, schedule: [Schedule]?)] = []
    
    //다음 일주일의 날짜 리스트를 저장하는 연산 프로퍼티, 아래의 dayIndex 함수에 사용함
    var nextWeek: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월dd일"
        formatter.timeZone = TimeZone(identifier: "ko_KR")
        var nextWeek = [String]()
         
        for dayCount in 0..<weekDays {
            //let dayAdded = (86400 * (2+dayCount-todayOfTheWeek))
            //캘린더뷰가 다음주를 표시하는 경우 +7
            let dayAdded = (86400 * (2+dayCount-todayOfTheWeek + 7))
            let oneDayString = formatter.string(from: Date(timeIntervalSinceNow: TimeInterval(dayAdded)))
            nextWeek.append(oneDayString)
        }
        return nextWeek
    }

    private var customNavigationBar: CustomNavigationBar = {
        let customNavigationBar = CustomNavigationBar(title: "이번주 상담일정",
                                                      titleSize: 22,
                                                      imageName: "bell",
                                                      imageSize: 20)
        
         customNavigationBar.backgroundColor = .Background
         customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
         return customNavigationBar
     }()
    
    // FIXME: - 수정이 필요해보임
    private lazy var calenderData: [TeacherCalenderData] = calenderDataMaker()

    private var scheduledParentList: [(name: String, schedule: [Schedule]?)] = []
    
    // 캘린더뷰
    private let calenderView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .gray
        view.register(CalenderViewCell.self, forCellWithReuseIdentifier: CalenderViewCell.identifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //학부모 컬렉션뷰 레이아웃
    private let flowLayout: UICollectionViewFlowLayout = {
       let layout = UICollectionViewFlowLayout()
       layout.scrollDirection = .horizontal
       layout.minimumInteritemSpacing = 8.0
       layout.itemSize = CGSize(width: 140, height: 150)
       return layout
     }()
    
    //학부모 컬렉션뷰
    private lazy var parentsCollectionView: UICollectionView = {
      let view = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
      view.isScrollEnabled = true
      view.showsHorizontalScrollIndicator = false
      view.showsVerticalScrollIndicator = true
      view.contentInset = .zero
      view.backgroundColor = .clear
      view.clipsToBounds = true
      view.register(ParentsCollectionViewCell.self, forCellWithReuseIdentifier: ParentsCollectionViewCell.identifier)
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()
    
    private let collectionViewTitle: UILabel = {
        let label = UILabel()
        label.text = "대기 중인 예약"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //캘린더 시간 레이블
    lazy private var hourLabel: [UILabel] = Constants.hourLabelMaker()
    
    //캘린더 날자 레이블
    lazy private var dateLabel: [[UILabel]] = Constants.dateLabelMaker()
    
    // 전체 신청내역 보기
    private let seeAll: UIButton = {
        let button = UIButton()
        button.setTitle("예약일정 전체보기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.setTitleColor(.LightText, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        calenderDataMaker()
        setDelegations()
        seeAll.addTarget(self, action: #selector(seeAllOnTapButton), for: .touchUpInside)

        FirebaseManager.shared.fetchParentsReservations { [weak self] schedules in
            if let schedules = schedules {
                self?.allSchedules = []
                self?.scheduledParentList = []
                self?.allSchedules = self!.scheduledParentsListConVerter(schedules)
                self?.scheduledParentList = self!.scheduledParentsListMaker(schedules)
                self?.parentsCollectionView.reloadData()
                self?.calenderView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        self.calenderView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        timeResponsiveLabelRander()
    }
    
    //MARK: - Funcs
    
    func setDelegations(){
        parentsCollectionView.delegate = self
        parentsCollectionView.dataSource = self
        calenderView.delegate = self
        calenderView.dataSource = self
        customNavigationBar.delegate = self
    }
    
    
    
    func calenderDataMaker() -> [TeacherCalenderData] {
        var calenderData: [TeacherCalenderData] = []
        for parentsIndex in 0..<allSchedules.count {
            calenderData.append(TeacherCalenderData(parentsIndex: parentsIndex, calenderIndex: [], cellColor: .white))
            calenderData[parentsIndex].cellColor = getRandomColor()[parentsIndex]
        }
        return calenderData
    }
    
    func getRandomColor() -> [UIColor] { //학부모별 슬롯 색상 자동화
        var colorList: [UIColor] = []
        for _ in 0..<allSchedules.count {
            let red:CGFloat = CGFloat(drand48())
            let green:CGFloat = CGFloat(drand48())
            let blue:CGFloat = CGFloat(drand48())
            colorList.append(UIColor(red: red, green: green, blue: blue, alpha: 1.0))
        }
        return colorList
    }
    ///컨버터
    func scheduledParentsListConVerter(_ allSchedules: [String:[Schedule]]) -> [(String, [Schedule]?)] {
        var scheduledParentsList: [(String, [Schedule]?)] = []
        for key in allSchedules.keys {
                scheduledParentsList.append((key,allSchedules[key]))
        }
        return scheduledParentsList
    }
    
    func scheduledParentsListMaker(_ allSchedules: [String:[Schedule]]) -> [(String, [Schedule]?)] {
        var scheduledParentsList: [(String, [Schedule]?)] = []
        for key in allSchedules.keys {
            if allSchedules[key]?[0].scheduleList[0].isReserved == false {
                scheduledParentsList.append((key,allSchedules[key]))
            }
        }
        return scheduledParentsList
    }
    ///예약이 확정된 데이터를 저장. 확정 시에는 submittedData에 있던 3개 스케줄이 지워지고 acceptedData에 확정된 1개의 스케줄만 등록됨
    func acceptedData() -> [TeacherCalenderData] {
        var acceptedData: [TeacherCalenderData] = []
        var calenderIndex: [[Int]] = []

        for parentsIndex in allSchedules.indices {
            calenderIndex = []
            
            guard let parentSchedules = allSchedules[parentsIndex].schedule else { return [] }
            for scheduleIndex in 0..<parentSchedules[0].scheduleList.count { //하단 funcs 참고
                if parentSchedules[0].scheduleList[scheduleIndex].isReserved {
                    acceptedData.append(calenderData[parentsIndex])
                    
                    let rowIndex = timeStringToIndex(parentIndex: parentsIndex)[scheduleIndex]
                    let columnIndex = dateStringToIndex(parentsIndex: parentsIndex)[scheduleIndex]
                    calenderIndex.append([columnIndex, rowIndex])

                    acceptedData[acceptedData.count-1].calenderIndex = calenderIndex
                    acceptedData[acceptedData.count-1].cellColor = .LightLine
                }
    
            }
        }
        return acceptedData
    }
    
    // FIXME: - 로직 단순화 필요
    //미확정 예약 데이터를 인덱스로 만들어주는 함수
    func submittedData() -> [TeacherCalenderData] {
        var calenderIndex: [[Int]] = []
        var submittedData:[TeacherCalenderData] = []
        
        for parentsIndex in 0 ..< allSchedules.count {
            calenderIndex = []
            guard let parentShedules = allSchedules[parentsIndex].schedule else { return []}
            if parentShedules[0].scheduleList[0].isReserved == false {
                for scheduleIndex in 0 ..< parentShedules[0].scheduleList.count {
                    let rowIndex = timeStringToIndex(parentIndex: parentsIndex)[scheduleIndex]
                    let columnIndex = dateStringToIndex(parentsIndex: parentsIndex)[scheduleIndex]
                    calenderIndex.append([columnIndex, rowIndex])
                }
                submittedData.append(calenderData[parentsIndex])
                submittedData[submittedData.count-1].calenderIndex = calenderIndex
            }
        }
        return submittedData
    }
    
    //선택한 학부모의 신청 요일(날자)를 정수(인덱스) 리스트로 반환해주는 함수
    func dateStringToIndex(parentsIndex: Int) -> [Int] {
        var dateString: [String] = []
        var dateIndex: [Int] = []
        guard let parentSchedules = allSchedules[parentsIndex].schedule else { return []}
        parentSchedules[0].scheduleList.forEach{
            dateString.append($0.consultingDate)
        }
        for date in 0..<dateString.count { //String을 Index로 바꿔줌
            for nextWeekDay in 0..<nextWeek.count {
                if dateString[date] == nextWeek[nextWeekDay] {
                    dateIndex.append(nextWeekDay)
                }
            }
        }
        return dateIndex
    }
    
    ///선택한 학부모의 신청 시간을 정수(인덱스) 리스트로 반환해주는 함수
    func timeStringToIndex(parentIndex: Int) -> [Int] {
        var startTime:[Int] = []
        
        guard let parentSchedules = allSchedules[parentIndex].schedule else { return [] }
        parentSchedules[0].scheduleList.forEach{
            let timeList = $0.startTime.components(separatedBy: "시")  //[14, 00], [14, 30], [15, 00], ...
            let hour = Int(timeList[0])!-14 // 14, 14, 15, 15, 16, 16 ... -> 0, 0, 1, 1, 2, 2 ...
            let minute = Int(timeList[1].replacingOccurrences(of: "분", with: ""))!/30 // 00, 30, 00, 30 ... -> 0, 1, 0, 1, ...
            startTime.append(hour*2 + minute)
        }
        
        return startTime
    }

    ///버튼 누르면 모든 신청시간 색상별 display
    @objc func seeAllOnTapButton() {
        displayData = acceptedData()
        displayData += submittedData()
        
        calenderView.reloadData()
    }
    
    let calenderTopPadding = CGFloat(200.0)
    let calenderSidePadding = [CGFloat(50.0),CGFloat(20.0)]
    let calenderHeigit = CGFloat(300.0)
    lazy var collectionHeight:CGFloat = CGFloat(flowLayout.itemSize.height*1.1)
    
    override func render() {
    
        view.addSubview(customNavigationBar)
        customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor,constant: 29).isActive = true
        customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        
        view.addSubview(calenderView)

        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: calenderTopPadding).isActive = true
        calenderView.heightAnchor.constraint(equalToConstant: calenderHeigit).isActive = true
        calenderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: calenderSidePadding[0]).isActive = true
        calenderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -calenderSidePadding[1]).isActive = true

        
        view.addSubview(parentsCollectionView)
        parentsCollectionView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -collectionHeight-100).isActive = true
        parentsCollectionView.heightAnchor.constraint(equalToConstant: collectionHeight).isActive = true
        parentsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        parentsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true

        view.addSubview(seeAll)

        seeAll.topAnchor.constraint(equalTo: calenderView.topAnchor, constant: 330).isActive = true
        seeAll.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(collectionViewTitle)
        collectionViewTitle.topAnchor.constraint(equalTo: calenderView.topAnchor, constant: 330).isActive = true
        collectionViewTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
//        let timeInterval = endTime-startTime<=0 ? 4 : endTime-startTime
//        let timeInterval = (endTime-startTime)/2
//        for index in 0...timeInterval {
//            view.addSubview(hourLabel[index])
//            hourLabel[index].centerYAnchor.constraint(equalTo: calenderView.topAnchor, constant: calenderHeigit/CGFloat(timeInterval)*CGFloat(index)).isActive = true
//            hourLabel[index].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//        }
        
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
    
    func timeResponsiveLabelRander() {
                let timeInterval = (endTime-startTime)/2
        
        let interval: CGFloat = (endTime-startTime)%2 == 0 ? calenderHeigit/CGFloat(timeInterval) : (calenderHeigit-(calenderHeigit/CGFloat(endTime-startTime)))/CGFloat(timeInterval)
                for index in 0...timeInterval {
                    view.addSubview(hourLabel[index])
                    hourLabel[index].centerYAnchor.constraint(equalTo: calenderView.topAnchor, constant: interval*CGFloat(index)).isActive = true
                    hourLabel[index].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
                }
    }

    override func configUI() {
        view.backgroundColor = .Background
        setupNavigationBackButton()
    }
    
    func setupNavigationBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .black
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        displayData = acceptedData()
        calenderView.reloadData()
    }
}

//MARK: - Extensions

extension ConsultationViewController: UICollectionViewDataSource {
    
    //섹션 수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == calenderView {
            return weekDays
        }
        return 1
    }
    
    //섹션 내 아이템 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == calenderView {
            startTime = 18
            endTime = 0 //min, max 돌아가기 오류 보정을 위한 초기화
            for section in 0..<weekDays { //해당 이전/이후 시간 중 모든 요일이 블락된 경우는 제외하기 위해 섹션별 최소/최대 비교
                startTime = min(calenderSlotData.blockedSlot[section].firstIndex(of: false) ?? 0, startTime)
                endTime = max((calenderSlotData.blockedSlot[section].lastIndex(of: false) ?? 18)+1, endTime)
            }
            cellHeight = 300.0/(CGFloat(endTime-startTime))
            return endTime-startTime
        } else {
            return scheduledParentList.count
        }
    }
 }

extension ConsultationViewController: UICollectionViewDelegate {
   
    //cell 로드
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == calenderView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CalenderViewCell.identifier
                ,for: indexPath) as? CalenderViewCell else { return UICollectionViewCell() }
            
            cell.backgroundColor = .white
            
            let correctionIndex = indexPath.item+startTime
            
            displayData.forEach {
                if $0.calenderIndex.contains([indexPath.section, correctionIndex]) { //calenderIdx와 일치하는 index의 셀은 cellColor으로 display
                    if clickedCell == correctionIndex {
                        cell.getClick(clicked: true)
                        cell.backgroundColor = .Action
                    }else {
                        cell.getClick(clicked: false)
                        cell.backgroundColor = $0.cellColor
                    }
                }
            }
            if calenderSlotData.blockedSlot[indexPath.section][correctionIndex] {
                cell.backgroundColor = .Background
            }
            
            acceptedData().forEach {
                if $0.calenderIndex.contains([indexPath.section, correctionIndex]) {
                    cell.backgroundColor = $0.cellColor
                }
            }
            
            
            return cell
            
        } else {
            
            
            guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ParentsCollectionViewCell.identifier ,
            for: indexPath) as? ParentsCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.delegate = self //학부모 컬렉션 셀 델리게이트 지정
            
            var eachCellData: [TeacherCalenderData] = [] //셀에 넣어줄 예약 데이터를 잠시 넣을 리스트
            
            let parent = scheduledParentList[indexPath.item]
            
            eachCellData.append(submittedData()[indexPath.item]) //각 셀에 해당하는 데이터 배정
            cell.sendDataToCell(displayData: eachCellData) //셀 내부 함수를 통해 셀에 데이터 넣어줌
            
            let childName = parent.name
            guard let schedules = parent.schedule else { return UICollectionViewCell()}
            cell.configure(childName: childName, schedule: schedules[0]) //정보 표시에 필요한 함수
            return cell
        }
    }
    
    //cell 클릭 액션
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == calenderView {
            //더블클릭한 경우
            if indexPath.item == clickedCell {
                // 확정된 스케줄 이외 다른 스케줄 모두 삭제 및 isResulved = true 로 변환
                //guard var parentSchedules = scheduledParentList[parentId!].schedule else {return}
                guard var selectedSchedule = allSchedules[parentId].schedule?[0].scheduleList[selectedIndex!] else { return}
                selectedSchedule.isReserved = true
                allSchedules[parentId].schedule?[0].scheduleList = []
                allSchedules[parentId].schedule?[0].scheduleList.append(selectedSchedule)
                FirebaseManager.shared.uploadConfirmedReservation(childName: allSchedules[parentId].name,
                                                                  reservedSchedule: allSchedules[parentId].schedule?[0],selectedIndex: selectedIndex!)
                calenderData[parentId].cellColor = .lightGray // 예약확정된 셀은 연회색
                clickedCell = nil // 선택해제
                
                displayData = acceptedData() //수정된 스케줄 데이터 다시 불러오고 확정된 스케줄만 다시 그려줌
                calenderView.reloadData()
                
                //TODO: 확정된 예약에 대해 카드를 어떻게 처리하는지 논의 필요
    //          scheduledParentsList.remove(at: parentId!) //학부모 리스트에서 확정된 데이터 인덱스를 삭제한 후 다시 그려줌
                parentsCollectionView.reloadData()
                return
            }
            
            //예약확정된 슬롯 클릭한 경우
            //카드의 용건보기 버튼과 동일한 액션
            acceptedData().forEach {
                if $0.calenderIndex.contains([indexPath.section, indexPath.item]) {
                    guard let parentSchedules = allSchedules[$0.parentsIndex].schedule else {return}
                    let alert = UIAlertController(title: "상담용건", message: parentSchedules[0].content, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                    alert.addAction(cancelAction)
                    present(alert, animated: true, completion: nil)
                    clickedCell = nil
                    return
                }
            }
            //미확정 슬롯 클릭한 경우 (3중 1)
            //예약 확정 버튼이 클릭한 슬롯에 표시됨
            displayData.forEach {
                if $0.calenderIndex.contains([indexPath.section, indexPath.item]) {
                    selectedIndex = $0.calenderIndex.firstIndex(of: [indexPath.section, indexPath.item])
                    parentId = $0.parentsIndex
                    
                    clickedCell = indexPath.item
                    calenderView.reloadData()
                    return
                }
                clickedCell = nil // 신청된 슬롯 외 클릭하면 선택해제
            }
            calenderView.reloadData()
        }
    }
}



extension ConsultationViewController: UICollectionViewDelegateFlowLayout {
    

    //cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if collectionView == calenderView {
            return CGSize(width: (UIScreen.main.bounds.width-(calenderSidePadding[0]+calenderSidePadding[1]))/5, height: cellHeight)
        } else if collectionView == parentsCollectionView {
            return flowLayout.itemSize
        }
        return CGSize(width: 100, height: 100)
    }
    
    //cell 횡간 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        if collectionView == calenderView {
        return CGFloat(0)
        } else {return 30}
    }
    
    //cell 종간 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == calenderView {
            return CGFloat(0)
        } else {
            return CGFloat(10)
        }
    }
}

//버튼 델리게이트
extension ConsultationViewController: ParentsCollcetionViewCellDelegate {
    func present(message: String ) {
                let alert = UIAlertController(title: "상담용건", message: message, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
    }
    
    func drawDisplayData(cellSchedulData: [TeacherCalenderData]) {
        self.displayData = cellSchedulData
        calenderView.reloadData()
        parentsCollectionView.reloadData()
    }
}


extension ConsultationViewController : CustomNavigationBarDelegate {
    func tapButton() {
        let vc = NotificationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
