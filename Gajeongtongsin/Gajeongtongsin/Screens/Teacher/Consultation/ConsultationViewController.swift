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
    private var parentId: Int?
    private var selectedTableRow:IndexPath?
    
    //다음 일주일의 날짜 리스트를 저장하는 연산 프로퍼티, 아래의 dayIndex 함수에 사용함
    var nextWeek: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "M-dd"
        var nextWeek = [String]()
         
        for dayCount in 0..<weekDays+2 { //주말 이틀 추가(weekDays==5)
//            let dayAdded = (86400 * (2+dayCount-todayOfTheWeek +7)) //캘린더뷰가 다음주를 표시하는 경우 +7
            let dayAdded = (86400 * (2+dayCount-todayOfTheWeek))
            let oneDayString = formatter.string(from: Date(timeIntervalSinceNow: TimeInterval(dayAdded))).components(separatedBy: "-")
            nextWeek.append(oneDayString[0]+"월"+oneDayString[1]+"일")
        }
        return nextWeek
    }

    //신청내역 데이터 포멧(acceptedData, submittedData 모두 calenderData에서 인덱스 가져가서 저장)
    private lazy var calenderData = calenderDataMaker()
    
    //학부모 컬렉션뷰에서 사용하는 데이터
    private lazy var scheduledParentsList = scheduledParentsListMaker() //학부모 리스트 뷰는 모두 scheduledparentslist로 관리, 데이터에는 리스트 만들 때 빼곤 접근하지 않음
    
    // 캘린더뷰
    private let calenderView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .gray
        view.register(CalenderViewCell.self, forCellWithReuseIdentifier: CalenderViewCell.identifier)
        view.translatesAutoresizingMaskIntoConstraints = false //필수 !!
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
    
    //상단제목
    private let viewTitle: UILabel = {
        let label = UILabel()
        label.text = "이번주 상담일정"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let collectionViewTitle: UILabel = {
        let label = UILabel()
        label.text = "대기 중인 예약"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //캘린더 시간 레이블
    lazy private var hourLabel: [UILabel] = hourLabelMaker()
    
    //캘린더 날자 레이블
    lazy private var dateLabel: [[UILabel]] = dateLabelMaker()
    
    // 전체 신청내역 보기
    private let seeAll: UIButton = {
        let button = UIButton()
        button.setTitle("예약일정 전체보기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
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
    }
    
    //MARK: - Funcs
    
    func setDelegations(){
        parentsCollectionView.delegate = self
        parentsCollectionView.dataSource = self
        
        calenderView.delegate = self
        calenderView.dataSource = self
    }
    
    //시간 레이블 메이커
    func hourLabelMaker() -> [UILabel] {
        var labelList: [UILabel] = []
        for hour in 14...17 {
            let label = UILabel()
            label.text = String(hour)+"h"
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.textColor = .darkText
            label.translatesAutoresizingMaskIntoConstraints = false
            labelList.append(label)
        }
        return labelList
    }
    //날자 레이블 메이커
    func dateLabelMaker() -> [[UILabel]] {
        var labelList: [[UILabel]] = Array(repeating: [], count: 5)
        let formatter = DateFormatter()
        formatter.dateFormat = "d-EEE"
        
        for day in 0..<5 {
            let dayAdded = (86400 * (2+day-todayOfTheWeek))
            let oneDayString = formatter.string(from: Date(timeIntervalSinceNow: TimeInterval(dayAdded))).components(separatedBy: "-")
            oneDayString.forEach {
                let label = UILabel()
                label.text = $0
                label.translatesAutoresizingMaskIntoConstraints = false
                labelList[day].append(label)
            }
            labelList[day][0].font = UIFont.systemFont(ofSize: 17, weight: .regular)
            labelList[day][0].textColor = .darkText
            
            labelList[day][1].font = UIFont.systemFont(ofSize: 14, weight: .regular)
            labelList[day][1].textColor = .LightText
        }
        return labelList
    }
    
    //displayData에 추가될 데이터 포멧
    func calenderDataMaker() -> [TeacherCalenderData] {
        var calenderData: [TeacherCalenderData] = []
        for parentsIndex in 0..<mainTeacher.parentUsers.count {
            calenderData.append(TeacherCalenderData(parentsIndex: parentsIndex, calenderIndex: [], cellColor: .white))
            calenderData[parentsIndex].cellColor = getRandomColor()[parentsIndex]
        }
        return calenderData
    }
    
    // 학부모 컬렉션뷰 데이터
    func scheduledParentsListMaker() -> [ParentUser] {
        var scheduledParentsList: [ParentUser] = []
        for parentsIndex in 0..<mainTeacher.parentUsers.count {
            if mainTeacher.parentUsers[parentsIndex].schedules[0].scheduleList[0].isReserved == false {
                scheduledParentsList.append(mainTeacher.parentUsers[parentsIndex])
            }
        }
        return scheduledParentsList
    }
    
    //학부모별 슬롯 색상 생성기, seed를 제공받으므로 각각 항상 같은 색상
    func getRandomColor() -> [UIColor] {
        var colorList: [UIColor] = []
        for _ in 0..<mainTeacher.parentUsers.count {
            let red:CGFloat = CGFloat(drand48())
            let green:CGFloat = CGFloat(drand48())
            let blue:CGFloat = CGFloat(drand48())
            colorList.append(UIColor(red: red, green: green, blue: blue, alpha: 1.0))
        }
        return colorList
    }
    
    //확정 예약 데이터를 인덱스로 만들어주는 함수
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
                    acceptedData[acceptedData.count-1].cellColor = .LightLine
                }
    
            }
        }
        return acceptedData
    }
    
    //미확정 예약 데이터를 인덱스로 만들어주는 함수
    func submittedData() -> [TeacherCalenderData] {
        var calenderIndex: [Int] = []
        
        for parentsIndex in 0..<mainTeacher.parentUsers.count {
            calenderIndex = []
            for scheduleIndex in 0..<mainTeacher.parentUsers[parentsIndex].schedules[0].scheduleList.count{ //하단 funcs 참고
                if mainTeacher.parentUsers[parentsIndex].schedules[0].scheduleList[scheduleIndex].isReserved == false {
                    let rowIndex = timeStringToIndex(parentIndex: parentsIndex)[scheduleIndex] * weekDays
                    let columnIndex = dateStringToIndex(parentsIndex: parentsIndex)[scheduleIndex]
                    calenderIndex.append(rowIndex + columnIndex)
                }
            }
            calenderData[parentsIndex].calenderIndex = calenderIndex
        }
        return calenderData
    }
    
    //선택한 학부모의 신청 요일(날자)를 정수(인덱스) 리스트로 반환해주는 함수
    func dateStringToIndex(parentsIndex: Int) -> [Int] {
        var dateString: [String] = []
        var dateIndex: [Int] = []
        mainTeacher.parentUsers[parentsIndex].schedules[0].scheduleList.forEach{
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
        
        mainTeacher.parentUsers[parentIndex].schedules[0].scheduleList.forEach{
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
    
    let calenderTopPadding = CGFloat(200.0)
    let calenderSidePadding = [CGFloat(50.0),CGFloat(20.0)]
    let calenderHeigit = CGFloat(300.0)
    lazy var collectionHeight:CGFloat = CGFloat(flowLayout.itemSize.height*1.1)
    
    override func render() {
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
        
        for index in 0..<hourLabel.count {
            view.addSubview(hourLabel[index])
            hourLabel[index].centerYAnchor.constraint(equalTo: calenderView.topAnchor, constant: CGFloat(index*100)).isActive = true
            hourLabel[index].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
            print(index)
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: viewTitle)
    }
    
}

//MARK: - Extensions

extension ConsultationViewController: UICollectionViewDelegate {
   
    //cell 로드
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == calenderView {
            guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalenderViewCell.identifier ,
            for: indexPath) as? CalenderViewCell else {
                return UICollectionViewCell()
            }
            
            cell.backgroundColor = .white
            
            displayData.forEach { //[{parentsIds, calenderIdx, cellColor}]
                if $0.calenderIndex.contains(indexPath.item) { //calenderIdx와 일치하는 index의 셀은 cellColor으로 display
                    cell.backgroundColor = clickedCell == indexPath.item ? .Action : $0.cellColor
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
            let parent = scheduledParentsList[indexPath.item]
            
            eachCellData.append(submittedData()[indexPath.item]) //각 셀에 해당하는 데이터 배정
            cell.sendDataToCell(displayData: eachCellData) //셀 내부 함수를 통해 셀에 데이터 넣어줌
            
            cell.configure(childName: parent.childName, schedule: parent.schedules[0]) //정보 표시에 필요한 함수
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
            
            calenderData[parentId!].cellColor = .LightLine // 예약확정된 셀은 연회색
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

extension ConsultationViewController: UICollectionViewDataSource {
    
    //캘린더 아이템 수, 5일*6단위 = 30
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == calenderView {
            return choicedCells.count
        } else {
            return scheduledParentsList.count
        }
    }
 }

extension ConsultationViewController: UICollectionViewDelegateFlowLayout {

    //cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if collectionView == calenderView {
            return CGSize(width: (UIScreen.main.bounds.width-(calenderSidePadding[0]+calenderSidePadding[1]))/5, height: 50)
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

