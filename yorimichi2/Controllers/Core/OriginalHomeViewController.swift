//
//  OriginalOriginalHomeViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/06.
//

//import UIKit
//
//class OriginalHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    private var collectionView: UICollectionView?
//    
//    private var viewModels = [[HomeFeedCellType]]()
//    
//    private var postObserver: NSObjectProtocol?
//    private var likeActionObserver: NSObjectProtocol?
//    private var likeDoubleTapObserver: NSObjectProtocol?
//    
//    private var allPosts: [(post: Post, owner: String)] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        title = "Yorimichi"
//        
//        configureCollectionView()
//        fetchPosts()
//        
//        postObserver = NotificationCenter.default.addObserver(forName: .didPostNotification, object: nil, queue: .main) { [weak self] _ in
//            self?.viewModels.removeAll()
//            self?.fetchPosts()
//            
//        }
//        
//        
////        likeActionObserver = NotificationCenter.default.addObserver(forName: .didLikeByAction, object: nil, queue: .main) { [weak self] _ in
////            self?.viewModels.removeAll()
////            self?.fetchPosts()
////
////        }
////
////        likeDoubleTapObserver = NotificationCenter.default.addObserver(forName: .didLikeByDoubleTap, object: nil, queue: .main) { [weak self] _ in
////            self?.viewModels.removeAll()
////            self?.fetchPosts()
////
////        }
//
//    }
//    
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        collectionView?.frame = view.bounds
//    }
//
//    
////    private func fetchPosts(){
////        // mock data
////        guard let username = UserDefaults.standard.string(forKey: "username") else {
////            return
////        }
////
////        DatabaseManager.shared.posts(for: username){[weak self] result in
////            DispatchQueue.main.async {
////                switch result{
////                    case .success(let posts):
////                        let group = DispatchGroup()
////                        posts.forEach{ model in
////                            group.enter()
////                            self?.createViewModel(model: model, username: username) { success in
////                                defer{
////                                    group.leave()
////                                }
////
////                                if !success{
////
////                                }
////
////                            }
////
////                        }
////
////                        group.notify(queue: .main){
////                            self?.collectionView?.reloadData()
////                        }
////                            print("\n\n\nPosts: \(posts.count)")
////                    case .failure(let error):
////                        print(error)
////                    }
////                }
////        }
////        //viewModels.append(postData)
////        //collectionView?.reloadData()
////    }
//    
//    public func fetchPosts(){
//        guard let username = UserDefaults.standard.string(forKey: "username") else {
//            return
//        }
//        
//        let userGroup = DispatchGroup()
//        userGroup.enter()
//        var allPosts: [(post: Post, owner: String)] = []
//        DatabaseManager.shared.followers(for: username, completion: {usernames in
//            defer{
//                userGroup.leave()
//            }
//            var users = usernames + [username]
//            for current in users{
//                userGroup.enter()
//                DatabaseManager.shared.posts(for: current){[weak self] result in
//                    DispatchQueue.main.async {
//                        switch result{
//                            case .success(let posts):
//                                allPosts.append(contentsOf: posts.compactMap({
//                                    (post: $0, owner: current)
//                                }))
//                                userGroup.leave()
//
//                            case .failure(let error):
//                                userGroup.leave()
//                                break
//                        }
//                    }
//                }
//                        
//            }
//        })
//        
//        userGroup.notify(queue: .main){
//            self.allPosts = allPosts
//            let sorted = allPosts.sorted(by: {
//                return $0.post.date > $1.post.date
//            })
//            let group = DispatchGroup()
//            sorted.forEach{ model in
//                group.enter()
//                self.createViewModel(model: model.post, username: model.owner) { success in
//                    defer{
//                        group.leave()
//                    }
//                    if !success{}
//                }
//            
//            }
//            group.notify(queue: .main){
//                self.sortPosts()
//                self.collectionView?.reloadData()
//            }
//            
//        }
//    }
//    
//    private func sortPosts(){
//        self.allPosts = self.allPosts.sorted(by: {first, second in
//            let date1 = first.post.date
//            let date2 = first.post.date
//            return date1 > date2
//        })
//            
//        
//        self.viewModels = self.viewModels.sorted(by: {first, second in
//            var date1: Date?
//            var date2: Date?
//            first.forEach{ type in
//                switch type {
//                case .timestamp(let vm):
//                    date1 = vm.date
//                default:
//                    break
//                }
//                
//            }
//            
//            second.forEach { type in
//                switch type {
//                case .timestamp(let vm):
//                    date2 = vm.date
//                default:
//                    break
//                }
//                
//            }
//            
//            if let date1 = date1, let date2 = date2{
//                return date1 > date2
//            }
//            return false
//        })
//        
//    }
//    
//    
//    private func createViewModel(model: Post, username:String, completion: @escaping (Bool) -> Void){
//        let group = DispatchGroup()
//        group.enter()
////        group.enter()
//        
////        var postURL: URL?
//        var profilePictureURL: URL?
////        StorageManager.shared.downloadURL(for: model){ [weak self] url in
////            defer{
////                group.leave()
////            }
////            postURL = url
////        }
//        StorageManager.shared.profilePictureURL(for: username){ url in
//            defer{
//                group.leave()
//            }
//            profilePictureURL = url
//            
//        }
//        group.notify(queue: .main, execute: {
//            
////            guard let postUrl = URL(string: model.postUrlString), let profilePhotoURL = profilePictureURL else{
////                fatalError("failed to get URL")
////            }
//            guard let postUrl = URL(string: model.postUrlString) else {
//                return
//            }
//            
//            guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
//                completion(false)
//                return
//                
//            }
//            let isLiked = model.likers.contains(currentUsername)
//            
//            let postData: [HomeFeedCellType] = [
//                .poster(viewModel: PosterCollectionViewCellViewModel(
//                    username: username,
//                    //profilePictureURL: URL(string: "https://iosacademy.io/assets/images/brand/icon.jpg")!
////                    profilePictureURL: profilePhotoURL
//                    profilePictureURL: profilePictureURL
//                    )
//                ),
//                .post(viewModel: PostCollectionViewCellViewModel(
//                    postUrl: postUrl
//                )
//                ),
//                .actions(viewModel: PostActionsCollectionViewCellViewModel(isLiked: isLiked)),
//                .likeCount(viewModel: PostLikesCollectionViewCellViewModel(likers: model.likers)),
//                .caption(viewModel: PostCaptionCollectionViewCellViewModel(username: username, caption: model.caption)),
//                .timestamp(viewModel: PostDatetimeCollectionViewCellViewModel(date: DateFormatter.formatter.date(from: model.postedDate) ?? Date()))
//            ]
//                
//            self.viewModels.append(postData)
//            completion(true)
//        })
//    
//    }
//    
//
//    
//    // CollectionView
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return viewModels.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModels[section].count
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
//        let cellType = viewModels[indexPath.section][indexPath.row]
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
//        }
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
////        cell.contentView.backgroundColor = colors[indexPath.row]
////        return cell
//        
//    }
//    
//    func collectionView(
//        _ collectionView: UICollectionView,
//        viewForSupplementaryElementOfKind kind: String,
//        at indexPath: IndexPath
//    ) -> UICollectionReusableView {
//        guard kind == UICollectionView.elementKindSectionHeader,
//              let headerView = collectionView.dequeueReusableSupplementaryView(
//                ofKind: kind,
//                withReuseIdentifier: StoryHeaderView.identifier,
//                for: indexPath
//              ) as? StoryHeaderView else {
//                  return UICollectionReusableView()
//              }
//        
//        let viewModel = StoriesViewModel(stories: [
//            Story(username: "jeff bazos", image: UIImage(named: "test")),
//            Story(username: "jeff bazos", image: UIImage(named: "test")),
//            Story(username: "jeff bazos", image: UIImage(named: "test")),
//            Story(username: "jeff bazos", image: UIImage(named: "test")),
//
//        
//        ])
//        headerView.configure(with: viewModel)
//        
//        return headerView
//        
//    }
//}
//
//extension OriginalHomeViewController: PostLikesCollectionViewCellDelegate{
//    func postLikesCollectionViewCellDidTapLikeCount(_ cell: PostLikesCollectionViewCell, index: Int) {
//        HapticManager.shared.vibrateForSelection()
//        let vc = ListViewController(type: .likers(usernames: allPosts[index].post.likers))
//        navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    
//}
//
//extension OriginalHomeViewController: PostCaptionCollectionViewCellDelegate{
//    func postCaptionCollectionViewCellDidTapCaption(_ cell: PostCaptionCollectionViewCell) {
//        print("tapped on caption")
//    }
//    
//    
//}
//
//extension OriginalHomeViewController: PostActionsCollectionViewCellDelegate{
//    func postActionsCollectionViewCellDidTapYorimichi() {
//        
//    }
//    
//    func postActionsCollectionViewCellDidTapLike(_ cell: PostActionsCollectionViewCell, isLiked: Bool, index: Int) {
//        AnalyticsManager.shared.logFeedInteraction(.like)
//        let tuple = allPosts[index]
//        DatabaseManager.shared.updateLike(
//            state: isLiked ? .like : .unlike,
//            postID: tuple.post.id,
//            owner: tuple.owner,
//            completion: { success in
//                guard success else{
//                    print("failed to like")
//                    return
//                }
//            })
//    }
//    
//    func postActionsCollectionViewCellDidTapComment(_ cell: PostActionsCollectionViewCell, index: Int) {
//        AnalyticsManager.shared.logFeedInteraction(.comment)
//        let tuple = allPosts[index]
//        HapticManager.shared.vibrateForSelection()
//        let vc = PostViewController(post: tuple.post, owner: tuple.owner)
//        vc.title = "Post"
//        navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    func postActionsCollectionViewCellDidTapShare(_ cell: PostActionsCollectionViewCell, index: Int) {
//        AnalyticsManager.shared.logFeedInteraction(.share)
//        let section = viewModels[index]
//        section.forEach{ cellType in
//            switch cellType{
//            case .post(let viewModel):
//                let vc = UIActivityViewController(activityItems: ["Sharing from Yorimichi", viewModel.postUrl], applicationActivities: [])
//                present(vc, animated: true)
//
//            default:
//                break
//                
//                
//            }
//            
//        }
//   // call DB to update like state
//    }
//    
//
//}
//
//extension OriginalHomeViewController: PosterCollectionViewCellDelegate{
//    func posterCollectionViewCellDidTapMore(_ cell: PosterCollectionViewCell, index: Int) {
//        let sheet = UIAlertController(title: "Post Actions", message: nil, preferredStyle: .actionSheet)
//        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        sheet.addAction(UIAlertAction(title: "Share Post", style: .default, handler: {[weak self] _ in
//            DispatchQueue.main.async {
//                let section = self?.viewModels[index] ?? []
//                section.forEach{ cellType in
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
//                }
//            }
//            
//        }))
//        sheet.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: { _ in
//            AnalyticsManager.shared.logFeedInteraction(.reported)
//            
//        }))
//        present(sheet, animated: true)
//    }
//    
//    
//    func posterCollectionViewCellDidTapUsername(_ cell: PosterCollectionViewCell, index: Int) {
//        let section = self.viewModels[index] ?? []
//        section.forEach{ cellType in
//            switch cellType{
//            case .poster(let viewModel):
//                let owner = viewModel.username
//                DatabaseManager.shared.findUser(username: owner, completion: {[weak self] user in
//                    guard let user = user else{
//                        return
//                    }
//                    DispatchQueue.main.async {
//                        let vc = ProfileViewController(user: user)
//                        self?.navigationController?.pushViewController(vc, animated: true)
//                        
//                        
//                    }
//                    
//                    
//                })
//
//                
//            default:
//                break
//                
//                
//            }
//        }
//        
//    }
//}
//
//extension OriginalHomeViewController: PostCollectionViewCellDelegate{
//    func postCollectionViewDidLike(_ cell: PostCollectionViewCell, index: Int) {
//        AnalyticsManager.shared.logFeedInteraction(.doubleTapToLike)
//        let tuple = allPosts[index]
//        DatabaseManager.shared.updateLike(
//            state: .like,
//            postID: tuple.post.id,
//            owner: tuple.owner,
//            completion: { success in
//                guard success else{
//                    print("failed to like")
//                    return
//                }
//            })
//        print("did tap twice")
//    }
//}
//
//
//
//
//extension OriginalHomeViewController{
//    func configureCollectionView(){
//        let sectionHeight: CGFloat = 240 + view.width
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
//            let group = NSCollectionLayoutGroup.vertical(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(sectionHeight)
//                ),
//                subitems:[
//                    posterItem,
//                    postItem,
//                    actionsItem,
//                    likeCountItem,
//                    captionItem,
//                    timestampItem
//                ]
//            )
//            
//            
//            
//            // Section
//            let section = NSCollectionLayoutSection(group: group)
//            
//            // MARK: - Stories commented
////            if index == 0 {
////                section.boundarySupplementaryItems = [
////                    NSCollectionLayoutBoundarySupplementaryItem(
////                        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.3)),
////                        elementKind: UICollectionView.elementKindSectionHeader,
////                        alignment: .top
////                    )
////
////                ]
////            }
//
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
//            StoryHeaderView.self,
//            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
//            withReuseIdentifier: StoryHeaderView.identifier
//        )
//        
//        self.collectionView = collectionView
//    }
//}
//
//
