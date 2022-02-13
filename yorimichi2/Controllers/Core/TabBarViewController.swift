//
//  TabBarViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import UIKit

class TabBarViewController: UITabBarController {

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
        let home = HomeViewController()
        let explore = ExploreViewController()
        let camera = CameraViewController()
        let map = MapViewController()
        //        let activity = NotificationViewController()
        let profile = ProfileViewController(user: currentUser)
        //let test = TestViewController()
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: explore)
        let nav3 = UINavigationController(rootViewController: map)
        let nav4 = UINavigationController(rootViewController: camera)
        //let nav5 = UINavigationController(rootViewController: activity)
        let nav6 = UINavigationController(rootViewController: profile)
        //let navTest = UINavigationController(rootViewController: test)
        
        nav1.navigationItem.backButtonDisplayMode = .minimal
        nav2.navigationItem.backButtonDisplayMode = .minimal
        nav3.navigationItem.backButtonDisplayMode = .minimal
        nav4.navigationItem.backButtonDisplayMode = .minimal
        //nav5.navigationItem.backButtonDisplayMode = .minimal
        nav6.navigationItem.backButtonDisplayMode = .minimal
        
        //navTest.navigationItem.backButtonDisplayMode = .minimal
        
        home.navigationItem.backButtonDisplayMode = .minimal
        //        explore.navigationItem.backButtonDisplayMode = .minimal
        camera.navigationItem.backButtonDisplayMode = .minimal
        map.navigationItem.backButtonDisplayMode = .minimal
        //        activity.navigationItem.backButtonDisplayMode = .minimal
        profile.navigationItem.backButtonDisplayMode = .minimal
        //test.navigationItem.backButtonDisplayMode = .minimal
        
        nav1.navigationBar.tintColor = .label
        nav2.navigationBar.tintColor = .label
        nav3.navigationBar.tintColor = .label
        nav4.navigationBar.tintColor = .label
        //nav5.navigationBar.tintColor = .label
        nav6.navigationBar.tintColor = .label
        //navTest.navigationBar.tintColor = .label
        
        // Define tab item
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "globe"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Camera", image: UIImage(systemName: "camera"), tag: 4)
        //nav5.tabBarItem = UITabBarItem(title: "Notifications", image: UIImage(systemName: "bell"), tag: 5)
        nav6.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 6)
        //navTest.tabBarItem = UITabBarItem(title: "Test", image: UIImage(systemName: "person.circle"), tag: 6)
        
        
        // Set Controller
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        
        if #available(iOS 15.0, *) {
            nav1.tabBarItem.scrollEdgeAppearance = tabBarAppearance
            nav2.tabBarItem.scrollEdgeAppearance = tabBarAppearance
            nav3.tabBarItem.scrollEdgeAppearance = tabBarAppearance
            nav4.tabBarItem.scrollEdgeAppearance = tabBarAppearance
            nav6.tabBarItem.scrollEdgeAppearance = tabBarAppearance
        } else {
            // Fallback on earlier versions
        }
        
        self.setViewControllers([nav1, nav2, nav3, nav4, nav6], animated: false)
        self.selectedIndex = 2
        
        
    }
    
    private func setUpNotificationBadge(){
        let tabBarItem = self.viewControllers?[4].tabBarItem
        print("didSelect: \(tabBarItem)")
        
        let notificationCount = UserDefaults.standard.integer(forKey: "notificationCount")
        if (notificationCount > 0){
            tabBarItem?.badgeValue = "\(notificationCount)"
            tabBarItem?.badgeColor = UIColor.purple
        }
        else{
            tabBarItem?.badgeValue = nil

        }

    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("tabbar didSelect")
       setUpNotificationBadge()
    }
}


