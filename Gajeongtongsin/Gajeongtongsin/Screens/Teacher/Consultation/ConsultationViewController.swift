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
    
    //다음 일주일의 날짜 리스트를 반환해주는 함수, 아래의 dayIndex 함수에 사용함
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
    
    //mockdata의 상담예약 관련 데이터를 teacherCalenderDate에 불러오는 함수
    
    private var calenderData: [TeacherCalenderData] = [
        TeacherCalenderData(parentIds: 0, calenderIndex: [], cellColor: .green),
        TeacherCalenderData(parentIds: 1, calenderIndex: [], cellColor: .blue),
        TeacherCalenderData(parentIds: 2, calenderIndex: [], cellColor: .red)]
    
    // 캘린더뷰
    private let calenderView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CalenderViewCell.self, forCellWithReuseIdentifier: CalenderViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false //필수 !!
        return collectionView
    }()
    
    // 학부모1 신청내역 보기
    private let par1: UIButton = {
        let button = UIButton()
        button.setTitle("학부모 1", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // 학부모2 신청내역 보기
    private let par2: UIButton = {
        let button = UIButton()
        button.setTitle("학부모 2", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        displayData = acceptedData()
        
        par1.addTarget(self, action: #selector(par1OnTapButton), for: .touchUpInside)
        par2.addTarget(self, action: #selector(par2OnTapButton), for: .touchUpInside)
        seeAll.addTarget(self, action: #selector(seeAllOnTapButton), for: .touchUpInside)
    }
    
    //MARK: - Funcs
    
    func acceptedData() -> [TeacherCalenderData] {
        var acceptedData: [TeacherCalenderData] = []
        var calenderIndex: [Int] = []

        for parentIndex in 0..<mainTeacher.parentUserIds.count {
            calenderIndex = []
            
            for index in 0..<mainTeacher.parentUserIds[parentIndex].schedules[0].scheduleList.count { //하단 funcs 참고
                if mainTeacher.parentUserIds[parentIndex].schedules[0].scheduleList[index].isReserved {
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
        
        for parentIdx in 0..<mainTeacher.parentUserIds.count {
            calenderIndex = []
            for i in 0..<mainTeacher.parentUserIds[parentIdx].schedules[0].scheduleList.count{ //하단 funcs 참고
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
        for i in 0..<mainTeacher.parentUserIds[parentUserIds].schedules[0].scheduleList.count { //mockData에서 신청 날자 String을 뽑아옴
            dateString.append(mainTeacher.parentUserIds[parentUserIds].schedules[0].scheduleList[i].consultingDate)
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
        
        //switch 싫어서 계산식으로 바꿨는데 어떤게 나은지요
        for i in 0..<mainTeacher.parentUserIds[parentUserIds].schedules[0].scheduleList.count{
            let a = mainTeacher.parentUserIds[parentUserIds].schedules[0].scheduleList[i].startTime.components(separatedBy: "시")  //[14, 00], [14, 30], [15, 00], ...
            let time = Int(a[0])!-14 // 14, 14, 15, 15, 16, 16 ... -> 0, 0, 1, 1, 2, 2 ...
            let minute = Int(a[1].replacingOccurrences(of: "분", with: ""))!/30 // 00, 30, 00, 30 ... -> 0, 1, 0, 1, ...
            startTime.append(time*2 + minute)
        }
        return startTime
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
        
        view.addSubview(par1)
        par1.topAnchor.constraint(equalTo: calenderView.topAnchor, constant: 320).isActive = true
        par1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        
        view.addSubview(par2)
        par2.topAnchor.constraint(equalTo: calenderView.topAnchor, constant: 370).isActive = true
        par2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        
        view.addSubview(seeAll)
        seeAll.topAnchor.constraint(equalTo: calenderView.topAnchor, constant: 420).isActive = true
        seeAll.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
    }

    override func configUI() {
        view.backgroundColor = .white
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
        
        for eachData in displayData{ //eachdata = {parentsIds, calenderIdx, cellColor}
            if eachData.calenderIndex.contains(indexPath.item) { //calenderIdx와 일치하는 index의 셀은 cellColor으로 display
                cell.backgroundColor = clickedCell == indexPath.item ? .black : eachData.cellColor
                break //for문을 도는 도중 다른 data로 인해 gray로 display되는것을 방지
            } else {
                cell.backgroundColor = .gray
            }
        }
        return cell
    }
    
    //cell 클릭 액션
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //더블클릭한 경우
        if indexPath.item == clickedCell {
            
            // 확정된 스케줄 이외 다른 스케줄 모두 삭제
            mainTeacher.parentUserIds[parentId!].schedules[0].scheduleList = [mainTeacher.parentUserIds[parentId!].schedules[0].scheduleList[selectedIndex!]]
            mainTeacher.parentUserIds[parentId!].schedules[0].scheduleList[0].isReserved = true
            
            calenderData[parentId!].cellColor = .white

            //onTapButton 함수 실행 -> 수정된 스케줄 데이터 다시 불러오고 확정된 스케줄만 다시 그려줌
            switch parentId {
            case 0: par1OnTapButton()
            case 1: par2OnTapButton()
            default: break
            }
            clickedCell = nil
            calenderView.reloadData()
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
            clickedCell = nil
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
