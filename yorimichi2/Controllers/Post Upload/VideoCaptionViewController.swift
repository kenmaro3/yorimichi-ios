//
//  VideoVideoCaptionViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/06.
//

import UIKit

//import ProgressHUD
//
//class VideoCaptionViewController: UIViewController {
//    private let videoUrl: URL
//    
//    private let captionTextView: UITextView = {
//        let textView = UITextView()
//        textView.contentInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
//        textView.backgroundColor = .secondarySystemBackground
//        textView.layer.masksToBounds = true
//        textView.layer.cornerRadius = 8
//        return textView
//        
//    }()
//    
//    init(videoUrl: URL){
//        self.videoUrl = videoUrl
//        super.init(nibName: nil, bundle: nil)
//        
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Add Caption"
//        view.backgroundColor = .systemBackground
//        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
//
//        view.addSubview(captionTextView)
//    }
//    
//    @objc private func didTapPost(){
//        
//        guard let username = UserDefaults.standard.string(forKey: "username") else {
//            return
//        }
//        
//        captionTextView.resignFirstResponder()
//        let caption = captionTextView.text ?? ""
//        // Generate a video name that is unique based on id
//        let newVideoName = StorageManager.shared.generateVideoName()
//        
//        ProgressHUD.show("Posting")
//        
//        // Upload video
//        StorageManager.shared.uploadVideo(from: videoUrl, filename: newVideoName, completion: {[weak self] success in
//            DispatchQueue.main.async {
//                
//                if success{
////                    // UPdate database
////                    DatabaseManager.shared.insertPost(fileName: newVideoName, caption: caption, completion: {databaseUpdated in
////                        if databaseUpdated{
////                            HapticsManager.shared.vibrate(for: .success)
////                            ProgressHUD.dismiss()
////                            self?.navigationController?.popToRootViewController(animated: true)
////                            self?.tabBarController?.selectedIndex = 0
////                            self?.tabBarController?.tabBar.isHidden = false
////                        }
////                        else{
////                            HapticManager.shared.vibrate(for: .error)
////                            let alert = UIAlertController(title: "Woops", message: "We were unable to upload your video. please try again.", preferredStyle: .alert)
////                            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
////                            self?.present(alert, animated: true)
////                        }
////                    })
//                    guard let dateString = String.date(from: Date()) else{
//                        return
//                    }
//                    
//                    // Find user
//                    DatabaseManager.shared.findUser(username: username, completion: { user in
//                        guard let user = user else {
//                            print("cannot find user, something went wrong")
//                            return
//                            
//                        }
//                        let newPost = PostModel(id: newVideoName, user: user, postedDate: dateString, fileName: newVideoName, caption: caption, likers: [])
//                        DatabaseManager.shared.createVideoPost(post: newPost, completion: { databaseUpdated in
//                            if databaseUpdated{
//                                HapticManager.shared.vibrate(for: .success)
//                                ProgressHUD.dismiss()
//                                self?.navigationController?.popToRootViewController(animated: true)
//                                self?.tabBarController?.selectedIndex = 0
//                                self?.tabBarController?.tabBar.isHidden = false
//                                
//                            }
//                            else{
//                                HapticManager.shared.vibrate(for: .error)
//                                let alert = UIAlertController(title: "Woops", message: "We were unable to upload your video. please try again.", preferredStyle: .alert)
//                                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//                                self?.present(alert, animated: true)
//                            }
//                        })
//                        
//                    })
//                    
//                    //                    print("posting")
//                    //                    ProgressHUD.dismiss()
//                    //                    self?.navigationController?.popToRootViewController(animated: true)
//                    //                    self?.tabBarController?.selectedIndex = 0
//                    //                    self?.tabBarController?.tabBar.isHidden = false
//                }
//                else{
//                    HapticManager.shared.vibrate(for: .error)
//                    ProgressHUD.dismiss()
//                    let alert = UIAlertController(title: "Woops", message: "We were unable to upload your video. please try again.", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//                    self?.present(alert, animated: true)
//                    
//                }
//            }
//        })
//        
//        // Update database
//        
//        
//        // Reset camera and switch to feed
//        
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        captionTextView.frame = CGRect(x: 5, y: view.safeAreaInsets.top+5, width: view.width-10, height: 150).integral
//    }
//}
