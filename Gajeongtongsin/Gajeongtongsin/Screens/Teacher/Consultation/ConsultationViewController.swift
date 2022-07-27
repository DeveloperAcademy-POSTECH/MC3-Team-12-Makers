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
    private var displayData: [teacherCalenderData] = []
    private var cellColor: UIColor = .gray
    
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
    
    private lazy var customNavigationBar: CutomNavigationBar = {
        let customNavigationBar = CutomNavigationBar(title: "이번주 상담일정", imageName: "bell", imageSize: 20)
        customNavigationBar.backgroundColor = .white
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        return customNavigationBar
    }()
    
    
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
        customNavigationBar.delegate = self
        render()
        configUI()
        
        par1.addTarget(self, action: #selector(par1OnTapButton), for: .touchUpInside)
        par2.addTarget(self, action: #selector(par2OnTapButton), for: .touchUpInside)
        seeAll.addTarget(self, action: #selector(seeAllOnTapButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }

    
    //MARK: - Funcs
    //선택한 학부모의 신청 요일(날자)를 리스트로 반환해주는 함수
    func dateStringToIndex(parentUserIds: Int) -> [Int] {
        var dateString: [String] = []
        var dateIndex: [Int] = []
        for i in 0..<mainTeacher.parentUserIds[parentUserIds].schedules[0].scheduleList.count {
            dateString.append(mainTeacher.parentUserIds[parentUserIds].schedules[0].scheduleList[i].consultingDate)
        }
        for day in 0..<dateString.count {
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
        for i in 0...2{
            switch mainTeacher.parentUserIds[parentUserIds].schedules[0].scheduleList[i].startTime {
            case "14시00분":
                startTime.append(0)
            case "14시30분":
                startTime.append(1)
            case "15시00분":
                startTime.append(2)
            case "15시30분":
                startTime.append(3)
            case "16시00분":
                startTime.append(4)
            case "16시30분":
                startTime.append(5)
            default:
                startTime.append(100)
            }
        }
        return startTime
    }
    
    //mockdata의 상담예약 관련 데이터를 teacherCalenderDate에 불러오는 함수
    func CalenderDisplayData() -> [teacherCalenderData] {
        var calenderIndex: [Int] = []
        var calenderData: [teacherCalenderData] = []
        calenderData.append(teacherCalenderData(parentIds: 0, calenderIndex: [], cellColor: .green))
        calenderData.append(teacherCalenderData(parentIds: 1, calenderIndex: [], cellColor: .blue))
        calenderData.append(teacherCalenderData(parentIds: 2, calenderIndex: [], cellColor: .red))

        for parentIdx in 0..<mainTeacher.parentUserIds.count {
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
        displayData = []
        displayData.append(CalenderDisplayData()[0])
        
        calenderView.reloadData()
    }
    //버튼 누르면 학부모2 신청시간 display
    @objc func par2OnTapButton() {
        displayData = []
        displayData.append(CalenderDisplayData()[1])
        calenderView.reloadData()

    }
    //버튼 누르면 모든 신청시간 색상별 display
    @objc func seeAllOnTapButton() {
        displayData = CalenderDisplayData()
        calenderView.reloadData()
    }
    
    override func render() {
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
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
        
        view.addSubview(customNavigationBar)
        customNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavigationBar.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

    override func configUI() {
        view.backgroundColor = .white
        setupNavigationBackButton()
    }
    
    func setupNavigationBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
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
        
        for eachData in displayData{ //calenderData = {parentsIds, calenderIdx(해당 Id의 신청시간), cellColor}
            if eachData.calenderIndex.contains(indexPath.item) { //calenderIdx와 일치하는 index의 셀은 cellColor으로 display
                cell.backgroundColor = eachData.cellColor
                break //for문을 도는 도중 다른 data로 인해 gray로 display되는것을 방지
            } else {
                cell.backgroundColor = .gray
            }
        }
        return cell
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
