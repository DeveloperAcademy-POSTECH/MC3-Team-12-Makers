//
//  ViewController.swift
//  UIComponent
//
//  Created by DaeSeong on 2022/07/28.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Properties
    private lazy var CustomcollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 150)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier:   CardCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomcollectionView.dataSource = self
        render()
    }
    // MARK: - Funcs

func render() {
    view.addSubview(CustomcollectionView)
    CustomcollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    CustomcollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    CustomcollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    CustomcollectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
    CustomcollectionView.heightAnchor.constraint(equalToConstant: 160).isActive = true
}
}

    // MARK: - Extensions
extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as? CardCollectionViewCell else {
            return CardCollectionViewCell() // FIXME: - CardCollectionViewCell갈아끼우면됨.
        }
        
        return cell
    }
    
    
}


