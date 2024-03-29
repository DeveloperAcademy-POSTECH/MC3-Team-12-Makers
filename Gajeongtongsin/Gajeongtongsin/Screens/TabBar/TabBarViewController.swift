//
//  TabBarViewController.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/07/16.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let role : Role
    var vc1: UINavigationController?
    var vc2: UINavigationController?
    var vc3: UINavigationController?
  
    // MARK: - Init
    init(role : Role) {
        self.role = role
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        setToken()
       
    }
    
  
    // MARK: - Funcs
    func configureTabBar() {
        switch role {
        case .parent:
             vc1 =  UINavigationController(rootViewController: ReservationViewController())
             vc2 =  UINavigationController(rootViewController: SentMessageListViewController())
             vc3 =  UINavigationController(rootViewController: ParentProfileViewController())
        case .teacher:
             vc1 =  UINavigationController(rootViewController: ConsultationViewController())
             vc2 =  UINavigationController(rootViewController: MessageViewController())
             vc3 =  UINavigationController(rootViewController: ProfileViewController())
        }
       
        guard let vc1 = vc1 else {return}
        guard let vc2 = vc2 else {return}
        guard let vc3 = vc3 else {return}

        vc1.tabBarItem = UITabBarItem(title: TabPage.reservation.title,
                                      image: TabPage.reservation.getTabBarIcon(),
                                       tag: 0)
        vc2.tabBarItem = UITabBarItem(title: TabPage.suggestion.title,
                                      image: TabPage.suggestion.getTabBarIcon(),
                                       tag: 1)
        vc3.tabBarItem = UITabBarItem(title: TabPage.profile.title,
                                      image: TabPage.profile.getTabBarIcon(),
                                       tag: 2)

        tabBar.tintColor = .Action
        tabBar.backgroundColor = .Background
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.LightLine.cgColor
        setViewControllers([vc1,vc2,vc3], animated: true)
    }
    
    func setToken() {
        if role == .parent {
            if let token = UserDefaults.standard.string(forKey: "TeacherToken") {
                appDelegate.teacherToken = token
                
            } else {
                FirebaseManager.shared.fetchTeacherToken { [weak self] token in
                    self?.appDelegate.teacherToken = token ?? ""
                }
            }
        }
    }

}


