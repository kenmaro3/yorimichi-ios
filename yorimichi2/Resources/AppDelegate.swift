//
//  AppDelegate.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import Firebase
import UIKit
import Appirater

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Appirater.appLaunched(true)
        Appirater.setAppId("123456789012345")
        Appirater.setDebug(false)
        Appirater.setDaysUntilPrompt(3)
        
        FirebaseApp.configure()
        
        UserDefaults.standard.setValue(true, forKey: "save_photo")
        UserDefaults.standard.setValue(true, forKey: "save_video")
        
        UserDefaults.standard.setValue("Walk", forKey: "methods")
        UserDefaults.standard.setValue("フードおまかせ", forKey: "genre")
        UserDefaults.standard.setValue("Yorimichi DB", forKey: "source")
        
//        // Add dummy notification for current user
//        let identifier = NotificationManager.newIdentifier()
//        let model = IGNotification(notificationType: 3,
//                                   identifier: identifier,
//                                   profilePictureUrl: "https://iosacademy.io/assets/images/brand/icon.jpg",
//                                   username: "azami",
//                                   dateString: String.date(from: Date()) ?? "Now",
//                                   isFollowing: false,
//                                   postId: nil,
//                                   postUrl: nil
////                                   postUrl: "https://iosacademy.io/assets/images/courses/swiftui.png"
//                                   )
//        NotificationManager.shared.create(notification: model, for: "kenmaro")
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Appirater.appEnteredForeground(true)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

