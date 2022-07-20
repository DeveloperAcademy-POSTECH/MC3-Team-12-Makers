//
//  ReservationViewController.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

class ReservationViewController: BaseViewController {
    
    var choicedCells = [Bool](repeating: false, count:30) //복수선택 및 선택취소를 위한 array
    var subIdx: [Int] = [] //신청버튼 클릭 후 신청내역 인덱스가 저장되는 리스트

    //MARK: 캘린더뷰
    let calenderView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CalenderViewCell.self, forCellWithReuseIdentifier: CalenderViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false //필수 !!
        return collectionView
    }()
    
    //MARK: 신청버튼
    private let subBtn: UIButton = {
        let button = UIButton()
        button.setTitle("신청하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calenderView.delegate = self
        calenderView.dataSource = self
        
        subBtn.addTarget(self, action: #selector(onTapButton), for: .touchUpInside)
    }
    
    @objc //신청하기 누르면 리로드 & 신청시간 인덱스 subIdx에 저장 / print
    func onTapButton() {
        for i in 0...choicedCells.count-1 {
            if choicedCells[i] {
                subIdx.append(i)
            }
        }
        print(subIdx)
        choicedCells = [Bool](repeating: false, count:30)
        calenderView.reloadData()
    }

    //MARK: - Funcs
    
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

//MARK: - extensions

extension ReservationViewController: UICollectionViewDelegate{
     
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

        //갯수 3개로 제한 및 선택 토글
        if truCnt<3 && !choicedCells[indexPath[1]] {
            choicedCells[indexPath[1]].toggle()
            cell?.backgroundColor = .blue
        }else if truCnt<=3 && choicedCells[indexPath[1]]{
            choicedCells[indexPath[1]].toggle()
            cell?.backgroundColor = .gray
        }
    }
}

extension ReservationViewController: UICollectionViewDataSource{
    
    //캘린더 아이템 수, 5일*6단위 = 30
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
 }

extension ReservationViewController: UICollectionViewDelegateFlowLayout {
    
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
