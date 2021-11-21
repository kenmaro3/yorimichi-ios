//
//  YorimichiPostViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/02.
//

//import UIKit
//
//protocol YorimichiPostViewControllerDelegate: AnyObject{
//    func yorimichiPostViewControllerDidTapYorimichiButton(id: String)
//}
//
//class YorimichiPostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
//
//    weak var delegate: YorimichiPostViewControllerDelegate?
//
//    private var post: YorimichiPost
////    private var owner: String
//    private var genre: GenreInfo
//
//    private var collectionView: UICollectionView?
//
//    private var viewModels = [SingleYorimichiPostShowCellType]()
//
//    private var commentBarView = CommentBarView()
//
//    private var observer: NSObjectProtocol?
//    private var hideObserver: NSObjectProtocol?
//
//    private var commentsNumber: Int = 0
//
//
//    // MARK: Init
//    init(post: YorimichiPost, genre: GenreInfo){
//        self.post = post
//        self.genre = genre
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
//
//        DatabaseManager.shared.getYorimichiPost(with: post.id, from: genre, completion: {[weak self] post in
//            guard let post = post else {
//                return
//            }
//
////            guard let owner = self?.owner else {
////                return
////            }
//
//            guard let genre = self?.genre else {
//                return
//            }
//
//            self?.createViewModel(model: post, genre: genre) { success in
//                if !success{}
//                DispatchQueue.main.async {
////                    self?.configureCollectionView()
//                    self?.collectionView?.reloadData()
//                }
//            }
//
//        })
//    }
//
//
//    private func createViewModel(model: YorimichiPost, genre: GenreInfo, completion: @escaping (Bool) -> Void){
//        print("\n\nMMMMMMMM")
//        print(model)
//
////        StorageManager.shared.profilePictureURL(for: username){[weak self] profilePictureURL in
////            guard let strongSelf = self,
////                  let postUrl = URL(string: model.postUrlString),
////                  let profilePictureUrl = profilePictureURL else {
////                      completion(false)
////                      return
////                  }
//        guard let postUrl = URL(string: model.postUrlString) else {
//            return
//        }
//
//            guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
//                return
//            }
//            let isLiked = model.likers.contains(currentUsername)
//
//
//            DatabaseManager.shared.getYorimichiComments(postID: post.id, genre: genre, completion: {[weak self] comments in
//
//                var postData: [SingleYorimichiPostShowCellType] = [
////                    .poster(viewModel: PosterCollectionViewCellViewModel(
////                        username: username,
////                        profilePictureURL: profilePictureUrl
////                    )
////                           ),
//                    .post(viewModel: PostCollectionViewCellViewModel(
//                        postUrl: postUrl
//                    )
//                         ),
//                    .actions(viewModel: PostActionsCollectionViewCellViewModel(isLiked: isLiked)),
//                    .likeCount(viewModel: PostLikesCollectionViewCellViewModel(likers: model.likers)),
//                    .timestamp(viewModel: PostDatetimeCollectionViewCellViewModel(date: model.date)),
//                    .name(viewModel: PostNameCollectionViewCellViewModel(name: model.name)),
//                    .location(viewModel: PostLocationCollectionViewCellViewModel(location: model.location)),
//                    .additionalLocation(viewModel: PostAdditionalLocationCollectionViewCellViewModel(additionalLocation: model.additionalLocation)),
//                    .info(viewModel: PostInfoCollectionViewCellViewModel(info: model.info)),
//                    .rating(viewModel: PostRatingCollectionViewCellViewModel(rating: model.rating))
//
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
////                postData.append(
////                    .timestamp(viewModel: PostDatetimeCollectionViewCellViewModel(date: DateFormatter.formatter.date(from: model.postedDate) ?? Date()))
////                )
//
//                self?.viewModels = postData
//                completion(true)
//
//            })
//
////        }
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
////        case .poster(let viewModel):
////            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else{
////                fatalError()
////            }
////            cell.configure(with: viewModel, index: indexPath.section)
////            cell.delegate = self
////            return cell
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
////        case .caption(let viewModel):
////            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCaptionCollectionViewCell.identifier, for: indexPath) as? PostCaptionCollectionViewCell else{
////                fatalError()
////            }
////            cell.configure(with: viewModel)
////            cell.delegate = self
////
////            return cell
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
//        case .name(let viewModel):
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostNameCollectionViewCell.identifier, for: indexPath) as? PostNameCollectionViewCell else {
//                fatalError()
//            }
//            cell.configure(with: viewModel)
//            return cell
//
//        case .location(let viewModel):
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostLocationCollectionViewCell.identifier, for: indexPath) as? PostLocationCollectionViewCell else {
//                fatalError()
//            }
//
//            cell.configure(with: viewModel)
//            return cell
//
//        case .additionalLocation(let viewModel):
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostAdditionalLocationCollectionViewCell.identifier, for: indexPath) as? PostAdditionalLocationCollectionViewCell else {
//                fatalError()
//            }
//
//            cell.configure(with: viewModel)
//            return cell
//
//        case .info(let viewModel):
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostInfoCollectionViewCell.identifier, for: indexPath) as? PostInfoCollectionViewCell else {
//                fatalError()
//            }
//            cell.configure(with: viewModel)
//            return cell
//
//        case .rating(let viewModel):
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostRatingCollectionViewCell.identifier, for: indexPath) as? PostRatingCollectionViewCell else {
//                fatalError()
//            }
//            cell.configure(with: viewModel)
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
//extension YorimichiPostViewController: PostLikesCollectionViewCellDelegate{
//    func postLikesCollectionViewCellDidTapLikeCount(_ cell: PostLikesCollectionViewCell, index: Int) {
//        let vc = ListViewController(type: .likers(usernames: post.likers))
//
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//
//}
//
//extension YorimichiPostViewController: PostCaptionCollectionViewCellDelegate{
//    func postCaptionCollectionViewCellDidTapCaption(_ cell: PostCaptionCollectionViewCell) {
//        print("tapped on caption")
//    }
//
//
//}
//
//extension YorimichiPostViewController: PostActionsCollectionViewCellDelegate{
//    func postActionsCollectionViewCellDidTapYorimichi(){
//        dismiss(animated: true, completion: nil)
//        delegate?.yorimichiPostViewControllerDidTapYorimichiButton(id: post.id)
//    }
//
//    func postActionsCollectionViewCellDidTapLike(_ cell: PostActionsCollectionViewCell, isLiked: Bool, index: Int) {
//        DatabaseManager.shared.updateYorimichiLike(
//            state: isLiked ? .like : .unlike,
//            postID: post.id,
//            genre: genre,
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
////extension YorimichiPostViewController: PosterCollectionViewCellDelegate{
////    func posterCollectionViewCellDidTapMore(_ cell: PosterCollectionViewCell, index: Int) {
////        let sheet = UIAlertController(title: "Post Actions", message: nil, preferredStyle: .actionSheet)
////        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
////        sheet.addAction(UIAlertAction(title: "Share Post", style: .default, handler: {[weak self] _ in
////            DispatchQueue.main.async {
////                let cellType = self?.viewModels[index]
////                    switch cellType{
////                    case .post(let viewModel):
////                        let vc = UIActivityViewController(activityItems: ["Sharing from Instagram", viewModel.postUrl], applicationActivities: [])
////                        self?.present(vc, animated: true)
////
////                    default:
////                        break
////
////
////                    }
////            }
////
////        }))
////        sheet.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: { _ in
////
////        }))
////        present(sheet, animated: true)
////    }
////
////
////    func posterCollectionViewCellDidTapUsername(_ cell: PosterCollectionViewCell, index: Int) {
////        DatabaseManager.shared.findUser(username: owner, completion: {[weak self] user in
////            guard let user = user else{
////                return
////            }
////            DispatchQueue.main.async {
////                //let vc = ProfileViewController(user: User(username: "kento", email: "kento.river@gmail.com"))
////                let vc = ProfileViewController(user: user)
////                self?.navigationController?.pushViewController(vc, animated: true)
////
////
////            }
////
////
////        })
////    }
////}
//
//extension YorimichiPostViewController: PostCollectionViewCellDelegate{
//    func postCollectionViewDidLike(_ cell: PostCollectionViewCell, index: Int) {
//        DatabaseManager.shared.updateYorimichiLike(
//            state: .like,
//            postID: post.id,
//            genre: genre,
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
//extension YorimichiPostViewController{
//    func configureCollectionView(){
//        let commentHeight: CGFloat = 40
//        let sectionHeightWithoutComment: CGFloat = 1200 + view.width
//        let sectionHeight: CGFloat = sectionHeightWithoutComment + CGFloat(commentsNumber) * commentHeight
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {index, _ -> NSCollectionLayoutSection? in
//
//            // Item
////            let posterItem = NSCollectionLayoutItem(
////                layoutSize: NSCollectionLayoutSize(
////                    widthDimension: .fractionalWidth(1),
////                    heightDimension: .absolute(60)
////                )
////            )
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
//            let timestampItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(40)
//                )
//            )
//
//            let nameItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(60)
//                )
//            )
//
//            let locationItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(60)
//                )
//            )
//
//            let additionalLocationItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(60)
//                )
//            )
//
//            let infoItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(60)
//                )
//            )
//
//            let ratingItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(60)
//                )
//            )
//
//
//            let commentItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(commentHeight)
//                )
//            )
//
//
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
//                postItem,
//                actionsItem,
//                likeCountItem,
//                timestampItem,
//                nameItem,
//                locationItem,
//                additionalLocationItem,
//                infoItem,
//                ratingItem
//            ]
//
//            for _ in 0..<self.commentsNumber{
//                subItems.append(commentItem)
//            }
//
//            subItems.append(timestampItem)
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
////        collectionView.register(
////            PosterCollectionViewCell.self,
////            forCellWithReuseIdentifier: PosterCollectionViewCell.identifier
////        )
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
//        collectionView.register(
//            PostNameCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostNameCollectionViewCell.identifier
//        )
//
//        collectionView.register(
//            PostLocationCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostLocationCollectionViewCell.identifier
//        )
//
//        collectionView.register(
//            PostAdditionalLocationCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostAdditionalLocationCollectionViewCell.identifier
//        )
//
//        collectionView.register(
//            PostInfoCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostInfoCollectionViewCell.identifier
//        )
//
//        collectionView.register(
//            PostRatingCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostRatingCollectionViewCell.identifier
//
//        )
//
//
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
//
//        self.collectionView = collectionView
//    }
//}
//
//extension YorimichiPostViewController: CommentBarViewDelegate{
//    func commentBarViewDidTapComment(_ commentBarView: CommentBarView, withText text: String) {
//        guard let currentUserName = UserDefaults.standard.string(forKey: "username") else {
//            return
//        }
//
//
//        // Find User
//        DatabaseManager.shared.findUser(username: currentUserName, completion: {[weak self] user in
//            guard let user = user else {
//                return
//            }
//
//            guard let strongSelf = self else {
//                return
//            }
//
//            DatabaseManager.shared.createYorimichiComments(postID: strongSelf.post.id,
//                                                           genre: strongSelf.genre,
//                                                           comment: PostComment(
//                                                            text: text,
//                                                            user: user,
//                                                            date: Date()
//                                                           ),
//                                                           completion: { success in
//                DispatchQueue.main.async {
//                    guard success else{
//                        return
//                    }
//                }
//
//            })
//        })
//
//    }
//
//
//}
//
//
