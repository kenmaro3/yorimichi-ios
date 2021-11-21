//
//  PostViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//
//
//import UIKit
//import ProgressHUD
//
//class PostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
//    public var post: Post
//    private var owner: String
//    
//    private var collectionView: UICollectionView?
//    
//    private var viewModels = [SinglePostCellType]()
//    
//    private var commentBarView = CommentBarView()
//    
//    private var observer: NSObjectProtocol?
//    private var hideObserver: NSObjectProtocol?
//    
//    private var commentsNumber: Int = 0
//    
//    
//    
//    // MARK: Init
//    init(post: Post, owner: String){
//        self.post = post
//        self.owner = owner
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        title = "Yorimichi"
//        
//        configureCollectionView()
//        commentBarView.delegate = self
//        fetchPost()
//        view.addSubview(commentBarView)
//
//        observeKeyBoardChange()
//
//    }
//    
//    private func isCurrentUserOwnsThisPost() -> Bool{
//        guard let username = UserDefaults.standard.string(forKey: "username") else {
//            return false
//        }
//        
//        if username == post.user.username{
//            return true
//        }
//        else{
//            return false
//        }
//        
//        
//    }
//
//    
//    private func observeKeyBoardChange(){
//        observer = NotificationCenter.default.addObserver(
//            forName: UIResponder.keyboardWillChangeFrameNotification,
//            object: nil,
//            queue: .main,
//            using: {notification in
//                guard let userInfo = notification.userInfo,
//                      let height = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else{
//                          return
//                      }
//                UIView.animate(withDuration: 0.2){
//                    self.commentBarView.frame = CGRect(
//                        x: 0,
//                        y: self.view.height-60-height,
//                        width: self.view.width,
//                        height: 70
//                    )
//                    
//                }
//            })
//        
//        hideObserver = NotificationCenter.default.addObserver(
//            forName: UIResponder.keyboardWillHideNotification,
//            object: nil,
//            queue: .main,
//            using: {notification in
//                guard let userInfo = notification.userInfo,
//                      let height = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else{
//                          return
//                      }
//                UIView.animate(withDuration: 0.2){
//
//                    self.commentBarView.frame = CGRect(
//                        x: 0,
//                        y: self.view.height-self.view.safeAreaInsets.bottom-70,
//                        width: self.view.width,
//                        height: 70
//                    )
//                    
//                }
//            })
//    }
//    
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        collectionView?.frame = view.bounds
//        commentBarView.frame = CGRect(
//            x: 0,
//            y: view.height-view.safeAreaInsets.bottom-70,
//            width: view.width,
//            height: 70
//        )
//    }
//
//    
//    public func fetchPost(){
////        guard let username = UserDefaults.standard.string(forKey: "username") else {
////            return
////        }
//        
//        ProgressHUD.show("Loading...")
//        
//        DatabaseManager.shared.getPost(with: post.id, from: owner, completion: {[weak self] post in
//            guard let post = post else {
//                return
//            }
//            
//            guard let owner = self?.owner else {
//                return
//            }
//        
//            self?.createViewModel(model: post, username: owner) { success in
//                if !success{}
//                DispatchQueue.main.async {
//                    ProgressHUD.dismiss()
////                    self?.configureCollectionView()
//                    self?.collectionView?.reloadData()
//                }
//            }
//            
//        })
//    }
//    
//    
//    private func createViewModel(model: Post, username:String, completion: @escaping (Bool) -> Void){
//        StorageManager.shared.profilePictureURL(for: username){[weak self] profilePictureURL in
//            guard let strongSelf = self,
//                  let postUrl = URL(string: model.postUrlString),
//                  let profilePictureUrl = profilePictureURL else {
//                      completion(false)
//                      return
//                  }
//            
//            guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
//                return
//            }
//            let isLiked = model.likers.contains(currentUsername)
//                  
//            
//            DatabaseManager.shared.getComments(postID: strongSelf.post.id, owner: strongSelf.owner, completion: {comments in
//                
//                var postData: [SinglePostCellType] = [
//                    .poster(viewModel: PosterCollectionViewCellViewModel(
//                        username: username,
//                        profilePictureURL: profilePictureUrl
//                    )
//                           ),
//                    .post(viewModel: PostCollectionViewCellViewModel(
//                        postUrl: postUrl
//                    )
//                         ),
//                    .actions(viewModel: PostActionsCollectionViewCellViewModel(isLiked: isLiked)),
//                    .likeCount(viewModel: PostLikesCollectionViewCellViewModel(likers: model.likers)),
//                    .caption(viewModel: PostCaptionCollectionViewCellViewModel(username: username, caption: model.caption)),
//                ]
//                
////                if let comment = comments.first{
////                    postData.append(
////                        .comment(viewModel: comment)
////                    )
////                }
//                
//                comments.forEach{ comment in
//                    postData.append(
//                        .comment(viewModel: comment)
//                    )
//                }
//                
//                self?.commentsNumber = comments.count
//                
//                postData.append(
//                    .timestamp(viewModel: PostDatetimeCollectionViewCellViewModel(date: DateFormatter.formatter.date(from: model.postedDate) ?? Date()))
//                )
//                
//                self?.viewModels = postData
//                completion(true)
//                
//            })
//            
//        }
//            
////            guard let postUrl = URL(string: model.postUrlString) else {
////                return
////            }
//            
//            
//    
//    }
//    
//
//    
//    // CollectionView
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModels.count
//    }
//    
//    let colors: [UIColor] = [
//        .red,
//        .green,
//        .blue,
//        .yellow,
//        .systemPink,
//        .orange
//    ]
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cellType = viewModels[indexPath.row]
//        switch cellType{
//        case .poster(let viewModel):
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else{
//                fatalError()
//            }
//            cell.configure(with: viewModel, index: indexPath.section)
//            cell.delegate = self
//            return cell
//
//        case .post(let viewModel):
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as? PostCollectionViewCell else{
//                fatalError()
//            }
//            cell.configure(with: viewModel, index: indexPath.section)
////            cell.contentView.backgroundColor = colors[indexPath.row]
//            cell.delegate = self
//            return cell
//            
//        case .actions(let viewModel):
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostActionsCollectionViewCell.identifier, for: indexPath) as? PostActionsCollectionViewCell else{
//                fatalError()
//            }
//            cell.configure(with: viewModel, index: indexPath.section)
//            cell.delegate = self
//            return cell
//            
//        case .likeCount(let viewModel):
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostLikesCollectionViewCell.identifier, for: indexPath) as? PostLikesCollectionViewCell else{
//                fatalError()
//            }
//            cell.configure(with: viewModel, index: indexPath.section)
//            cell.delegate = self
//            return cell
//            
//        case .caption(let viewModel):
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCaptionCollectionViewCell.identifier, for: indexPath) as? PostCaptionCollectionViewCell else{
//                fatalError()
//            }
//            cell.configure(with: viewModel)
//            cell.delegate = self
//            
//            return cell
//            
//        case .timestamp(let viewModel):
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostDatetimeCollectionViewCell.identifier, for: indexPath) as? PostDatetimeCollectionViewCell else{
//                fatalError()
//            }
//            cell.configure(with: viewModel)
//            
//            return cell
//            
//        case .comment(let viewModel):
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCollectionViewCell.identifier, for: indexPath) as? CommentCollectionViewCell else{
//                fatalError()
//            }
//            cell.configure(with: viewModel)
//            
//            return cell
//            
//            
//        }
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
////        cell.contentView.backgroundColor = colors[indexPath.row]
////        return cell
//        
//    }
//}
//
//extension PostViewController: PostLikesCollectionViewCellDelegate{
//    func postLikesCollectionViewCellDidTapLikeCount(_ cell: PostLikesCollectionViewCell, index: Int) {
//        let vc = ListViewController(type: .likers(usernames: post.likers))
//
//        navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    
//}
//
//extension PostViewController: PostCaptionCollectionViewCellDelegate{
//    func postCaptionCollectionViewCellDidTapCaption(_ cell: PostCaptionCollectionViewCell) {
//        print("tapped on caption")
//    }
//    
//    
//}
//
//extension PostViewController: PostActionsCollectionViewCellDelegate{
//    func postActionsCollectionViewCellDidTapYorimichi(){
//        
//    }
//    
//    func postActionsCollectionViewCellDidTapLike(_ cell: PostActionsCollectionViewCell, isLiked: Bool, index: Int) {
//        DatabaseManager.shared.updateLike(
//            state: isLiked ? .like : .unlike,
//            postID: post.id,
//            owner: owner,
//            completion: { success in
//                guard success else{
//                    print("failed to like")
//                    return
//                }
//            })
//    }
//    
//    func postActionsCollectionViewCellDidTapComment(_ cell: PostActionsCollectionViewCell, index: Int) {
////        let vc = PostViewController()
////        vc.title = "Post"
////        navigationController?.pushViewController(vc, animated: true)
//        commentBarView.field.becomeFirstResponder()
//    }
//    
//    func postActionsCollectionViewCellDidTapShare(_ cell: PostActionsCollectionViewCell, index: Int) {
//        let cellType = viewModels[index]
//        switch cellType{
//        case .post(let viewModel):
//            let vc = UIActivityViewController(activityItems: ["Sharing from Instagram", viewModel.postUrl], applicationActivities: [])
//            present(vc, animated: true)
//
//        default:
//            break
//                
//                
//        }
//            
//   // call DB to update like state
//    }
//    
//
//}
//
//extension PostViewController: PosterCollectionViewCellDelegate{
//    func posterCollectionViewCellDidTapMore(_ cell: PosterCollectionViewCell, index: Int) {
//        let sheet = UIAlertController(title: "Post Actions", message: nil, preferredStyle: .actionSheet)
//        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        sheet.addAction(UIAlertAction(title: "Share Post", style: .default, handler: {[weak self] _ in
//            DispatchQueue.main.async {
//                let cellType = self?.viewModels[index]
//                    switch cellType{
//                    case .post(let viewModel):
//                        let vc = UIActivityViewController(activityItems: ["Sharing from Yorimichi", viewModel.postUrl], applicationActivities: [])
//                        self?.present(vc, animated: true)
//
//                    default:
//                        break
//                        
//                        
//                    }
//            }
//            
//        }))
//        
//        if isCurrentUserOwnsThisPost(){
//            sheet.addAction(UIAlertAction(title: "Delete Post", style: .default, handler: {[weak self] _ in
//                print("delete called")
//                self?.deletePost()
//            }))
//        }
//        sheet.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: { _ in
//            
//        }))
//        present(sheet, animated: true)
//    }
//    
//    private func deletePost(){
//        ProgressHUD.show("Deleting...")
//        let group = DispatchGroup()
//        
//        group.enter()
//        DatabaseManager.shared.deletePost(post: post, completion: { res in
//            defer{
//                group.leave()
//            }
//            if !res {
//                print("failed deletePost")
//            }
//        })
//        
//        group.enter()
//        DatabaseManager.shared.deleteYorimichiPost(post: post, completion: { res in
//            defer{
//                group.leave()
//            }
//            if !res {
//                print("failed deleteYorimichiPost")
//            }
//
//        })
//        
//        group.enter()
//        StorageManager.shared.deletePost(post: post, completion: { res in
//            defer{
//                group.leave()
//            }
//            if !res {
//                print("failed deletePost")
//            }
//
//        })
//        
//        group.enter()
//        StorageManager.shared.deleteYorimichiPost(post: post, completion: { res in
//            defer{
//                group.leave()
//            }
//            if !res {
//                print("failed deleteYorimichiPost")
//            }
//        })
//        
//        group.notify(queue: .main){[weak self] in
//            ProgressHUD.showSuccess("Deleted!")
//            DispatchQueue.main.async {
//                self?.tabBarController?.selectedIndex = 0
//                self?.navigationController?.popToRootViewController(animated: false)
//
//            }
//        }
//        
//    }
//    
//    
//    func posterCollectionViewCellDidTapUsername(_ cell: PosterCollectionViewCell, index: Int) {
//        DatabaseManager.shared.findUser(username: owner, completion: {[weak self] user in
//            guard let user = user else{
//                return
//            }
//            DispatchQueue.main.async {
//                //let vc = ProfileViewController(user: User(username: "kento", email: "kento.river@gmail.com"))
//                let vc = ProfileViewController(user: user)
//                self?.navigationController?.pushViewController(vc, animated: true)
//
//                
//            }
//            
//            
//        })
//    }
//}
//
//extension PostViewController: PostCollectionViewCellDelegate{
//    func postCollectionViewDidLike(_ cell: PostCollectionViewCell, index: Int) {
//        DatabaseManager.shared.updateLike(
//            state: .like,
//            postID: post.id,
//            owner: owner,
//            completion: { success in
//                guard success else{
//                    print("failed to like")
//                    return
//                }
//            })
//
//    }
//}
//
//
//
//
//extension PostViewController{
//    func configureCollectionView(){
//        let commentHeight: CGFloat = 40
//        let sectionHeightWithoutComment: CGFloat = 300 + view.width
//        let sectionHeight: CGFloat = sectionHeightWithoutComment + CGFloat(commentsNumber) * commentHeight
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {index, _ -> NSCollectionLayoutSection? in
//            
//            // Item
//            let posterItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(60)
//                )
//            )
//            
//            let postItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .fractionalWidth(1)
//                )
//            )
//            
//            let actionsItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(40)
//                )
//            )
//            
//            let likeCountItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(40)
//                )
//            )
//            
//            let commentItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(commentHeight)
//                )
//            )
//            
//            let captionItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(60)
//                )
//            )
//            
//            let timestampItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(40)
//                )
//            )
//            
//            // Cell for poster
//            // Bigger cell for the post
//            // Actions cell
//            // Like count cell
//            // Captions cell
//            // Timestamp cell
//            
//            
//            // Group
//            var subItems: [NSCollectionLayoutItem] = [
//                posterItem,
//                postItem,
//                actionsItem,
//                likeCountItem,
//                captionItem,
//                timestampItem
//            ]
//            
//            for _ in 0..<self.commentsNumber{
//                subItems.append(commentItem)
//            }
//                  
//            
//            let group = NSCollectionLayoutGroup.vertical(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(sectionHeight)
//                ),
//                subitems:
//                    subItems
////                subitems:[
////                    posterItem,
////                    postItem,
////                    actionsItem,
////                    likeCountItem,
////                    captionItem,
////                    commentItem,
////                    timestampItem
////                ]
//            )
//            
//            // Section
//            let section = NSCollectionLayoutSection(group: group)
//            section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0)
//            return section
//        })
//        )
//        view.addSubview(collectionView)
//        collectionView.backgroundColor = .systemBackground
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//        
//        collectionView.register(
//            PosterCollectionViewCell.self,
//            forCellWithReuseIdentifier: PosterCollectionViewCell.identifier
//        )
//
//        
//        collectionView.register(
//            PostCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostCollectionViewCell.identifier
//        )
//        
//        collectionView.register(
//            PostActionsCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostActionsCollectionViewCell.identifier
//        )
//        
//        collectionView.register(
//            PostLikesCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostLikesCollectionViewCell.identifier
//        )
//        
//        collectionView.register(
//            PostCaptionCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostCaptionCollectionViewCell.identifier
//        )
//        
//        
//        collectionView.register(
//            PostDatetimeCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostDatetimeCollectionViewCell.identifier
//        )
//        
//        collectionView.register(
//            CommentCollectionViewCell.self,
//            forCellWithReuseIdentifier: CommentCollectionViewCell.identifier
//        
//        )
//        
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
//        
//        self.collectionView = collectionView
//    }
//}
//
//extension PostViewController: CommentBarViewDelegate{
//    func commentBarViewDidTapComment(_ commentBarView: CommentBarView, withText text: String) {
//        guard let currentUserName = UserDefaults.standard.string(forKey: "username") else {
//            return
//        }
//        
//        // Find User
//        DatabaseManager.shared.findUser(username: currentUserName, completion: {[weak self] user in
//            guard let user = user else {
//                print("cannot find user aborte")
//                return
//            }
//            
//            guard let strongSelf = self else {
//                return
//            }
//            
//            DatabaseManager.shared.createComments(postID: strongSelf.post.id,
//                                                  owner: strongSelf.owner,
//                                                  comment: PostComment(text: text,
//                                                                       user: user,
//                                                                       date: Date()
//                                                                      ),
//                                                  completion: { success in
//                DispatchQueue.main.async {
//                    guard success else{
//                        return
//                    }
//                }
//                
//            })
//            
//            
//        })
//        
//    }
//    
//    
//}
//
//
