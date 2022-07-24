//
//  ReservationViewController.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

class ParentsCalenderViewController: BaseViewController {
    
    //MARK: - Properties
    private var choicedCells: [Bool] = Array(repeating: false, count:30) //복수선택 및 선택취소를 위한 array
    private var subIdx: [Int] = [] //신청버튼 클릭 후 신청내역 인덱스가 저장되는 리스트

    // 캘린더뷰
    private let calenderView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CalenderViewCell.self, forCellWithReuseIdentifier: CalenderViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false //필수 !!
        return collectionView
    }()
    
    // 신청/취소 버튼
    private let dismissBtn: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let submitBtn: UIButton = {
        let button = UIButton()
        button.setTitle("신청", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let noteTitle: UILabel = {
        let label = UILabel()
        label.text = "상담용건"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //사유 입력 text view
    private let reasonNote: UITextView = {
        let note = UITextView()
        note.text = "어떤 내용으로 상담을 신청하시나요?"
        note.font = .systemFont(ofSize: 15)
        note.clearsOnInsertion = false
        note.translatesAutoresizingMaskIntoConstraints = false
        note.layer.borderWidth = 0.5
        return note
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calenderView.delegate = self
        calenderView.dataSource = self
        
//        self.navigationController?.popViewController(animated: true)
//        self.navigationController?.isNavigationBarHidden = false
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismiss)
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(systemItem: UIBarButtonItem.SystemItem.cancel)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: submit)
        
        submitBtn.addTarget(self, action: #selector(onTapButton), for: .touchUpInside)
        dismissBtn.addTarget(self, action: #selector(cancelSubmit), for: .touchUpInside)
    }

    //MARK: - Funcs
    
    override func render() {
        view.addSubview(dismissBtn)
        dismissBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        dismissBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true


        view.addSubview(submitBtn)
        submitBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        submitBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true

        
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        calenderView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        calenderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        calenderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        
        view.addSubview(noteTitle)
        noteTitle.topAnchor.constraint(equalTo: calenderView.topAnchor, constant: 330).isActive = true
        noteTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        noteTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        noteTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(reasonNote)
        reasonNote.topAnchor.constraint(equalTo: noteTitle.topAnchor, constant: 35).isActive = true
        reasonNote.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        reasonNote.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        reasonNote.heightAnchor.constraint(equalToConstant: 100).isActive = true
        


    }

    override func configUI() {
        view.backgroundColor = .white
    }
    
    //캘린더뷰 신청 취소
    @objc func cancelSubmit() {
        self.dismiss(animated: true)
    }
    
    //신청하기 누르면 리로드 & 신청시간 인덱스 subIdx에 저장 / print
    @objc func onTapButton() {
        subIdx = choicedCells.enumerated().compactMap { (idx, element) -> Int? in
            element ? idx : nil
        }
        
        print(subIdx)
        choicedCells = Array(repeating: false, count:30)
        calenderView.reloadData()
    }
}

//MARK: - extensions

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
            choicedCells[indexPath[1]].toggle()
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
