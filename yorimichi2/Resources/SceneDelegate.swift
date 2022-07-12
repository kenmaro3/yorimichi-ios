//
//  SceneDelegate.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private func showRequiredVersionAlertIfNeeded() {
        DatabaseManager.shared.getRequiredUpdateVersion(completion: {[weak self] requiredVersion in
            guard let requiredVersion = requiredVersion else {
                return
            }
            
            if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
               requiredVersion.compare(currentVersion) == .orderedDescending {
                let alert = UIAlertController(title: "アップデートのお知らせ", message: "YorimichiAppの新規バージョンがご利用になれます。今すぐ\(requiredVersion)にアップデートしてください。", preferredStyle: .alert)
                alert.addAction(.init(title: "アップデート", style: .default, handler: { _ in
                    // MARK: Force unwrap🚨
                    let url = URL(string: "https://apps.apple.com/jp/app/apple-store/id1596625712")!
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }))
                self?.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
            
        })
    }
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        
        if let username = UserDefaults.standard.string(forKey: "username"){
            let isGhost = UserDefaults.standard.bool(forKey: "isGhost")
            if(isGhost){
                // Sign in VC
                let vc = SignInViewController()
                let navVC = UINavigationController(rootViewController: vc)
                window.rootViewController = navVC
            }
            else{
                if let email = UserDefaults.standard.string(forKey: "email"){
                    if AuthManager.shared.isSignedIn{
                        // Signed in
                        window.rootViewController = TabBarViewController()
                        
                    }
                    else{
                        // Sign in VC
                        let vc = SignInViewController()
                        let navVC = UINavigationController(rootViewController: vc)
                        window.rootViewController = navVC
                    }
                }
                
            }
        }
        else{
            // Sign in VC
            let vc = SignInViewController()
            let navVC = UINavigationController(rootViewController: vc)
            window.rootViewController = navVC
            
        }
        
        window.makeKeyAndVisible()
        self.window = window
        showRequiredVersionAlertIfNeeded()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

