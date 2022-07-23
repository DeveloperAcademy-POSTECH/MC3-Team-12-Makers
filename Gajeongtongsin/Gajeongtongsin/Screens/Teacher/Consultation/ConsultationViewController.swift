//
//  ReservationViewController.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

class ConsultationViewController: BaseViewController {
      
    
    //MARK: - Properties
    private var choicedCells: [Bool] = Array(repeating: false, count:30) //복수선택 및 선택취소를 위한 array
    private var displayDates: [String] = [] //displayIndex 입력 전 다음주 날자와 비교를 위한 리스트
    private var displayIndex: [Int] = [] //신청버튼 클릭 후 신청내역 날자 인덱스가 저장되는 리스트 (인덱스는 캘린더뷰 기준)
    private var startTime: [Int] = [] //신청버튼 클릭 후 신청내역 시간 인덱스가 저장되는 리스트 ('')
    private var calenderIndex: [Int] = [] //위 두 변수로 캘린더 인덱스 계산한 리스트
    
    //다음 일주일의 날짜 리스트를 반환해주는 함수, 아래의 dayIndex 함수에 사용함
    var nextWeek: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM-dd-e-EEEE"    //e는 1~7(sun~sat)

        let day = formatter.string(from:Date())
        let today = day.components(separatedBy: "-")
        let interval = Double(today[2])
        var nextWeek = [String]()
        
        for i in 0...6 {
            let oneDayString = formatter.string(from: Date(timeIntervalSinceNow: TimeInterval((86400 * (9-Int(interval!)+i))))).components(separatedBy: "-")
            nextWeek.append(oneDayString[0]+oneDayString[1]+"일")
        }
        return nextWeek
    }
    
    //선택한 학부모의 신청 요일(날자)를 리스트로 반환해주는 함수
    func dayIndex(parentUserIds: Int) -> [Int] {
        displayDates = []
        displayIndex = []
        for i in 0...mainTeacher.parentUserIds[parentUserIds].schedules[0].scheduleList.count-1 {
            displayDates.append(mainTeacher.parentUserIds[parentUserIds].schedules[0].scheduleList[i].consultingDate)
        }
        for day in 0...displayDates.count-1 {
            for nextWeekDay in 0...nextWeek.count-1 {
                if displayDates[day] == nextWeek[nextWeekDay] {
                    displayIndex.append(nextWeekDay)
                }
            }
        }
        return displayIndex
    }
    
    func timeIndex(parentUserIds: Int) -> [Int] {
        startTime = []
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calenderView.delegate = self
        calenderView.dataSource = self
        
        par1.addTarget(self, action: #selector(par1OnTapButton), for: .touchUpInside)
        par2.addTarget(self, action: #selector(par2OnTapButton), for: .touchUpInside)
//        seeAll.addTarget(self, action: #selector(seeAllOnTapButton), for: .touchUpInside)
    }
    
    //신청하기 누르면 리로드 & 신청시간 인덱스 subIdx에 저장 / print
    @objc func par1OnTapButton() {
        calenderIndex = []
        for i in 0...2{
            calenderIndex.append(timeIndex(parentUserIds: 0)[i] * 5 + dayIndex(parentUserIds: 0)[i])
        }
        print(calenderIndex)
        calenderView.reloadData()
    }
    
    @objc func par2OnTapButton() {
        calenderIndex = []
        for i in 0...2{
            calenderIndex.append(timeIndex(parentUserIds: 1)[i] * 5 + dayIndex(parentUserIds: 1)[i])
        }
        print(calenderIndex)
        calenderView.reloadData()

    }
    
//    @objc func seeAllOnTapButton() {
//        subIdx = choicedCells.enumerated().compactMap { (idx, element) -> Int? in
//            element ? idx : nil
//        }
//    }

    //MARK: - Funcs
    
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
        if (calenderIndex.count != 0) && (indexPath.item == calenderIndex[0] || indexPath.item == calenderIndex[1] || indexPath.item == calenderIndex[2]) {
            cell.backgroundColor = .blue
        } else {
            cell.backgroundColor = .gray
        }
        return cell
    }
}

extension ConsultationViewController: UICollectionViewDataSource{
    
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
