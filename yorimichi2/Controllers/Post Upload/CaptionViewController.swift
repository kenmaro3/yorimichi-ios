//
//  CaptionViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import UIKit

//class CaptionViewController: UIViewController, UITextViewDelegate {
//    private let image: UIImage
//
//    private let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.clipsToBounds = true
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
//
//    private let textView: UITextView = {
//        let textView = UITextView()
//        textView.text = "Add caption..."
//        textView.backgroundColor = .secondarySystemBackground
//        textView.textContainerInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
//        textView.font = .systemFont(ofSize: 22)
//        return textView
//    }()
//
//    init(image: UIImage){
//        self.image = image
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//
//        view.addSubview(imageView)
//        view.addSubview(textView)
//        imageView.image = image
//        textView.delegate = self
//
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
//    }
//
//
//    @objc private func didTapPost(){
//        textView.resignFirstResponder()
//
//        guard let username = UserDefaults.standard.string(forKey: "username") else {
//            return
//        }
//        var caption = textView.text ?? ""
//        if caption == "Add caption..."{
//            caption = ""
//        }
//
//        // Generate ID
//        guard let newPostId = createNewPostID(),
//              let dateString = String.date(from: Date()) else{
//                  return
//              }
//
//        // Upload photo
//        StorageManager.shared.uploadPost(data: image.pngData(), id: newPostId, completion: { newPostDownloadURL in
//            guard let url = newPostDownloadURL else {
//                print("error: failed to upload post to storage")
//                return
//            }
//
//            // Find user
//            DatabaseManager.shared.findUser(username: username, completion: { user in
//                guard let user = user else {
//                    print("cannot find user, something went wrong")
//                    return
//                }
//                // Update database
//                let newPost: Post = Post(id: newPostId, caption: caption, postedDate: dateString, likers: [], postUrlString: url.absoluteString, genre: "G001", user: user)
//
//                DatabaseManager.shared.createPost(post: newPost, completion: { [weak self] finished in
//                    guard finished else{
//                        return
//                    }
//
//                    DispatchQueue.main.async{
//                        self?.tabBarController?.tabBar.isHidden = false
//                        self?.tabBarController?.selectedIndex = 0
//                        self?.navigationController?.popToRootViewController(animated: false)
//
//                        NotificationCenter.default.post(name: .didPostNotification, object: nil)
//                    }
//                })
//
//            })
//
//        })
//    }
//    
//    private func createNewPostID() -> String? {
//        let date = Date()
//        let timeStamp = date.timeIntervalSince1970
//        let randomNumber = Int.random(in: 0...1000)
//        guard let username = UserDefaults.standard.string(forKey: "username") else {
//            return nil
//        }
//
//        return "\(username)_\(randomNumber)_\(timeStamp)"
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        let size: CGFloat = view.width/4
//        imageView.frame = CGRect(x: (view.width-size)/2, y: view.safeAreaInsets.top+10, width: size, height: size)
//        textView.frame = CGRect(x: 20, y: imageView.bottom+20, width: view.width-40, height: 100)
//    }
//
//    func textViewDidBeginEditing(_ textView: UITextView){
//        if textView.text == "Add caption..."{
//            textView.text = nil
//        }
//    }
//
//
//}
