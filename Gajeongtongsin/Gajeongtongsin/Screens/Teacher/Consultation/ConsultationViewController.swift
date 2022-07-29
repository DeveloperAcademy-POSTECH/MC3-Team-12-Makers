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
    
    private var customNavigationBar: CutomNavigationBar = {
        let customNavigationBar = CutomNavigationBar(title: "이번주 상담일정", imageName: "bell", imageSize: 20)
        customNavigationBar.backgroundColor = .white
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        return customNavigationBar
    }()
    //displayData에 추가될 데이터 포멧
    private var calenderData: [TeacherCalenderData] = [
        TeacherCalenderData(parentIds: 0, calenderIndex: [], cellColor: .green),
        TeacherCalenderData(parentIds: 1, calenderIndex: [], cellColor: .blue),
        TeacherCalenderData(parentIds: 2, calenderIndex: [], cellColor: .red)]
    
    
    
    // 테이블뷰 테스트
    let scheduledParentsList: [Schedule] = mainTeacher.parentUsers.flatMap({$0.schedules})
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CalenderTableViewCell.self, forCellReuseIdentifier: CalenderTableViewCell.identifier)
        return tableView
    }()
    //여기까지
    
    
    
    // 캘린더뷰
    private let calenderView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CalenderViewCell.self, forCellWithReuseIdentifier: CalenderViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false //필수 !!
        return collectionView
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
        render()
        configUI()
        setDelegations()
        seeAll.addTarget(self, action: #selector(seeAllOnTapButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    
    //MARK: - Funcs
    
    func setDelegations() {
        calenderView.delegate = self
        calenderView.dataSource = self
        customNavigationBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }

    func acceptedData() -> [TeacherCalenderData] {
        var acceptedData: [TeacherCalenderData] = []
        var calenderIndex: [Int] = []

        for parentIndex in 0..<mainTeacher.parentUsers.count {
            calenderIndex = []
            
            for index in 0..<mainTeacher.parentUsers[parentIndex].schedules[0].scheduleList.count { //하단 funcs 참고
                if mainTeacher.parentUsers[parentIndex].schedules[0].scheduleList[index].isReserved {
                    acceptedData.append(calenderData[index])
                    calenderIndex.append(timeStringToIndex(parentUserIds: parentIndex)[index] * weekDays + dateStringToIndex(parentUserIds: parentIndex)[index])
                    acceptedData[acceptedData.count-1].calenderIndex = calenderIndex
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
            for i in 0..<mainTeacher.parentUsers[parentIdx].schedules[0].scheduleList.count{ //하단 funcs 참고
                calenderIndex.append(timeStringToIndex(parentUserIds: parentIdx)[i] * weekDays + dateStringToIndex(parentUserIds: parentIdx)[i])
            }

            calenderData[parentIdx].calenderIndex = calenderIndex
        }
        return calenderData
    }
    
    

    //선택한 학부모의 신청 요일(날자)를 리스트로 반환해주는 함수
    func dateStringToIndex(parentUserIds: Int) -> [Int] {
        var dateString: [String] = []
        var dateIndex: [Int] = []
        for i in 0..<mainTeacher.parentUsers[parentUserIds].schedules[0].scheduleList.count {
            dateString.append(mainTeacher.parentUsers[parentUserIds].schedules[0].scheduleList[i].consultingDate)

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
    
    func timeStringToIndex(parentUserIds: Int) -> [Int] {
        var startTime:[Int] = []

        
        mainTeacher.parentUsers[parentUserIds].schedules[0].scheduleList.forEach{
            let timeList = $0.startTime.components(separatedBy: "시")  //[14, 00], [14, 30], [15, 00], ...
            let hour = Int(timeList[0])!-14 // 14, 14, 15, 15, 16, 16 ... -> 0, 0, 1, 1, 2, 2 ...
            let minute = Int(timeList[1].replacingOccurrences(of: "분", with: ""))!/30 // 00, 30, 00, 30 ... -> 0, 1, 0, 1, ...
            startTime.append(hour*2 + minute)
        }
        
        return startTime
    }
    
    //mockdata의 상담예약 관련 데이터를 teacherCalenderDate에 불러오는 함수
    func CalenderDisplayData() -> [TeacherCalenderData] {
        var calenderIndex: [Int] = []
        var calenderData: [TeacherCalenderData] = []
        calenderData.append(TeacherCalenderData(parentIds: 0, calenderIndex: [], cellColor: .green))
        calenderData.append(TeacherCalenderData(parentIds: 1, calenderIndex: [], cellColor: .blue))
        calenderData.append(TeacherCalenderData(parentIds: 2, calenderIndex: [], cellColor: .red))

        for parentIdx in 0..<mainTeacher.parentUsers.count {
            calenderIndex = []
            for i in 0...2{
                calenderIndex.append(timeStringToIndex(parentUserIds: parentIdx)[i] * weekDays + dateStringToIndex(parentUserIds: parentIdx)[i])
            }

            calenderData[parentIdx].calenderIndex = calenderIndex
        }
        print(calenderData)
        return calenderData
    }
    

    //버튼 누르면 학부모1 신청시간 display
    @objc func par1OnTapButton() {
        displayData = acceptedData()
        displayData.append(submittedData()[0])
        print(acceptedData())
        
        calenderView.reloadData()
    }
    //버튼 누르면 학부모2 신청시간 display
    @objc func par2OnTapButton() {
        displayData = acceptedData()
        displayData.append(submittedData()[1])
        
        calenderView.reloadData()
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
        
        view.addSubview(seeAll)
        seeAll.topAnchor.constraint(equalTo: calenderView.topAnchor, constant: 320).isActive = true
        seeAll.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        

        view.addSubview(customNavigationBar)
        customNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavigationBar.heightAnchor.constraint(equalToConstant: 100).isActive = true

        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: calenderView.topAnchor, constant: 350).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true

    }

    override func configUI() {
        view.backgroundColor = .white
        setupNavigationBackButton()
    }
    
    func setupNavigationBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .black
    }
}

//MARK: - Extensions

extension ConsultationViewController: UICollectionViewDelegate{
   
    //cell 로드
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: CalenderViewCell.identifier ,
        for: indexPath) as? CalenderViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .gray
        for eachData in displayData{ //eachdata = {parentsIds, calenderIdx, cellColor}
            if eachData.calenderIndex.contains(indexPath.item) { //calenderIdx와 일치하는 index의 셀은 cellColor으로 display
                cell.backgroundColor = clickedCell == indexPath.item ? .black : eachData.cellColor
                break //for문을 도는 도중 다른 data로 인해 gray로 display되는것을 방지
            }
        }
        return cell
    }

    
    //cell 클릭 액션
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //더블클릭한 경우
        if indexPath.item == clickedCell {
            
            // 확정된 스케줄 이외 다른 스케줄 모두 삭제 및 isResulved = true 로 변환
            mainTeacher.parentUsers[parentId!].schedules[0].scheduleList = [mainTeacher.parentUsers[parentId!].schedules[0].scheduleList[selectedIndex!]]
            mainTeacher.parentUsers[parentId!].schedules[0].scheduleList[0].isReserved = true
            
            calenderData[parentId!].cellColor = .borderGray // 예약확정된 셀은 연회색
            clickedCell = nil // 선택해제

            //onTapButton 함수 실행 -> 수정된 스케줄 데이터 다시 불러오고 확정된 스케줄만 다시 그려줌
            displayData = acceptedData()
            calenderView.reloadData()
            
            tableView.reloadData()
            return
        }
        
        //처음 클릭한 경우 (3중 1)
        for eachData in displayData {
            if eachData.calenderIndex.contains(indexPath.item) {
                selectedIndex = eachData.calenderIndex.firstIndex(of: indexPath.item)
                parentId = eachData.parentIds
                clickedCell = indexPath.item
                calenderView.reloadData()
                break
            }
            clickedCell = nil // 신청된 슬롯 외 클릭하면 선택해제
//            deSelectTableRow(selectedTableRow: selectedTableRow!)
        }
        calenderView.reloadData()
    }

}

extension ConsultationViewController: UICollectionViewDataSource {
    
    //캘린더 아이템 수, 5일*6단위 = 30
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return choicedCells.count
    }
 }

extension ConsultationViewController: UICollectionViewDelegateFlowLayout {
    
    //cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: (UIScreen.main.bounds.width-100)/5, height: 50)
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


extension ConsultationViewController : CustomNavigationBarDelegate {
    func tapButton() {
        let vc = NotificationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

//학부모 테이블뷰
extension ConsultationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduledParentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalenderTableViewCell.identifier, for: indexPath) as? CalenderTableViewCell else { return UITableViewCell()}
        
        let parent = mainTeacher.parentUsers[indexPath.item]
        
        cell.configure(childName: parent.childName, schedule: parent.schedules[0])
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


extension ConsultationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTableRow = indexPath
        displayData = acceptedData()
        displayData.append(submittedData()[indexPath.item])
        
        
        calenderView.reloadData()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        guard let selectedRow = selectedTableRow else {return}
        deSelectTableRow(selectedTableRow: selectedRow)
    }
    
    func deSelectTableRow(selectedTableRow: IndexPath) {
        tableView.deselectRow(at: selectedTableRow, animated: true)
        displayData = acceptedData()
        calenderView.reloadData()

    }
}
