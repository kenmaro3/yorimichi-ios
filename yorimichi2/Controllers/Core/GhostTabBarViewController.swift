
//
//  TabBarViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import UIKit

class GhostTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let email = UserDefaults.standard.string(forKey: "email"),
              let username = UserDefaults.standard.string(forKey: "username")
        else{
            print("\n\n\n===========================")
            print("cannot find email or username from UserDefault")
            return
            
        }
        
        let currentUser: User = User(username: username, email: email)
        
        // Define VC
        let explore = ExploreViewController()
        let camera = CameraViewController()
        let map = MapViewController()
        
        let nav2 = UINavigationController(rootViewController: explore)
        let nav3 = UINavigationController(rootViewController: map)
        let nav4 = UINavigationController(rootViewController: camera)
        
        nav2.navigationItem.backButtonDisplayMode = .minimal
        nav3.navigationItem.backButtonDisplayMode = .minimal
        nav4.navigationItem.backButtonDisplayMode = .minimal
        
        
        camera.navigationItem.backButtonDisplayMode = .minimal
        map.navigationItem.backButtonDisplayMode = .minimal
        
        nav2.navigationBar.tintColor = .label
        nav3.navigationBar.tintColor = .label
        nav4.navigationBar.tintColor = .label
        
//        var ghost_icon = UIImage(named: "ghost_icon")
//        nav2.tabBarItem = UITabBarItem(title: "Explore", image: ghost_icon, tag: 2)
        nav2.tabBarItem = UITabBarItem(title: "Explore(ゴーストモード)", image: UIImage(systemName: "globe"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Camera", image: UIImage(systemName: "camera"), tag: 4)
        
        
        // Set Controller
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        
        if #available(iOS 15.0, *) {
            nav2.tabBarItem.scrollEdgeAppearance = tabBarAppearance
            nav3.tabBarItem.scrollEdgeAppearance = tabBarAppearance
            nav4.tabBarItem.scrollEdgeAppearance = tabBarAppearance
        } else {
            // Fallback on earlier versions
        }
        
        
        self.setViewControllers([nav2, nav3, nav4], animated: false)
        self.selectedIndex = 1
        
    }
}


