//
//  PhotoInfoEditViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/26.
//

import UIKit
import ProgressHUD
import AVFoundation
import MapKit
import Mapbox


class PhotoEditInfoViewController: UIViewController {
    let geocoder = CLGeocoder()
    // locationManager で現在地を取得する
    private var locationManager:CLLocationManager!
    
    private var userCurrentLocation = CLLocation()
    
    enum SubmitType{
        case photo(image: UIImage)
        case video(url: URL)
    }
    
    private var collectionView: UICollectionView?
    private var viewModels: [PhotoEditInfoCellType] = [PhotoEditInfoCellType]()
    private var caption = ""
    private var genre: GenreInfo?
    private var locationTitle: String?
    private var locationSubTitle: String?
    private var location: Location?
    private var submitType: SubmitType?
    
    private var loadForUpdate: Bool = false
    private var loadPost: Post? = nil
    
//    init(image: UIImage){
//        self.image = image
//        super.init(nibName: nil, bundle: nil)
//    }
    
//    private let helpHeader: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .left
//        label.numberOfLines = 0
//        label.text = "投稿時のヘルプ"
//        label.font = UIFont.boldSystemFont(ofSize: 18.0)
//        label.textColor = .label
//
//        return label
//    }()
//
//    private let captionHelp: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .left
//        label.numberOfLines = 0
//        label.text = "キャプションについて"
//        label.font = .systemFont(ofSize: 15)
//        label.textColor = .label
//
//        return label
//    }()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController!.view.backgroundColor = .systemBackground
        
//        self.edgesForExtendedLayout = UIRectEdge.init()
        extendedLayoutIncludesOpaqueBars = true
        title = "投稿の編集"
        
        print("\n\nhere===============")
        print(viewModels)

        setUpCollectionView()
        
        if(!self.loadForUpdate){
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "投稿する", style: .done, target: self, action: #selector(didTapPost))
            
        }
        else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "更新する", style: .done, target: self, action: #selector(didTapUpdate))
            
        }
        genre = GenreInfo(code: "G000", type: .food)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 10, width: view.width, height: view.height)
    }
    
    public func loadInfomationForUpdate(image: UIImage, post: Post){
        viewModels.append(.post(viewModel: PhotoEditInfoPostViewModel(image: image)))
        viewModels.append(.caption)
        viewModels.append(.location(viewModel: PhotoEditInfoLocationViewModel(titleHeader: "場所検索", title: post.locationTitle, subTitle: post.locationSubTitle)))
        viewModels.append(.location(viewModel: PhotoEditInfoLocationViewModel(titleHeader: "場所手動入力", title: post.locationTitle, subTitle: post.locationSubTitle)))
        viewModels.append(.genre(viewModel: PhotoEditInfoGenreViewModel(genre: post.genre)))
        
        submitType = .photo(image: image)
        
        self.loadForUpdate = true
        self.loadPost = post
        
        
        self.caption = post.caption
        self.genre = post.genre
        self.locationTitle = post.locationTitle
        self.locationSubTitle = post.locationSubTitle
        self.location = post.location
    }
    
    
    // MARK: - CollectionView Registration

    private func setUpCollectionView(){
        configureCollectionViewLayout()
        collectionView?.backgroundColor = .secondarySystemBackground
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.register(PhotoEditInfoCollectionPostViewCell.self, forCellWithReuseIdentifier: PhotoEditInfoCollectionPostViewCell.identifier)
        collectionView?.register(PhotoEditInfoCollectionCaptionViewCell.self, forCellWithReuseIdentifier: PhotoEditInfoCollectionCaptionViewCell.identifier)
        collectionView?.register(PhotoEditInfoCollectionLocationViewCell.self, forCellWithReuseIdentifier: PhotoEditInfoCollectionLocationViewCell.identifier)
        collectionView?.register(PhotoEditInfoCollectionGenreViewCell.self, forCellWithReuseIdentifier: PhotoEditInfoCollectionGenreViewCell.identifier)
        collectionView?.register(PhotoEditInfoCollectionVideoViewCell.self,
            forCellWithReuseIdentifier: PhotoEditInfoCollectionVideoViewCell.identifier)
        
    }
    
    // MARK: - CollectionView ViewModels
    
    public func createPhotoViewModels(image: UIImage){
        viewModels.append(.post(viewModel: PhotoEditInfoPostViewModel(image: image)))
        viewModels.append(.caption)
        viewModels.append(.location(viewModel: PhotoEditInfoLocationViewModel(titleHeader: "場所検索", title: "名称から検索", subTitle: "場所詳細")))
        viewModels.append(.location(viewModel: PhotoEditInfoLocationViewModel(titleHeader: "場所手動指定", title: "マップ上で手動ピン付け", subTitle: "場所詳細")))
        viewModels.append(.genre(viewModel: PhotoEditInfoGenreViewModel(genre: GenreInfo(code: "G000", type: .food))))
        
        submitType = .photo(image: image)
    }
    
    public func createVideoViewModels(url: URL){
        viewModels.append(.video(viewModel: PhotoEditInfoVideoViewModel(url: url)))
        viewModels.append(.caption)
        viewModels.append(.location(viewModel: PhotoEditInfoLocationViewModel(titleHeader: "場所検索", title: "名称から検索", subTitle: "場所詳細")))
        viewModels.append(.location(viewModel: PhotoEditInfoLocationViewModel(titleHeader: "場所手動指定", title: "マップ上で手動ピン付け", subTitle: "場所詳細")))
        viewModels.append(.genre(viewModel: PhotoEditInfoGenreViewModel(genre: GenreInfo(code: "G000", type: .food))))
        
        submitType = .video(url: url)
    }
    
    public func configureForEditPost(){
        print("configure called")
    }
    
    
    // MARK: - Posting
    
    private func createNewPostID() -> String? {
        let date = Date()
        let timeStamp = date.timeIntervalSince1970
        let randomNumber = Int.random(in: 0...1000)
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return nil
        }
        
        return "\(username)_\(randomNumber)_\(timeStamp)"
    }
    
    private func createNewPostIDForSpecific(username: String) -> String? {
        let date = Date()
        let timeStamp = date.timeIntervalSince1970
        let randomNumber = Int.random(in: 0...1000)
        
        return "\(username)_\(randomNumber)_\(timeStamp)"
    }
    
    
    @objc private func didTapUpdate(){
        guard var updatePost = self.loadPost else{
            return
        }
        print("here caption2")
        print(caption)
        updatePost.caption = caption
        
        if let location = location {
            updatePost.location = location
        }
        if let locationTitle = locationTitle {
            updatePost.locationTitle = locationTitle
        }
        if let locationSubTitle = locationSubTitle {
            updatePost.locationSubTitle = locationSubTitle

        }
        if let genre = genre {
            updatePost.genre = genre

        }
        
        print("after mod\n\n\(updatePost)")
        
        DatabaseManager.shared.updatePost(post: updatePost, completion: {[weak self] res in
            print("\n\n\nhereee===============\(res)")
            
            // MARK: Upload for YorimichiData For All Genre
            DatabaseManager.shared.createYorimichiPostAtAll(
                post: updatePost, completion: {[weak self] finished in
                    guard finished else{
                        return
                    }

                })

            // MARK: Upload for YorimichiData
            DatabaseManager.shared.createYorimichiPost(
                post: updatePost, completion: {[weak self] finished in
                    guard finished else{
                        return
                    }

                    ProgressHUD.showSuccess("投稿を更新しました。")
                    self?.tabBarController?.tabBar.isHidden = false
                    self?.tabBarController?.selectedIndex = 0
                    self?.navigationController?.popToRootViewController(animated: false)

                    NotificationCenter.default.post(name: .didPostNotification, object: nil)
                })
        })
    }
    
    @objc private func didTapPost(){
        if (caption == ""){
            let alert = UIAlertController(title: "キャプションが入力されていません。", message: "キャプション入力後に、キーボードの確定ボタンを押してください。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                return
                
            }))
            present(alert, animated: true)
            return
        }
        else{
            print("\n\nhere caption=================")
            print(caption)
            print(locationTitle)
            print(locationSubTitle)
            print(genre)
            print(location)
        }
        
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        // Generate ID
        guard let newPostId = createNewPostID(),
              let dateString = String.date(from: Date()) else{
                  return
              }
        guard let newPostIdSpecific = createNewPostIDForSpecific(username: "名無しさん"),
              let dateString = String.date(from: Date()) else{
                  return
              }
        
        guard let locationTitle = locationTitle,
              let locationSubTitle = locationSubTitle,
              let genre = genre,
              let location = location else{
                  let alert = UIAlertController(title: "場所情報が入力されていません。", message: "場所情報を検索、もしくは手入力してください。", preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                      return
                      
                  }))
                  present(alert, animated: true)
                  return
              }
        
        guard let submitType = submitType else {
            return
        }
        
        
        let sheet = UIAlertController(title: "投稿アクション", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        
        sheet.addAction(UIAlertAction(title: "通常投稿", style: .default, handler: {[weak self] _ in
            print("\n\nmodification called+++++++++++++")
            switch submitType{
            case .photo(let image):
                
                ProgressHUD.show("投稿しています...")
                
                // MARK: Upload for User Post Data
                StorageManager.shared.uploadPost(data: image.pngData(), id: newPostId, completion: { newPostDownloadURL in
                    guard let url = newPostDownloadURL else {
                        print("error: failed to upload post to storage")
                        return
                    }
                    
                    
                    // Find user
                    
                    DatabaseManager.shared.findUser(username: username, completion: { user in
                        guard let user = user else {
                            print("cannot find user, something went wrong")
                            return
                        }
                        // Update database
                        let newPost: Post = Post(
                            id: newPostId,
                            caption: self?.caption ?? "",
                            locationTitle: locationTitle,
                            locationSubTitle: locationSubTitle,
                            location: location,
                            postedDate: dateString,
                            likers: [],
                            yorimichi: [],
                            postUrlString: url.absoluteString,
                            postThumbnailUrlString: "",
                            genre: genre,
                            user: user,
                            isVideo: false
                        )
                        
                        DatabaseManager.shared.createPost(post: newPost, completion: { [weak self] finished in
                            guard finished else{
                                return
                            }
                            
                            // MARK: Upload for YorimichiData For All Genre
                            DatabaseManager.shared.createYorimichiPostAtAll(
                                post: newPost, completion: {[weak self] finished in
                                    guard finished else{
                                        return
                                    }
                                    
                                })
                            
                            // MARK: Upload for YorimichiData
                            DatabaseManager.shared.createYorimichiPost(
                                post: newPost, completion: {[weak self] finished in
                                    guard finished else{
                                        return
                                    }
                                    
                                    ProgressHUD.showSuccess("投稿しました。")
                                    self?.tabBarController?.tabBar.isHidden = false
                                    self?.tabBarController?.selectedIndex = 0
                                    self?.navigationController?.popToRootViewController(animated: false)
                                    
                                    NotificationCenter.default.post(name: .didPostNotification, object: nil)
                                })
                            
                        })
                        
                    })
                    
                    
                    
                })
                
                
            case .video(let url):
                // Generate a video name that is unique based on id
                let newVideoId = StorageManager.shared.generateVideoName()
                
                ProgressHUD.show("ビデオを投稿しています...")
                
                // Genereate thumbnail
                let asset = AVAsset(url: url)
                let generator = AVAssetImageGenerator(asset: asset)
                
                var uploadingThumbnail = UIImage()
                
                do{
                    let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
                    let thumbnail = UIImage(cgImage: cgImage)
                    let resizedThumbnail = thumbnail.sd_resizedImage(with: CGSize(width: 640, height: 640), scaleMode: .aspectFill)
                    
                    if let resizedThumbnail = resizedThumbnail {
                        uploadingThumbnail = resizedThumbnail
                        uploadingThumbnail.sd_rotatedImage(withAngle: 90, fitSize: true)
                    }else{
                        
                    }
                    
                }
                catch{
                    print(error)
                }
                
                StorageManager.shared.uploadThumbnail(data: uploadingThumbnail.pngData(), id: newVideoId, completion: { newPostDownloadURL in
                    guard let thumbnailUrl = newPostDownloadURL else {
                        print("error: failed to upload post to storage")
                        return
                    }
                    
                    // Upload video
                    //            let newVideoName = "\(newVideoId).mov"
                    StorageManager.shared.uploadVideo(from: url, id: newVideoId, completion: {[weak self] success in
                        DispatchQueue.main.async {
                            
                            if success{
                                guard let dateString = String.date(from: Date()) else{
                                    return
                                }
                                
                                // Find user
                                DatabaseManager.shared.findUser(username: username, completion: { user in
                                    guard let user = user else {
                                        print("cannot find user, something went wrong")
                                        return
                                        
                                    }
                                    let newPost = Post(
                                        id: newVideoId,
                                        caption: self?.caption ?? "",
                                        locationTitle: locationTitle,
                                        locationSubTitle: locationSubTitle,
                                        location: location,
                                        postedDate: dateString,
                                        likers: [],
                                        yorimichi: [],
                                        postUrlString: "",
                                        postThumbnailUrlString: thumbnailUrl.absoluteString,
                                        genre: genre,
                                        user: user,
                                        isVideo: true
                                    )
                                    DatabaseManager.shared.createVideoPost(post: newPost, completion: { databaseUpdated in
                                        if databaseUpdated{
                                            HapticManager.shared.vibrate(for: .success)
                                            self?.navigationController?.popToRootViewController(animated: true)
                                            self?.tabBarController?.selectedIndex = 0
                                            self?.tabBarController?.tabBar.isHidden = false
                                            
                                            // MARK: Upload for YorimichiData
                                            DatabaseManager.shared.createYorimichiVideoPost(
                                                post: newPost, completion: {[weak self] finished in
                                                    guard finished else{
                                                        return
                                                    }
                                                    
                                                    ProgressHUD.showSuccess("投稿しました。")
                                                    self?.tabBarController?.tabBar.isHidden = false
                                                    self?.tabBarController?.selectedIndex = 0
                                                    self?.navigationController?.popToRootViewController(animated: false)
                                                    
                                                    NotificationCenter.default.post(name: .didPostNotification, object: nil)
                                                    
                                                })
                                            
                                            // MARK: Upload for YorimichiData For All Genre
                                            DatabaseManager.shared.createYorimichiVideoPostAtAll(
                                                post: newPost, completion: {[weak self] finished in
                                                    guard finished else{
                                                        return
                                                    }
                                                    
                                                })
                                            
                                        }
                                        else{
                                            HapticManager.shared.vibrate(for: .error)
                                            let alert = UIAlertController(title: "ビデオ投稿エラー", message: "ビデオ投稿ができませんでした。再度お試しください。", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                            self?.present(alert, animated: true)
                                        }
                                    })
                                    
                                })
                                
                                
                            }
                            else{
                                HapticManager.shared.vibrate(for: .error)
                                ProgressHUD.dismiss()
                                let alert = UIAlertController(title: "ビデオ投稿エラー", message: "ビデオ投稿ができませんでした。再度お試しください。", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                self?.present(alert, animated: true)
                                
                            }
                        }
                    })
                    
                })
                
                
                
            }

        }))
        
        
        sheet.addAction(UIAlertAction(title: "匿名投稿", style: .default, handler: {[weak self] _ in
            print("\n\nmodification called+++++++++++++")
            switch submitType{
            case .photo(let image):
                
                ProgressHUD.show("投稿しています...")
                
                // MARK: Upload for User Post Data
                StorageManager.shared.uploadPost(data: image.pngData(), id: newPostIdSpecific, completion: { newPostDownloadURL in
                    guard let url = newPostDownloadURL else {
                        print("error: failed to upload post to storage")
                        return
                    }
                    
                    
                    // Find user
                    
                    DatabaseManager.shared.findUser(username: "名無しさん", completion: { user in
                        guard let user = user else {
                            print("cannot find user, something went wrong")
                            return
                        }
                        // Update database
                        let newPost: Post = Post(
                            id: newPostIdSpecific,
                            caption: self?.caption ?? "",
                            locationTitle: locationTitle,
                            locationSubTitle: locationSubTitle,
                            location: location,
                            postedDate: dateString,
                            likers: [],
                            yorimichi: [],
                            postUrlString: url.absoluteString,
                            postThumbnailUrlString: "",
                            genre: genre,
                            user: user,
                            isVideo: false
                        )
                        
                        DatabaseManager.shared.createPostSpecificUser(post: newPost, completion: { [weak self] finished in
                            guard finished else{
                                return
                            }
                            
                            // MARK: Upload for YorimichiData For All Genre
                            DatabaseManager.shared.createYorimichiPostAtAll(
                                post: newPost, completion: {[weak self] finished in
                                    guard finished else{
                                        return
                                    }
                                    
                                })
                            
                            // MARK: Upload for YorimichiData
                            DatabaseManager.shared.createYorimichiPost(
                                post: newPost, completion: {[weak self] finished in
                                    guard finished else{
                                        return
                                    }
                                    
                                    ProgressHUD.showSuccess("投稿しました。")
                                    self?.tabBarController?.tabBar.isHidden = false
                                    self?.tabBarController?.selectedIndex = 0
                                    self?.navigationController?.popToRootViewController(animated: false)
                                    
                                    NotificationCenter.default.post(name: .didPostNotification, object: nil)
                                })
                            
                        })
                        
                    })
                    
                    
                    
                })
                
                
            case .video(let url):
                // Generate a video name that is unique based on id
                let newVideoId = StorageManager.shared.generateVideoName()
                
                ProgressHUD.show("ビデオを投稿しています...")
                
                // Genereate thumbnail
                let asset = AVAsset(url: url)
                let generator = AVAssetImageGenerator(asset: asset)
                
                var uploadingThumbnail = UIImage()
                
                do{
                    let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
                    let thumbnail = UIImage(cgImage: cgImage)
                    let resizedThumbnail = thumbnail.sd_resizedImage(with: CGSize(width: 640, height: 640), scaleMode: .aspectFill)
                    
                    if let resizedThumbnail = resizedThumbnail {
                        uploadingThumbnail = resizedThumbnail
                        uploadingThumbnail.sd_rotatedImage(withAngle: 90, fitSize: true)
                    }else{
                        
                    }
                    
                }
                catch{
                    print(error)
                }
                
                StorageManager.shared.uploadThumbnail(data: uploadingThumbnail.pngData(), id: newVideoId, completion: { newPostDownloadURL in
                    guard let thumbnailUrl = newPostDownloadURL else {
                        print("error: failed to upload post to storage")
                        return
                    }
                    
                    // Upload video
                    //            let newVideoName = "\(newVideoId).mov"
                    StorageManager.shared.uploadVideoForSpecificUser(username: "名無しさん", from: url, id: newVideoId, completion: {[weak self] success in
                        DispatchQueue.main.async {
                            
                            if success{
                                guard let dateString = String.date(from: Date()) else{
                                    return
                                }
                                
                                // Find user
                                DatabaseManager.shared.findUser(username: "名無しさん", completion: { user in
                                    guard let user = user else {
                                        print("cannot find user, something went wrong")
                                        return
                                        
                                    }
                                    let newPost = Post(
                                        id: newVideoId,
                                        caption: self?.caption ?? "",
                                        locationTitle: locationTitle,
                                        locationSubTitle: locationSubTitle,
                                        location: location,
                                        postedDate: dateString,
                                        likers: [],
                                        yorimichi: [],
                                        postUrlString: "",
                                        postThumbnailUrlString: thumbnailUrl.absoluteString,
                                        genre: genre,
                                        user: user,
                                        isVideo: true
                                    )
                                    DatabaseManager.shared.createVideoPostForSpecific(post: newPost, completion: { databaseUpdated in
                                        if databaseUpdated{
                                            HapticManager.shared.vibrate(for: .success)
                                            self?.navigationController?.popToRootViewController(animated: true)
                                            self?.tabBarController?.selectedIndex = 0
                                            self?.tabBarController?.tabBar.isHidden = false
                                            
                                            // MARK: Upload for YorimichiData
                                            DatabaseManager.shared.createYorimichiVideoPost(
                                                post: newPost, completion: {[weak self] finished in
                                                    guard finished else{
                                                        return
                                                    }
                                                    
                                                    ProgressHUD.showSuccess("投稿しました。")
                                                    self?.tabBarController?.tabBar.isHidden = false
                                                    self?.tabBarController?.selectedIndex = 0
                                                    self?.navigationController?.popToRootViewController(animated: false)
                                                    
                                                    NotificationCenter.default.post(name: .didPostNotification, object: nil)
                                                    
                                                })
                                            
                                            // MARK: Upload for YorimichiData For All Genre
                                            DatabaseManager.shared.createYorimichiVideoPostAtAll(
                                                post: newPost, completion: {[weak self] finished in
                                                    guard finished else{
                                                        return
                                                    }
                                                    
                                                })
                                            
                                        }
                                        else{
                                            HapticManager.shared.vibrate(for: .error)
                                            let alert = UIAlertController(title: "ビデオ投稿エラー", message: "ビデオ投稿ができませんでした。再度お試しください。", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                            self?.present(alert, animated: true)
                                        }
                                    })
                                    
                                })
                                
                                
                            }
                            else{
                                HapticManager.shared.vibrate(for: .error)
                                ProgressHUD.dismiss()
                                let alert = UIAlertController(title: "ビデオ投稿エラー", message: "ビデオ投稿ができませんでした。再度お試しください。", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                self?.present(alert, animated: true)
                                
                            }
                        }
                    })
                    
                })
                
                
                
            }

        }))
        
        present(sheet, animated: true)
        
        
    }
    
    // MARK: - CollectionView Layout
    
    private func configureCollectionViewLayout(){
        let sectionHeight: CGFloat = 500

        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {index, _ ->
            NSCollectionLayoutSection? in
            
            // Item
            let postItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120)))
            
            let captionItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)))
            let locationItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)))
            let directLocationItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)))
            let genreItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)))
            
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(sectionHeight)), subitems: [postItem, captionItem, locationItem, directLocationItem, genreItem])
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            return section
            
        })
        
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        
        self.collectionView = collectionView
        
    }
}


extension PhotoEditInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = viewModels[indexPath.row]
        print(cellType)
        switch cellType{
        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoEditInfoCollectionPostViewCell.identifier, for: indexPath) as? PhotoEditInfoCollectionPostViewCell else {
                fatalError()
            }
            
            cell.imageView.image = viewModel.image
            return cell
            
        case .video(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoEditInfoCollectionVideoViewCell.identifier, for: indexPath) as? PhotoEditInfoCollectionVideoViewCell else {
                fatalError()
            }
            
            cell.configure(url: viewModel.url)
            return cell
            
        case .caption:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoEditInfoCollectionCaptionViewCell.identifier, for: indexPath) as? PhotoEditInfoCollectionCaptionViewCell else {
                fatalError()
            }
            
            cell.delegate = self
            if(self.loadForUpdate){
                cell.field.text = self.loadPost?.caption
            }
            return cell
            
        case .location(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoEditInfoCollectionLocationViewCell.identifier, for: indexPath) as? PhotoEditInfoCollectionLocationViewCell else {
                fatalError()
            }
            
            cell.configure(viewModel: viewModel)
            cell.delegate = self
            
            return cell
            
        case .genre(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoEditInfoCollectionGenreViewCell.identifier, for: indexPath) as? PhotoEditInfoCollectionGenreViewCell else {
                fatalError()
            }
            
            cell.configure(viewModel: viewModel)
            cell.delegate = self
            
            return cell
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           print("選択しました: \(indexPath.row)")
    }
}


extension PhotoEditInfoViewController: PhotoEditInfoCollectionLocationViewCellDelegate{
    func photoEditInfoCollectionLocationViewCellDidTapLocation() {
        let vc = SearchLocationViewController()
//        navigationController?.pushViewController(vc, animated: true)
        vc.delegate = self
        //navigationController?.pushViewController(vc, animated: true)
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    func photoEditInfoCollectionLocationViewCellDidTapDirectLocation() {
        let vc = DirectSearchLocationViewController()
        vc.delegate = self
        present(UINavigationController(rootViewController: vc), animated: true)
    }
}

extension PhotoEditInfoViewController: PhotoEditInfoCollectionGenreViewCellDelegate{
    func photoEditInfoCollectionGenreViewCellDidTapGenre() {
        let vc = SearchGenreViewController()
        vc.delegate = self
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    
}

extension PhotoEditInfoViewController: SearchLocationViewControllerDelegate{
//    func searchLocationViewControllerDidEnterDirectLocation(text: String?, location: Location) {
//        print("tapped location direct entered")
//        self.locationTitle = text
//        self.locationSubTitle = ""
//        self.location = location
//        
//        let model = PhotoEditInfoCellType.location(viewModel: PhotoEditInfoLocationViewModel(title: text ?? "", subTitle: "マップ上で選択済み"))
//        viewModels[2] = model
//        self.collectionView?.reloadData()
//    }
    
    func searchLocationViewControllerDidSelected(title: String, subTitle: String, location: Location) {
        print("\n\n")
        print(title)
        print(subTitle)
        dismiss(animated: true, completion: nil)

        let model = PhotoEditInfoCellType.location(viewModel: PhotoEditInfoLocationViewModel(titleHeader: "場所検索", title: title, subTitle: subTitle))
        viewModels[2] = model
        let modelDirect = PhotoEditInfoCellType.location(viewModel: PhotoEditInfoLocationViewModel(titleHeader: "場所手動入力", title: title, subTitle: subTitle))
        viewModels[3] = modelDirect
        self.locationTitle = title
        self.locationSubTitle = subTitle
        self.location = location
        self.collectionView?.reloadData()
    }
}

extension PhotoEditInfoViewController: DirectSearchLocationViewControllerDelegate{
    func searchLocationViewControllerDidEnterDirectLocation(text: String?, location: Location) {
        print("tapped location direct entered")
        self.locationTitle = text
        self.locationSubTitle = ""
        self.location = location
        
        let model = PhotoEditInfoCellType.location(viewModel: PhotoEditInfoLocationViewModel(titleHeader: "場所検索", title: text ?? "", subTitle: "マップ上で選択済み"))

        let modelDirect = PhotoEditInfoCellType.location(viewModel: PhotoEditInfoLocationViewModel(titleHeader: "場所手動入力", title: self.locationTitle ?? "", subTitle: "マップ上で選択済み"))
        self.viewModels[2] = model
        self.viewModels[3] = modelDirect
        self.collectionView?.reloadData()
    }
    
}

extension PhotoEditInfoViewController: SearchGenreViewControllerDelegate{
    func searchGenreViewControllerDidSelected(code: String) {
        print("here called \(code)")
        
        var genreType: GenreType = GenreType.food
        if (foodGenreList.contains(code)){
            genreType = GenreType.food
        }
        else if (spotGenreList.contains(code)){
            genreType = GenreType.spot
        }
        else if (shopGenreList.contains(code)){
            genreType = GenreType.shop
        }
        let model = PhotoEditInfoCellType.genre(viewModel: PhotoEditInfoGenreViewModel(genre: GenreInfo(code: code, type: genreType)))
        viewModels[4] = model
        self.collectionView?.reloadData()
        if (foodGenreList.contains(code)){
            self.genre = GenreInfo(code: code, type: .food)
        }
        else if (spotGenreList.contains(code)){
            self.genre = GenreInfo(code: code, type: .spot)
        }
        else if (shopGenreList.contains(code)){
            self.genre = GenreInfo(code: code, type: .shop)
        }
        else{
            fatalError("cannot find genre from list")
        }
        //dismiss(animated: true, completion: nil)
    }
    
    
}

extension PhotoEditInfoViewController: PhotoEditInfoCollectionCaptionViewCellDelegate{
    func photoEditInfoCollectionCaptionViewCellDidEndEditing(text: String) {
        caption = text
        print("here caption1: \(caption)")

    }
    
    
}

extension PhotoEditInfoViewController: CLLocationManagerDelegate{
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func getLocationString(location: CLLocation){
        //逆ジオコーディング
        self.geocoder.reverseGeocodeLocation( location, completionHandler: {[weak self] ( placemarks, error ) in
            if let placemark = placemarks?.first {
                self?.locationSubTitle = "\(placemark.administrativeArea ?? "") \(placemark.name ?? "")"
                let model = PhotoEditInfoCellType.location(viewModel: PhotoEditInfoLocationViewModel(titleHeader: "場所検索", title: self?.locationTitle ?? "", subTitle: self?.locationSubTitle ?? ""))
                let modelDirect = PhotoEditInfoCellType.location(viewModel: PhotoEditInfoLocationViewModel(titleHeader: "場所手動入力", title: self?.locationTitle ?? "", subTitle: self?.locationSubTitle ?? ""))
                self?.viewModels[2] = model
                self?.viewModels[3] = modelDirect
                
                self?.location = Location(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
                
                self?.collectionView?.reloadData()
                
            }
            else{
                return
            }
        })
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation

        //表示更新
        if let location = locations.first {
            userCurrentLocation = location
            getLocationString(location: location)
            
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}
