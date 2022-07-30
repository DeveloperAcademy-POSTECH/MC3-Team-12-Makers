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
    
    //다음 일주일의 날짜 리스트를 저장하는 연산 프로퍼티, 아래의 dayIndex 함수에 사용함
    var nextWeek: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM-dd"
        var nextWeek = [String]()
         
        for dayCount in 0..<weekDays+2 { //주말 이틀 추가(weekDays==5)
//            let dayAdded = (86400 * (2+dayCount-todayOfTheWeek +7)) //캘린더뷰가 다음주를 표시하는 경우 +7
            let dayAdded = (86400 * (2+dayCount-todayOfTheWeek))
            let oneDayString = formatter.string(from: Date(timeIntervalSinceNow: TimeInterval(dayAdded))).components(separatedBy: "-")
            nextWeek.append(oneDayString[0]+oneDayString[1]+"일")
        }
        return nextWeek
    }
    
    //displayData에 추가될 데이터 포멧
    func calenderDataMaker() -> [TeacherCalenderData] {
        var calenderData: [TeacherCalenderData] = []
        for parentIds in 0..<mainTeacher.parentUsers.count {
            calenderData.append(TeacherCalenderData(parentIds: parentIds, calenderIndex: [], cellColor: .white))
            calenderData[parentIds].cellColor = getRandomColor()[parentIds]
        }
        return calenderData
    }
    
    private lazy var calenderData = calenderDataMaker()
    
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
    
    // 테이블뷰 테스트
    func scheduledParentsListMaker() -> [ParentUser] {
        var scheduledParentsList: [ParentUser] = []
        for parentsIndex in 0..<mainTeacher.parentUsers.count {
            for scheduleIndex in 0..<mainTeacher.parentUsers[parentsIndex].schedules[0].scheduleList.count {
                if mainTeacher.parentUsers[parentsIndex].schedules[0].scheduleList[scheduleIndex].isReserved == false {
                    scheduledParentsList.append(mainTeacher.parentUsers[parentsIndex])
                    break
                }
            }
        }
        return scheduledParentsList
    }
    
    private lazy var scheduledParentsList = scheduledParentsListMaker() //학부모 리스트 뷰는 모두 scheduledparentslist로 관리, 데이터에는 리스트 만들 때 빼곤 접근하지 않음
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CalenderTableViewCell.self, forCellReuseIdentifier: CalenderTableViewCell.identifier)
        return tableView
    }()
    
    

    
    // 캘린더뷰
    private let calenderView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CalenderViewCell.self, forCellWithReuseIdentifier: CalenderViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false //필수 !!
        return collectionView
    }()
    
    //학부모 컬렉션뷰
    private let flowLayout: UICollectionViewFlowLayout = {
       let layout = UICollectionViewFlowLayout()
       layout.scrollDirection = .horizontal
       layout.minimumInteritemSpacing = 8.0
       layout.itemSize = CGSize(width: 100, height: 100)
       return layout
     }()

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
        calenderView.delegate = self
        calenderView.dataSource = self
                
        parentsCollectionView.delegate = self
        parentsCollectionView.dataSource = self
        
        seeAll.addTarget(self, action: #selector(seeAllOnTapButton), for: .touchUpInside)
    }
    
    //MARK: - Funcs
    
    func acceptedData() -> [TeacherCalenderData] {
        var acceptedData: [TeacherCalenderData] = []
        var calenderIndex: [Int] = []

        for parentsIndex in 0..<mainTeacher.parentUsers.count {
            calenderIndex = []
            
            for scheduleIndex in 0..<mainTeacher.parentUsers[parentsIndex].schedules[0].scheduleList.count { //하단 funcs 참고
                if mainTeacher.parentUsers[parentsIndex].schedules[0].scheduleList[scheduleIndex].isReserved {
                    acceptedData.append(calenderData[parentsIndex])
                    calenderIndex.append(timeStringToIndex(parentIndex: parentsIndex)[scheduleIndex] * weekDays + dateStringToIndex(parentsIndex: parentsIndex)[scheduleIndex])
                    acceptedData[acceptedData.count-1].calenderIndex = calenderIndex
                    acceptedData[acceptedData.count-1].cellColor = .lightGray
                }
    
            }
        }
        return acceptedData
    }
    
    //모든 신청 예약 데이터를 인덱스로 만들어주는 함수 : 연산 프로퍼티로 하기에는 다시 입력/로드되어야 하는 경우가 있어 함수로 수정
    func submittedData() -> [TeacherCalenderData] {
        var calenderIndex: [Int] = []
        
        for parentIdx in 0..<mainTeacher.parentUsers.count {
            calenderIndex = []
            for scheduleIndex in 0..<mainTeacher.parentUsers[parentIdx].schedules[0].scheduleList.count{ //하단 funcs 참고
                calenderIndex.append(timeStringToIndex(parentIndex: parentIdx)[scheduleIndex] * weekDays + dateStringToIndex(parentsIndex: parentIdx)[scheduleIndex])
            }

            calenderData[parentIdx].calenderIndex = calenderIndex
        }
        return calenderData
    }
    
    
    
    //선택한 학부모의 신청 요일(날자)를 리스트로 반환해주는 함수
    func dateStringToIndex(parentsIndex: Int) -> [Int] {
        var dateString: [String] = []
        var dateIndex: [Int] = []
        for i in 0..<mainTeacher.parentUsers[parentsIndex].schedules[0].scheduleList.count {
            dateString.append(mainTeacher.parentUsers[parentsIndex].schedules[0].scheduleList[i].consultingDate)

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
    
    override func render() {
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        calenderView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        calenderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        calenderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        
        view.addSubview(parentsCollectionView)
        parentsCollectionView.topAnchor.constraint(equalTo: calenderView.topAnchor, constant: 350).isActive = true
        parentsCollectionView.bottomAnchor.constraint(equalTo: calenderView.topAnchor, constant: 350 + flowLayout.itemSize.height).isActive = true
        parentsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        parentsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true

        view.addSubview(seeAll)
        seeAll.topAnchor.constraint(equalTo: calenderView.topAnchor, constant: 320).isActive = true
        seeAll.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        
    }

    override func configUI() {
        view.backgroundColor = .white
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
            
            cell.backgroundColor = .gray
            
            displayData.forEach { //eachdata = {parentsIds, calenderIdx, cellColor}
                if $0.calenderIndex.contains(indexPath.item) { //calenderIdx와 일치하는 index의 셀은 cellColor으로 display
                    cell.backgroundColor = clickedCell == indexPath.item ? .black : $0.cellColor
                }
            }
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ParentsCollectionViewCell.identifier ,
            for: indexPath) as? ParentsCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.delegate = self
            cell.backgroundColor = .gray
            
            let parent = scheduledParentsList[indexPath.item]
            cell.configure(childName: parent.childName, schedule: parent.schedules[0])
            
            return cell
        }
    }
    
    //cell 클릭 액션
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == calenderView {
            //더블클릭한 경우
            if indexPath.item == clickedCell {
                // 확정된 스케줄 이외 다른 스케줄 모두 삭제 및 isResulved = true 로 변환
                mainTeacher.parentUsers[parentId!].schedules[0].scheduleList = [mainTeacher.parentUsers[parentId!].schedules[0].scheduleList[selectedIndex!]]
                mainTeacher.parentUsers[parentId!].schedules[0].scheduleList[0].isReserved = true
                
                calenderData[parentId!].cellColor = .lightGray // 예약확정된 셀은 연회색
                clickedCell = nil // 선택해제

                displayData = acceptedData() //수정된 스케줄 데이터 다시 불러오고 확정된 스케줄만 다시 그려줌
                calenderView.reloadData()
                
                scheduledParentsList.remove(at: parentId!) //학부모 리스트에서 확정된 데이터 인덱스를 삭제한 후 다시 그려줌
                parentsCollectionView.reloadData()
                return
            }
            //예약확인된 슬롯 클릭
            acceptedData().forEach {
                if $0.calenderIndex.contains(indexPath.item) { //TODO: delegate 커스텀해서 카드 버튼 누를때와 함께 관리하기
                    let alert = UIAlertController(title: "상담용건", message: mainTeacher.parentUsers[$0.parentIds].schedules[0].content, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                    alert.addAction(cancelAction)
                    present(alert, animated: true, completion: nil)
                    clickedCell = nil
                    return
                }
            }
            //미확정 슬롯 처음 클릭한 경우 (3중 1)
            displayData.forEach {
                if $0.calenderIndex.contains(indexPath.item) {
                    selectedIndex = $0.calenderIndex.firstIndex(of: indexPath.item)
                    parentId = $0.parentIds

                    clickedCell = indexPath.item
                    calenderView.reloadData()
                    return
                }
                clickedCell = nil // 신청된 슬롯 외 클릭하면 선택해제
            }
            calenderView.reloadData()

        } else if collectionView == parentsCollectionView {
            selectedTableRow = indexPath
            displayData = acceptedData()
            displayData.append(submittedData()[indexPath.item])
            
            
            calenderView.reloadData()
        }
    }
}

extension ConsultationViewController: UICollectionViewDataSource {
    
    //캘린더 아이템 수, 5일*6단위 = 30
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == calenderView {
            return choicedCells.count
        } else if collectionView == parentsCollectionView {
            return scheduledParentsList.count
        }
        return 0
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
        return CGFloat(0)
    }
    
    //cell 종간 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
}

extension ConsultationViewController: ParentsCollcetionViewCellDelegate {
    func present(message: String ) {
                let alert = UIAlertController(title: "상담용건", message: message, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
    }
}
