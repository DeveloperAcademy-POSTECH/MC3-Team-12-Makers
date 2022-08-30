//
//  BaseViewController.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

class BaseViewController: UIViewController {
    // MARK: - Properties
     let appDelegate = UIApplication.shared.delegate as! AppDelegate

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        configUI()
        
    }
    
    // MARK: - Funcs
        // 레이아웃
     func render() {
         
    }
        // UI구성
    func configUI() {
        
    }

}

