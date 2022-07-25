//
//  ReservationViewController.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

class ParentsCalenderViewController: BaseViewController {
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        calenderView.delegate = self
        calenderView.dataSource = self
        
        subBtn.addTarget(self, action: #selector(onTapButton), for: .touchUpInside)
    }
    
    //MARK: - Properties
    private var choicedCells: [Bool] = Array(repeating: false, count:30) //복수선택 및 선택취소를 위한 array
    private var subIdx: [Int] = [] //신청버튼 클릭 후 신청내역 인덱스가 저장되는 리스트
    private var appendScheduleList: [ScheduleInfo] = []
    private var subDate: [String] = []
//    private var consultingDateDate: Date
    private var consultingDateList: [String] = []
    private var consultingDate: String = "" //consultingDateDate -> consultingDateList -> consultingDate 순으로 탑다운
    private var startTime: String = ""

    private let numberOfRow = 5
    
    // 캘린더뷰
    private let calenderView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CalenderViewCell.self, forCellWithReuseIdentifier: CalenderViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false //필수 !!
        return collectionView
    }()

    
    // 신청버튼
    private let subBtn: UIButton = {
        let button = UIButton()
        button.setTitle("신청하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Funcs
    
    func dateIndexToString(index: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM-dd-e-EEEE"
        let daysAfterToday = (7+(index%weekDays+2)-todayOfTheWeek) //+2는 dateFormat 보정(월요일이 2), +7은 다음주 캘린더가 표시되도록
        let consultingDateDate = Date(timeIntervalSinceNow: TimeInterval((secondsInDay * daysAfterToday)))
        
        consultingDateList = formatter.string(from: consultingDateDate).components(separatedBy: "-") //Date -> [String]
        consultingDate = consultingDateList[0] + consultingDateList[1] + "일" //[String] -> String
        return consultingDate
    }
    
    func timeIndexToString(index: Int) -> String {
        switch index/numberOfRow {
        case 0:
            startTime = "14:00"
        case 1:
            startTime = "14:30"
        case 2:
            startTime = "15:00"
        case 3:
            startTime = "15:30"
        case 4:
            startTime = "16:00"
        case 5:
            startTime = "16:30"
        default:
            startTime = "부니카"
        }
        return startTime
    }
    
    //신청하기 누르면 리로드 & 신청요일, 시간 mackdata에 추가 / print
    @objc func onTapButton() {
        
        appendScheduleList = []
        subIdx = choicedCells.enumerated().compactMap { (idx, element) in element ? idx : nil }
        
        for idx in subIdx {
            appendScheduleList.append(ScheduleInfo(
                consultingDate: dateIndexToString(index: idx),
                startTime: timeIndexToString(index: idx),
                isReserved: nil))
        }
        
        parentList[0].schedules.append(Schedule(
            reservedDate: "7월22일",
            scheduleList: appendScheduleList,
            content: "테스트")
            )
        //TODO : - parentList index를 id 받아서 넣어주어야 함
        

        choicedCells = Array(repeating: false, count:30)
        calenderView.reloadData()
    }
    
    override func render() {
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        calenderView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        calenderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        calenderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        
        view.addSubview(subBtn)
        subBtn.topAnchor.constraint(equalTo: calenderView.topAnchor, constant: 300).isActive = true
        subBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
    }

    override func configUI() {
        view.backgroundColor = .white
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
        cell.backgroundColor = .gray
        return cell
    }
    
    //캘린더 클릭 액션
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
             let cell = collectionView.cellForItem(at: indexPath) as? CalenderViewCell

             //선택한 슬롯 개수 카운터
             let truCnt = choicedCells.filter({$0 == true}).count

             //갯수 3개로 제한 및 선택 토글  +섹션 나눠서 인덱싱 편하게 하기?
             if truCnt<3 && !choicedCells[indexPath.item] {
                 choicedCells[indexPath.item].toggle()
                 cell?.backgroundColor = .blue
             }else if truCnt<=3 && choicedCells[indexPath[1]]{
                 choicedCells[indexPath.item].toggle()
                 cell?.backgroundColor = .gray
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
