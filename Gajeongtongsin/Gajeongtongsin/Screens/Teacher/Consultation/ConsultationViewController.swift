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
    private var cellColor: UIColor = .gray
    private var clickedCell: Int?
    private var selectedIndex: Int?
    private var parentId: Int?
    private var selectedTableRow:IndexPath?
    
    //private var childName: String = ""
    private var allSchedules: [String:[Schedule]] = [:]
    
    //다음 일주일의 날짜 리스트를 저장하는 연산 프로퍼티, 아래의 dayIndex 함수에 사용함
    var nextWeek: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "M-dd"
        var nextWeek = [String]()
         
        for dayCount in 0..<weekDays+2 { //주말 이틀 추가(weekDays==5)
//            let dayAdded = (86400 * (2+dayCount-todayOfTheWeek +7)) //캘린더뷰가 다음주를 표시하는 경우 +7
            let dayAdded = (86400 * (2+dayCount-todayOfTheWeek + 7))
            let oneDayString = formatter.string(from: Date(timeIntervalSinceNow: TimeInterval(dayAdded))).components(separatedBy: "-")
            nextWeek.append(oneDayString[0]+"월"+oneDayString[1]+"일")
        }
        return nextWeek
    }
    
    // FIXME: - 수정이 필요해보임
    private lazy var calenderData: [TeacherCalenderData] = calenderDataMaker()

    
    //private lazy var scheduledParentsList = scheduledParentsListMaker() //학부모 리스트 뷰는 모두 scheduledparentslist로 관리, 데이터에는 리스트 만들 때 빼곤 접근하지 않음
    private var scheduledParentList: [(String,[Schedule]?)] {
        scheduledParentsListMaker(allSchedules)
    }
    
    // 캘린더뷰
    private let calenderView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CalenderViewCell.self, forCellWithReuseIdentifier: CalenderViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false //필수 !!
        return collectionView
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
    
    // 전체 신청내역 보기
    private let seeAll: UIButton = {
        let button = UIButton()
        button.setTitle("전체보기", for: .normal)
        button.setTitleColor(.black, for: .normal)
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
                self?.allSchedules = [:]
                self?.allSchedules = schedules
                self?.parentsCollectionView.reloadData()
            }
        }
    }
    
    //MARK: - Funcs
    
    func setDelegations(){
        parentsCollectionView.delegate = self
        parentsCollectionView.dataSource = self
        
        calenderView.delegate = self
        calenderView.dataSource = self
    }
    
    //displayData에 추가될 데이터 포멧
//    func calenderDataMaker() -> [TeacherCalenderData] {
//        var calenderData: [TeacherCalenderData] = []
//        for parentsIndex in 0..<mainTeacher.parentUsers.count {
//            calenderData.append(TeacherCalenderData(parentsIndex: parentsIndex, calenderIndex: [], cellColor: .white))
//            calenderData[parentsIndex].cellColor = getRandomColor()[parentsIndex]
//        }
//        return calenderData
//    }
    func calenderDataMaker() -> [TeacherCalenderData] {
        var calenderData: [TeacherCalenderData] = []
        for parentsIndex in 0..<scheduledParentList.count {
            calenderData.append(TeacherCalenderData(parentsIndex: parentsIndex, calenderIndex: [], cellColor: .white))
            calenderData[parentsIndex].cellColor = getRandomColor()[parentsIndex]
        }
        return calenderData
    }
    
    func getRandomColor() -> [UIColor] { //학부모별 슬롯 색상 자동화
        var colorList: [UIColor] = []
        for _ in 0..<mainTeacher.parentUsers.count {
            let red:CGFloat = CGFloat(drand48())
            let green:CGFloat = CGFloat(drand48())
            let blue:CGFloat = CGFloat(drand48())
            colorList.append(UIColor(red: red, green: green, blue: blue, alpha: 1.0))
        }
        return colorList
    }
    
    // 학부모 컬렉션뷰 데이터
//    func scheduledParentsListMaker() -> [ParentUser] {
//        var scheduledParentsList: [ParentUser] = []
//        for parentsIndex in 0..<mainTeacher.parentUsers.count {
//
//                if mainTeacher.parentUsers[parentsIndex].schedules[0].scheduleList[0].isReserved == false {
//                    scheduledParentsList.append(mainTeacher.parentUsers[parentsIndex])
//
//                }
//
//        }
//
//        return scheduledParentsList
//    }

    func scheduledParentsListMaker(_ allSchedules: [String:[Schedule]]) -> [(String, [Schedule]?)] {
        var scheduledParentsList: [(String, [Schedule]?)] = []
        for key in allSchedules.keys {
            if allSchedules[key]?[0].scheduleList[0].isReserved == false {
                scheduledParentsList.append((key,allSchedules[key]))
            }
        }
        return scheduledParentsList
    }
    //예약이 확정된 데이터를 저장. 확정 시에는 submittedData에 있던 3개 스케줄이 지워지고 acceptedData에 확정된 1개의 스케줄만 등록됨
    func acceptedData() -> [TeacherCalenderData] {
        var acceptedData: [TeacherCalenderData] = []
        var calenderIndex: [Int] = []

        for parentsIndex in 0..<mainTeacher.parentUsers.count {
            calenderIndex = []
            
            for scheduleIndex in 0..<mainTeacher.parentUsers[parentsIndex].schedules[0].scheduleList.count { //하단 funcs 참고
                if mainTeacher.parentUsers[parentsIndex].schedules[0].scheduleList[scheduleIndex].isReserved {
                    acceptedData.append(calenderData[parentsIndex])
                    
                    let rowIndex = timeStringToIndex(parentIndex: parentsIndex)[scheduleIndex] * weekDays
                    let columnIndex = dateStringToIndex(parentsIndex: parentsIndex)[scheduleIndex]
                    calenderIndex.append(rowIndex + columnIndex)

                    acceptedData[acceptedData.count-1].calenderIndex = calenderIndex
                    acceptedData[acceptedData.count-1].cellColor = .lightGray
                }
    
            }
        }
        return acceptedData
    }
    
    //모든 신청 예약 데이터를 인덱스로 만들어주는 함수
    // FIXME: - 로직 단순화 필요
    func submittedData() -> [TeacherCalenderData] {
        var calenderIndex: [Int] = []
        
        for parentsIndex in 0 ..< scheduledParentList.count {
            calenderIndex = []
            guard let parentShedules = scheduledParentList[parentsIndex].1 else { return []}
            for scheduleIndex in
                    0 ..< parentShedules[0].scheduleList.count {
                
                if parentShedules[0].scheduleList[scheduleIndex].isReserved == false {
                    let rowIndex = timeStringToIndex(parentIndex: parentsIndex)[scheduleIndex] * weekDays
                    let columnIndex = dateStringToIndex(parentsIndex: parentsIndex)[scheduleIndex]
                    calenderIndex.append(rowIndex + columnIndex)
                }
            }
            calenderData[parentsIndex].calenderIndex = calenderIndex
        }
        print(calenderData[0]) // TODO: - 삭제
        return calenderData
    }
    
    
    //선택한 학부모의 신청 요일(날자)를 정수(인덱스) 리스트로 반환해주는 함수
    func dateStringToIndex(parentsIndex: Int) -> [Int] {
        var dateString: [String] = []
        var dateIndex: [Int] = []
        guard let parentSchedules = scheduledParentList[parentsIndex].1 else { return []}
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
    func timeStringToIndex(parentIndex: Int) -> [Int] {
        var startTime:[Int] = []
        
        guard let parentSchedules = scheduledParentList[parentIndex].1 else { return [] }
        parentSchedules[0].scheduleList.forEach{
            let timeList = $0.startTime.components(separatedBy: "시")  //[14, 00], [14, 30], [15, 00], ...
            let hour = Int(timeList[0])!-14 // 14, 14, 15, 15, 16, 16 ... -> 0, 0, 1, 1, 2, 2 ...
            let minute = Int(timeList[1].replacingOccurrences(of: "분", with: ""))!/30 // 00, 30, 00, 30 ... -> 0, 1, 0, 1, ...
            startTime.append(hour*2 + minute)
        }
        
        return startTime
    }

    //버튼 누르면 모든 신청시간 색상별 display
    @objc func seeAllOnTapButton() {
        displayData = acceptedData()
        displayData += submittedData()
        
        calenderView.reloadData()
    }
    
    override func render() {
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        calenderView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        calenderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        calenderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        
        view.addSubview(parentsCollectionView)
        parentsCollectionView.topAnchor.constraint(equalTo: calenderView.topAnchor, constant: 350).isActive = true
        parentsCollectionView.heightAnchor.constraint(equalToConstant: flowLayout.itemSize.height*1.1).isActive = true
        parentsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        parentsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true

        view.addSubview(seeAll)
        seeAll.topAnchor.constraint(equalTo: calenderView.topAnchor, constant: 320).isActive = true
        seeAll.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        
    }

    override func configUI() {
        view.backgroundColor = .white
    }
    
}

//MARK: - Extensions

extension ConsultationViewController: UICollectionViewDataSource {
    
    //캘린더 아이템 수, 5일*6단위 = 30
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == calenderView {
            return choicedCells.count
        } else {
            return allSchedules.count
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
            
            cell.backgroundColor = .gray
            
            displayData.forEach { //[{parentsIds, calenderIdx, cellColor}]
                if $0.calenderIndex.contains(indexPath.item) { //calenderIdx와 일치하는 index의 셀은 cellColor으로 display
                    cell.backgroundColor = clickedCell == indexPath.item ? .black : $0.cellColor
                }
            }
            
            acceptedData().forEach {
                if $0.calenderIndex.contains(indexPath.item) {
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
           //  let parent = scheduledParentsList[indexPath.item]
            
            eachCellData.append(submittedData()[indexPath.item]) //각 셀에 해당하는 데이터 배정
            cell.sendDataToCell(displayData: eachCellData) //셀 내부 함수를 통해 셀에 데이터 넣어줌
            
            let childName = parent.0
            guard let schedules = parent.1 else { return UICollectionViewCell()}
            cell.configure(childName: childName, schedule: schedules[0]) //정보 표시에 필요한 함수
            return cell
        }
    }
    
    //cell 클릭 액션
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //더블클릭한 경우
        if indexPath.item == clickedCell {
            // 확정된 스케줄 이외 다른 스케줄 모두 삭제 및 isResulved = true 로 변환
            mainTeacher.parentUsers[parentId!].schedules[0].scheduleList = [mainTeacher.parentUsers[parentId!].schedules[0].scheduleList[selectedIndex!]]
            mainTeacher.parentUsers[parentId!].schedules[0].scheduleList[0].isReserved = true
            
            calenderData[parentId!].cellColor = .lightGray // 예약확정된 셀은 연회색
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
            if $0.calenderIndex.contains(indexPath.item) {
                let alert = UIAlertController(title: "상담용건", message: mainTeacher.parentUsers[$0.parentsIndex].schedules[0].content, preferredStyle: .alert)
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
            if $0.calenderIndex.contains(indexPath.item) {
                selectedIndex = $0.calenderIndex.firstIndex(of: indexPath.item)
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



extension ConsultationViewController: UICollectionViewDelegateFlowLayout {

    //cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if collectionView == calenderView {
            return CGSize(width: (UIScreen.main.bounds.width-100)/5, height: 50)
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
    
    func drowDisplayData(cellSchedulData: [TeacherCalenderData]) {
        self.displayData = cellSchedulData
        calenderView.reloadData()
    }
}

