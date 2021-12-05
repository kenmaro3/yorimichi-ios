//
//  ProfileViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import UIKit
import ProgressHUD
import SafariServices

class ProfileViewController: UIViewController, UISearchResultsUpdating{
    private let searchVC = UISearchController(searchResultsController: SearchUserResultsViewController())
    
    private let user: User
    
    private var collectionView: UICollectionView?
    
    private var headerViewModel: ProfileHeaderViewModel?
    
    private var posts = [ProfileCollectionCellType]()
    
    private var isCurrentUser: Bool {
        return user.username.lowercased() == UserDefaults.standard.string(forKey: "username")?.lowercased() ?? ""
    }
    
    private var observer: NSObjectProtocol?
    
    // MARK: - Init
    
    init(user: User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = user.username.uppercased()
        setupSearch()
        configureNavBar()
        configureCollectionView()
        
        guard let currentUserName = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        DatabaseManager.shared.isTargetUserBlocked(for: currentUserName, with: user.username, completion: { [weak self] blocked in
            if(blocked){
                
            }
            else{
                self?.fetchProfileInfo()
            }
            
        })

        
        if isCurrentUser{
            observer = NotificationCenter.default.addObserver(forName: .didPostNotification, object: nil, queue: .main) { [weak self] _ in
                self?.posts.removeAll()
                self?.fetchProfileInfo()
                
            }
        }
    }
    
    private func fetchProfileInfo(){
        let username = user.username
        let group = DispatchGroup()
      
        // Fetch User posts images
        group.enter()
        DatabaseManager.shared.posts(for: username, completion: {[weak self] result in
            defer{
                group.leave()
            }
            
            switch result{
            case .success(let posts):
                //self?.posts = posts
                posts.forEach{
                    self?.posts.append(.photo(viewModel: ProfilePhotoCellViewModel(post: $0)))
                }
//                self?.posts = posts.map({
//                    return .photo(viewModel: ProfilePhotoCellViewModel(post: $0))
//                })
                
            case .failure:
                break
            }
            
        })
        
        
        // Fetch User video posts
        group.enter()
        DatabaseManager.shared.videoPosts(for: username, completion: {[weak self] result in
            defer{
                group.leave()
            }
            
            switch result{
            case .success(let posts):
//                print("here======")
//                print(posts)
//                self?.posts = posts.map({
//                    return .video(viewModel: ProfileVideoCellViewModel(post: $0))
//                })
                posts.forEach{
                    self?.posts.append(.video(viewModel: ProfileVideoCellViewModel(post: $0)))
                    
                }
            case .failure:
                print("failure======")
                break
            
            }
        })
        
        
        // Fetch User header
        var profilePictureUrl: URL?
        var buttonType: ProfileButtonType = .edit
        
        var followers = 0
        var following = 0
        var posts = 0
        
        var name: String?
        var bio: String?
        
        
        // Count (3)
        group.enter()
        DatabaseManager.shared.getUserCounts(username: user.username, complete: {result in
            defer{
                group.leave()
            }
            followers = result.followers
            following = result.following
            posts = result.posts
        })
        
        // Bio, name
        group.enter()
        DatabaseManager.shared.getUserInfo(username: user.username, completion: { userInfo in
            defer{
                group.leave()
            }
            name = userInfo?.name
            bio = userInfo?.bio
        })
        // Profile picture url
        group.enter()
        StorageManager.shared.profilePictureURL(for: user.username, completion: { url in
            defer{
                group.leave()
            }
            profilePictureUrl = url
    
        })
        
        print(isCurrentUser)
        if !isCurrentUser{
            // Get Follow state
            group.enter()
            DatabaseManager.shared.isFollowing(targetUsername: user.username, completion: { isFollowing in
                defer{
                    group.leave()
                }
                buttonType = .follow(isFollowing: isFollowing)
            })
            
        }
        
        group.notify(queue: .main){
            
            self.headerViewModel = ProfileHeaderViewModel(
                profilePictureUrl: profilePictureUrl,
                followerCount: followers,
                followingCount: following,
                postsCount: posts,
                bio: bio,
                name: name,
                buttonType: buttonType
            )
            
            self.collectionView?.reloadData()
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    
    private func configureNavBar(){
        if isCurrentUser{
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "gear"),
                style: .done,
                target: self,
                action: #selector(didTapSettings)
            )
            
        }
        else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "ellipsis"),
                style: .done,
                target: self,
                action: #selector(didTapMore)
            )
            
        }
    }
    
    @objc func didTapMore(){
        let sheet = UIAlertController(title: "ユーザアクション", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "ユーザを通報する", style: .destructive, handler: {[weak self] _ in
            guard let url = URL(string: "https://yorimichi-privacy-policy.webflow.io/") else {
                return
            }
            let vc = SFSafariViewController(url: url)
            DispatchQueue.main.async {
                self?.present(vc, animated: true)
            }
        }))
        
        guard let currentUserName = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        DatabaseManager.shared.isTargetUserBlocked(for: currentUserName, with: user.username, completion: { blocking in
            if (blocking){
                sheet.addAction(UIAlertAction(title: "ユーザのブロックを解除する", style: .default, handler: { [weak self] _ in
                    guard let targetUserName = self?.user.username else{
                        return
                    }
                    DatabaseManager.shared.updateBlock(state: .notBlock, for: targetUserName, completion: { res in
                        if (res) {
                            ProgressHUD.showSuccess("ユーザのブロックを解除しました。")
                        }
                        else{
                            ProgressHUD.showFailed("ユーザのブロック解除ができませんでした。")
                        }
                        
                    })
                }))
            }
            else{
                sheet.addAction(UIAlertAction(title: "ユーザをブロックする", style: .default, handler: { [weak self] _ in
                    
                    guard let targetUserName = self?.user.username else{
                        return
                    }
                    DatabaseManager.shared.updateBlock(state: .block, for: targetUserName, completion: { res in
                        if (res) {
                            ProgressHUD.showSuccess("ユーザをブロックしました。")
                        }
                        else{
                            ProgressHUD.showFailed("ユーザのブロックができませんでした。")
                        }
                        
                    })
                    
                }))
            }
            
        })
        present(sheet, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSignedOutUIIfNeeded()
    }
    
    private func showSignedOutUIIfNeeded(){
        guard !AuthManager.shared.isSignedIn else{
            return
        }
        
        // Show Signed out UI
        let vc = SignInViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    @objc private func didTapSettings(){
        let vc = SettingsViewController()
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    private func setupSearch(){
        (searchVC.searchResultsController as? SearchUserResultsViewController)?.delegate = self
        
        searchVC.searchBar.placeholder = "ユーザの検索..."
        navigationItem.searchController = searchVC
        searchVC.searchResultsUpdater = self
    }
    
    /// when user hit the keyboard key
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsVC = searchController.searchResultsController as? SearchUserResultsViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            return
        }
        
        DatabaseManager.shared.findUsers(with: query){ results in
            resultsVC.update(with: results)
        }
    }

}

extension ProfileViewController: SearchUserResultsViewControllerDelegate{
    func searchUserResultsViewController(_ vc: SearchUserResultsViewController, didSelectResultsUser user: User) {
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


extension ProfileViewController{
    private func configureCollectionView(){
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.33)), subitem: item, count: 3)
            let section = NSCollectionLayoutSection(group: group)
            
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.66)),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
            
            ]
            return section
        }))
        
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.register(VideoPostCollectionViewCell.self, forCellWithReuseIdentifier: VideoPostCollectionViewCell.identifier)
        collectionView.register(ProfileHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        self.collectionView = collectionView
            
            
    }
}


extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellType = posts[indexPath.row]
        switch cellType{
        case .photo(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else{
                fatalError()
            }
            cell.configure(with: URL(string: viewModel.post.postUrlString))
            return cell
        case .video(let viewModel):
            print("caled")
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoPostCollectionViewCell.identifier, for: indexPath) as? VideoPostCollectionViewCell else{
                fatalError()
            }
            cell.configure(with: viewModel.post)
            return cell

            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier,
                for: indexPath) as? ProfileHeaderCollectionReusableView else{
            return UICollectionReusableView()
        }
        
        if let viewModel = headerViewModel {
            headerView.configure(with: viewModel)
            headerView.countContainerView.delegate = self
            
        }
        
        headerView.delegate = self
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let cellType = posts[indexPath.row]
        switch cellType{
        case .photo(let viewModel):
            //let vc = PostViewController(post: viewModel.post, owner: user.username)
            let vc = PhotoPostViewController(model: viewModel.post)
            
            navigationController?.pushViewController(vc, animated: true)
            
        case .video(let viewModel):
            let vc = VideoPostViewController(model: viewModel.post)
//            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
}

extension ProfileViewController: ProfileHeaderCollectionReusableViewDelegate{
    func profileHeaderCollectionReusableViewDidTapImage(_ header: ProfileHeaderCollectionReusableView) {
        guard isCurrentUser else {
            return
        }
        
        let sheet = UIAlertController(title: "プロフィール画像の変更", message: "プロフィール画像の変更をここから行えます。", preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "写真を撮る", style: .default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.allowsEditing = true
                picker.delegate = self
                self?.present(picker, animated: true)
            }
        }))
        
        sheet.addAction(UIAlertAction(title: "写真を選ぶ", style: .default, handler: {[weak self] _ in
            DispatchQueue.main.async{
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.allowsEditing = true
                picker.delegate = self
                self?.present(picker, animated: true)
                
            }
        }))
        
        present(sheet, animated: true)
        
    }
}


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // MARK: - Delegate Image Picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        
        ProgressHUD.show("アップロード中")
        
        StorageManager.shared.uploadProfilePicture(username: user.username, data: image.pngData(), completion: {[weak self] success in
            if success{
                self?.headerViewModel = nil
                self?.posts = []
                self?.fetchProfileInfo()
                
                ProgressHUD.showSuccess("変更しました。")
            }
            else{
                ProgressHUD.showFailed("プロフィール画像の変更に失敗しました。")
            }
        })
        
    }
    
}

extension ProfileViewController: ProfileHeaderCountViewDelegate{
    func profileHeaderCountViewDidTapFollowers(_ containerView: ProfileHeaderCountView) {
        let vc = ListViewController(type: .followers(user: user))
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func profileHeaderCountViewDidTapFollowing(_ containerView: ProfileHeaderCountView) {
        let vc = ListViewController(type: .following(user: user))
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func profileHeaderCountViewDidTapPosts(_ containerView: ProfileHeaderCountView) {
        guard posts.count >= 18 else{
            return
        }
        
        collectionView?.setContentOffset(CGPoint(x: 0, y: view.width*0.4), animated: true)
        
    }
    
    func profileHeaderCountViewDidTapEditProfile(_ containerView: ProfileHeaderCountView) {
        let vc = EditProfileViewController()
        vc.completion = { [weak self] in
            // refetch header info
            self?.headerViewModel = nil
            self?.fetchProfileInfo()
            
            
        }
        
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
        
        
    }
    
    func profileHeaderCountViewDidTapFollow(_ containerView: ProfileHeaderCountView) {
        DatabaseManager.shared.updateRelationship(state: .follow, for: user.username, completion: { [weak self] success in
            if !success{
                ProgressHUD.showFailed("フォローに失敗しました。")
                print("failed to update relationship / follow")
                DispatchQueue.main.async {
                    print("here called follow")
                    self?.collectionView?.reloadData()
                }
            }
            else{
                ProgressHUD.showSuccess("フォローしました。")
            }
        })
        
    }
    
    func profileHeaderCountViewDidTapUnFollow(_ containerView: ProfileHeaderCountView) {
        DatabaseManager.shared.updateRelationship(state: .unfollow, for: user.username, completion: { [weak self] success in
            if !success{
                ProgressHUD.showFailed("フォロー解除に失敗しました。")
                print("failed to update relationship / unfollow")
                DispatchQueue.main.async {
                    print("here called unfollow")
                    self?.collectionView?.reloadData()
                }
            }
            else{
                ProgressHUD.showSuccess("フォローを解除しました。")

            }
        })
        
    }
}


//extension ProfileViewController: VideoPostViewControllerDelegate{
//    func videoPostViewController(_ vc: VideoPostViewController, didTapCommentButtonFor post: PostModel) {
//        let vc = CommentsViewController(viewModel: CommentsViewModel(type: .video(viewModel: post)))
//        vc.delegate = self
//        addChild(vc)
//        vc.didMove(toParent: self)
//        view.addSubview(vc.view)
//        let frame = CGRect(x: 0, y: view.height, width: view.width, height: view.height*0.76)
//        vc.view.frame = frame
//        UIView.animate(withDuration: 0.2){
//            vc.view.frame = CGRect(x: 0, y: self.view.height - frame.height, width: frame.width, height: frame.height)
//        }
//    }
//
//    func videoPostViewController(_ vc: VideoPostViewController, didTapProfileButtonFor post: PostModel) {
//        let user = post.user
//        let vc = ProfileViewController(user: user)
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//
//}


