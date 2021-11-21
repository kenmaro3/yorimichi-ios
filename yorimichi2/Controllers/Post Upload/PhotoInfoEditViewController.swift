//
//  PhotoInfoEditViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/26.
//

//import UIKit
//
//class PhotoInfoEditViewController: UIViewController {
//
//    private let image: UIImage
//
//    private var caption = ""
//    private var name = ""
//    private var genre: GenreInfo = GenreInfo(code: "G000")
//    private var location: Location = Location(lat: 0.0, lng: 0.0)
//    private var additionalLocation = ""
//    private var info = ""
//    private var rating = ""
//
//    private let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.clipsToBounds = true
//        imageView.contentMode = .scaleAspectFill
//        imageView.tintColor = .label
//        return imageView
//    }()
//
//    private var viewModels = [SingleYorimichiPostEditCellType]()
//
//    private var collectionView: UICollectionView?
//
//    private let colors: [UIColor] = [
//        .red,
//        .green,
//        .blue,
//        .yellow,
//        .systemPink,
//        .orange
//    ]
//
//
//    // MARK: - Init
//    init(image: UIImage){
//        self.image = image
//
//        super.init(nibName: nil, bundle: nil)
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .secondarySystemBackground
//        imageView.image = image
//        view.addSubview(imageView)
//        title = "Add Info to Shop"
//
//        viewModels.append(.post)
//        viewModels.append(.captionHeader)
//        viewModels.append(.caption)
//        viewModels.append(.nameHeader)
//        viewModels.append(.name)
//        viewModels.append(.genreHeader)
//        viewModels.append(.genre)
//        viewModels.append(.locationHeader)
//        viewModels.append(.location)
//        viewModels.append(.additionalLocationHeader)
//        viewModels.append(.additionalLocation)
//        viewModels.append(.infoHeader)
//        viewModels.append(.info)
//        viewModels.append(.ratingHeader)
//        viewModels.append(.rating)
//
//        print("\n----------")
//        print(viewModels)
//
//        configureCollectionView()
//
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
//
//        guard let lat = UserDefaults.standard.string(forKey: "currentLocationlat"),
//              let lng = UserDefaults.standard.string(forKey: "currentLocationlng") else {
//                  return
//              }
//        let lat2 = NumberFormatter().number(from: lat) ?? 0.0
//        let lng2 = NumberFormatter().number(from: lng) ?? 0.0
//
//        self.location = Location(lat: CGFloat(truncating: lat2), lng: CGFloat(truncating: lng2))
//
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
//    private func presentError(title: String, message: String){
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        present(alert, animated: true)
//    }
//
//    private func validation(){
//
//    }
//
//    @objc private func didTapPost(){
//        print("post tapped")
//
//        guard let username = UserDefaults.standard.string(forKey: "username") else {
//            return
//        }
//
//        // Generate ID
//        guard let newPostId = createNewPostID(),
//              let dateString = String.date(from: Date()) else{
//                  return
//              }
//
//        // MARK: - HardCode
//
//        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
//            presentError(title: "Invalid Name", message: "Name should be entered.")
//            return
//        }
//        guard !rating.trimmingCharacters(in: .whitespaces).isEmpty else {
//            presentError(title: "Invalid Rating", message: "Rating should be entered.")
//            return
//        }
//
//        guard location.lat != 0.0,
//              location.lng != 0.0 else{
//                  presentError(title: "Invalid Location", message: "Location has latitide as 0 or longitude as 0.")
//                  return
//
//              }
//
//
//        let group = DispatchGroup()
//
//        // MARK: Upload for YorimichiData
//
//        group.enter()
//        StorageManager.shared.uploadYorimichiData(data: image.pngData(), id: newPostId, genre: genre.code, completion: { downloadUrl in
//            guard let url = downloadUrl else {
//                print("error: failed to upload post to storage")
//                return
//            }
//
//            let newPost: YorimichiPost = YorimichiPost(
//                id: newPostId,
//                postedDate: dateString,
//                genre: self.genre,
//                name: self.name,
//                location: self.location,
//                additionalLocation: self.additionalLocation,
//                info: self.info,
//                rating: self.rating,
//                postUrlString: url.absoluteString,
//                likers: []
//            )
//
//            DatabaseManager.shared.createYorimichiPost(
//                post: newPost, completion: {[weak self] finished in
//                    defer{
//                        group.leave()
//
//                    }
//                    guard finished else{
//                        return
//                    }
//
//                })
//
//        })
//
//        // MARK: Upload for User Post Data
//        group.enter()
//        StorageManager.shared.uploadPost(data: image.pngData(), id: newPostId, completion: { newPostDownloadURL in
//            guard let url = newPostDownloadURL else {
//                print("error: failed to upload post to storage")
//                return
//            }
//
//
//            // Find user
//
//            DatabaseManager.shared.findUser(username: username, completion: { user in
//                guard let user = user else {
//                    print("cannot find user, something went wrong")
//                    return
//                }
//                     // Update database
//                let newPost: Post = Post(id: newPostId, caption: self.caption, postedDate: dateString, likers: [], postUrlString: url.absoluteString, genre: self.genre.code, user: user)
//
//            DatabaseManager.shared.createPost(post: newPost, completion: { [weak self] finished in
//                defer{
//                    group.leave()
//                }
//                guard finished else{
//                    return
//                }
//
//            })
//
//            })
//
//        })
//
//
//        group.notify(queue: .main){
//            DispatchQueue.main.async{
//                self.tabBarController?.tabBar.isHidden = false
//                self.tabBarController?.selectedIndex = 0
//                self.navigationController?.popToRootViewController(animated: false)
//
//                NotificationCenter.default.post(name: .didPostNotification, object: nil)
//            }
//        }
//
////        StorageManager.shared.uploadYorimichiData(data: image.pngData(), id: newPostId, completion: { newPostDownloadURL in
////            guard let url = newPostDownloadURL else {
////                print("error: failed to upload post to storage")
////                return
////            }
//
////            // Update database
////            let newPost: Post = Post(id: newPostId, caption: caption, postedDate: dateString, likers: [], postUrlString: url.absoluteString)
////
////            DatabaseManager.shared.createPost(post: newPost, completion: { [weak self] finished in
////                guard finished else{
////                    return
////                }
////
////                DispatchQueue.main.async{
////                    self?.tabBarController?.tabBar.isHidden = false
////                    self?.tabBarController?.selectedIndex = 0
////                    self?.navigationController?.popToRootViewController(animated: false)
////
////                    NotificationCenter.default.post(name: .didPostNotification, object: nil)
////                }
////            })
////        })
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        //imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
//        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height)
//    }
//
//}
//
//extension PhotoInfoEditViewController: UICollectionViewDelegate, UICollectionViewDataSource{
//    // CollectionView
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModels.count
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
//                withReuseIdentifier: PostEditHeaderCollectionViewCell.identifier,
//                for: indexPath
//              ) as? PostEditHeaderCollectionViewCell else {
//                  return UICollectionReusableView()
//              }
//
//        let title = "ヨリミチの詳細を教えてください！"
//        headerView.configure(with: title)
//
//        return headerView
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cellType = viewModels[indexPath.row]
//        print(indexPath)
//        switch cellType{
//        case .post:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as? PostCollectionViewCell else{
//                fatalError()
//            }
//            //cell.configure(with: viewModel, index: indexPath.section)
//            cell.imageView.image = image
//            return cell
//
//
//        case .caption:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostEditCaptionCollectionViewCell.identifier, for: indexPath) as? PostEditCaptionCollectionViewCell else{
//                fatalError()
//            }
//
//            cell.delegate = self
//
//            return cell
//
//        case .name:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostEditNameCollectionViewCell.identifier, for: indexPath) as? PostEditNameCollectionViewCell else{
//                fatalError()
//            }
//
//            cell.delegate = self
//
////            cell.configure(with: name)
//            return cell
//
//        case .genre:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostEditGenreCollectionViewCell.identifier, for: indexPath) as? PostEditGenreCollectionViewCell else{
//                fatalError()
//            }
//
//            cell.delegate = self
//
//            return cell
//
//        case .location:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostEditLocationCollectionViewCell.identifier, for: indexPath) as? PostEditLocationCollectionViewCell else{
//                fatalError()
//            }
//            print("locationCell indexPath")
//            print(indexPath)
//
//            cell.delegate = self
//
//
////            cell.configure(with: location)
//            return cell
//
//
//
//        case .additionalLocation:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostEditAdditionalLocationCollectionViewCell.identifier, for: indexPath) as? PostEditAdditionalLocationCollectionViewCell else{
//                fatalError()
//            }
//            cell.delegate = self
//
//            return cell
//
//
//        case .info:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostEditInfoCollectionViewCell.identifier, for: indexPath) as? PostEditInfoCollectionViewCell else{
//                fatalError()
//            }
//
//            cell.delegate = self
//
//            return cell
//
//
//        case .rating:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostEditRatingCollectionViewCell.identifier, for: indexPath) as? PostEditRatingCollectionViewCell else{
//                fatalError()
//            }
//
//            cell.delegate = self
//
//            return cell
//
//        case .captionHeader:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostEditHeaderCollectionViewCell.identifier, for: indexPath) as? PostEditHeaderCollectionViewCell else{
//                fatalError()
//            }
//            let title = "写真のキャプションを入力"
//            cell.configure(with: title)
//
//            return cell
//
//        case .nameHeader:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostEditHeaderCollectionViewCell.identifier, for: indexPath) as? PostEditHeaderCollectionViewCell else{
//                fatalError()
//            }
//            let title = "ヨリミチ先の名前を検索"
//            cell.delegate = self
//            cell.configure(with: title)
//
//            return cell
//
//
//        case .genreHeader:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostEditHeaderCollectionViewCell.identifier, for: indexPath) as? PostEditHeaderCollectionViewCell else{
//                fatalError()
//            }
//            let title = "ヨリミチ先のジャンルを入力"
//            cell.configure(with: title)
//
//            return cell
//
//        case .locationHeader:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostEditHeaderCollectionViewCell.identifier, for: indexPath) as? PostEditHeaderCollectionViewCell else{
//                fatalError()
//            }
//            let title = "ヨリミチ先の場所（座標）を入力"
//            cell.configure(with: title)
//
//            return cell
//
//        case .additionalLocationHeader:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostEditHeaderCollectionViewCell.identifier, for: indexPath) as? PostEditHeaderCollectionViewCell else{
//                fatalError()
//            }
//            let title = "ヨリミチ先の場所詳細を入力（例： ビル２階など）"
//            cell.configure(with: title)
//
//            return cell
//
//        case .infoHeader:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostEditHeaderCollectionViewCell.identifier, for: indexPath) as? PostEditHeaderCollectionViewCell else{
//                fatalError()
//            }
//            let title = "ヨリミチ先のおすすめポイントを入力"
//            cell.configure(with: title)
//
//            return cell
//
//        case .ratingHeader:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostEditHeaderCollectionViewCell.identifier, for: indexPath) as? PostEditHeaderCollectionViewCell else{
//                fatalError()
//            }
//            let title = "ヨリミチ先の評価（５段階）"
//            cell.configure(with: title)
//
//            return cell
//
//        }
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
////        cell.contentView.backgroundColor = colors[indexPath.row]
////        return cell
//
//    }
//}
//
//extension PhotoInfoEditViewController: PostEditRatingCollectionViewCellDelegate{
//    func postEditRatingCollectionViewCellEndEditing(_ cell: PostEditRatingCollectionViewCell) {
//        guard let tmp = cell.field.text,
//              !tmp.trimmingCharacters(in: .whitespaces).isEmpty else{
//                  presentError(title: "Invalid Rating", message: "rating should be entered.")
//                  return
//              }
//        rating = tmp
//        print("here rating")
//        print(rating)
//    }
//}
//
//extension PhotoInfoEditViewController: PostEditInfoCollectionViewCellDelegate{
//    func postEditInfoCollectionViewCellEndEditing(_ cell: PostEditInfoCollectionViewCell) {
//        guard let tmp = cell.field.text,
//              !tmp.trimmingCharacters(in: .whitespaces).isEmpty else{
//                  presentError(title: "Invalid Info", message: "info should be entered.")
//                  return
//              }
//        info = tmp
//        print("here info")
//        print(info)
//    }
//}
//
//extension PhotoInfoEditViewController: PostEditHeaderCollectionViewCellDelegate{
//    func postEditHeaderCollectionViewCellDidTap() {
//        let vc = SearchViewController()
//        vc.delegate = self
//        present(UINavigationController(rootViewController: vc), animated: true)
//    }
//
//}
//
//extension PhotoInfoEditViewController: PostEditCaptionCollectionViewCellDelegate{
//    func postEditCaptionCollectionViewCellEndEditing(_ cell: PostEditCaptionCollectionViewCell){
//        guard let tmp = cell.field.text,
//              !tmp.trimmingCharacters(in: .whitespaces).isEmpty else{
//                  presentError(title: "Invalid Caption", message: "Caption should be entered.")
//                  return
//              }
//        caption = tmp
//        print("here caption")
//        print(caption)
//    }
//}
//
//extension PhotoInfoEditViewController: PostEditNameCollectionViewCellDelegate{
//    func postEditNameCollectionViewCellEndEditing(_ cell: PostEditNameCollectionViewCell) {
//        guard let tmp = cell.field.text,
//              !tmp.trimmingCharacters(in: .whitespaces).isEmpty else{
//                  presentError(title: "Invalid Name", message: "Name should be entered.")
//                  return
//              }
//        name = tmp
//        print("here name")
//        print(name)
//    }
//}
//
//
//extension PhotoInfoEditViewController: PostEditGenreCollectionViewCellDelegate{
//    func postEditGenreCollectionViewCellEndEditing(_ cell: PostEditGenreCollectionViewCell) {
//        guard let tmp = cell.field.text,
//              !tmp.trimmingCharacters(in: .whitespaces).isEmpty else{
//                  presentError(title: "Invalid Genre", message: "Genre should be entered.")
//                  return
//              }
//        genre = GenreInfo(code: genreDisplayStringToCode(x: tmp))
//        print("here genre")
//        print(genre)
//    }
//}
//
//
//extension PhotoInfoEditViewController: PostEditLocationCollectionViewCellDelegate{
//    func postEditLocationCollectionViewCellEndEditing(_ cell: PostEditLocationCollectionViewCell) {
//        guard let tmp = cell.field.text,
//              !tmp.trimmingCharacters(in: .whitespaces).isEmpty else{
//                  presentError(title: "Invalid Location", message: "Location should be entered.")
//                  return
//              }
//        let arr:[String] = tmp.components(separatedBy: ",")
//
//
//        if (arr.count != 2){
//            presentError(title: "Invalid Location", message: "Location should be string as latitude,longitude")
//        }
//
//        let lat2 = NumberFormatter().number(from: arr[0]) ?? 0.0
//        let lng2 = NumberFormatter().number(from: arr[1]) ?? 0.0
//
//
//        location = Location(lat: CGFloat(lat2), lng: CGFloat(lng2))
//        print("here location")
//        print(location)
//    }
//}
//
//
//extension PhotoInfoEditViewController: PostEditAdditionalLocationCollectionViewCellDelegate{
//    func postEditAdditionalLocationCollectionViewCellEndEditing(_ cell: PostEditAdditionalLocationCollectionViewCell) {
//        guard let tmp = cell.field.text,
//              !tmp.trimmingCharacters(in: .whitespaces).isEmpty else{
//                  presentError(title: "Invalid Additional Location", message: "Additional Location should be entered.")
//                  return
//              }
//        additionalLocation = tmp
//        print("here ad location")
//        print(additionalLocation)
//    }
//}
//
//extension PhotoInfoEditViewController: SearchViewControllerDelegate{
//    func searchViewControllerDidTapLeave() {
//        // MARK: - HardCode
//        let nameCell = collectionView?.cellForItem(at: [0, 4]) as? PostEditNameCollectionViewCell
////        print("nameCell indexPath")
////        print(indexPath)
//
//        guard let name = UserDefaults.standard.string(forKey: "yorimichiPostName") else {
//            return
//        }
//
//        nameCell?.field.text = name
//
//
//        let locationCell = collectionView?.cellForItem(at: [0, 8]) as? PostEditLocationCollectionViewCell
//
//        guard let searchedLat = UserDefaults.standard.string(forKey: "yorimichiPostCoordinateLat"),
//              let searchedLng = UserDefaults.standard.string(forKey: "yorimichiPostCoordinateLng") else {
//                  return
//              }
//
//        locationCell?.field.text = "\(searchedLat), \(searchedLng)"
//
//    }
//
//
//}
//
//
//extension PhotoInfoEditViewController{
//    private func configureCollectionView(){
//        let sectionHeight: CGFloat = 2000 + view.width
//
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:
//                                                UICollectionViewCompositionalLayout(sectionProvider: {index, _ ->
//            NSCollectionLayoutSection? in
//
//            // Item
//
//            let postItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .fractionalWidth(1)
//                )
//            )
//
//            let captionHeaderItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(50)
//                )
//            )
//
//            let captionItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(50)
//                )
//            )
//
//            let nameHeaderItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(50)
//                )
//            )
//
//            let nameItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(50)
//                )
//            )
//
//
//            let genreHeaderItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(50)
//                )
//            )
//
//            let genreItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(50)
//                )
//            )
//
//            let locationHeaderItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(50)
//                )
//            )
//
//            let locationItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(50)
//                )
//            )
//
//            let additionalLocationHeaderItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(50)
//                )
//            )
//
//            let additionalLocationItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(50)
//                )
//            )
//
//            let infoHeaderItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(50)
//                )
//            )
//
//
//            let infoItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(50)
//                )
//            )
//
//            let ratingHeaderItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(50)
//                )
//            )
//
//            let ratingItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(50)
//                )
//            )
//
//            let imageItems = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)), subitems: [postItem])
//
//            let captionItems = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120)), subitems: [captionHeaderItem, captionItem])
//
//            let nameItems = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120)), subitems: [nameHeaderItem, nameItem])
//
//            let genreItems = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120)), subitems: [genreHeaderItem, genreItem])
//
//            let locationItems = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120)), subitems: [locationHeaderItem, locationItem])
//
//            let additionalLocationItems = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120)), subitems: [additionalLocationHeaderItem, additionalLocationItem])
//
//            let infoItems = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120)), subitems: [infoHeaderItem, infoItem])
//
//            let ratingItems = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120)), subitems: [ratingHeaderItem, ratingItem])
//
////            let infoItems = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(360)), subitems: [nameItem, genreItem, locationItem, additionalLocationItem, infoItem, ratingItem])
//
//            captionItems.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0)
//            infoItems.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0)
////            infoItems.interItemSpacing = .fixed(4)
//
//
//            let groups = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(sectionHeight)), subitems: [
//                    imageItems, captionItems, nameItems, genreItems, locationItems, additionalLocationItems, infoItems, ratingItems
//                ]
//            )
//
////
////            let group = NSCollectionLayoutGroup.vertical(
////                layoutSize: NSCollectionLayoutSize(
////                    widthDimension: .fractionalWidth(1),
////                    heightDimension: .absolute(sectionHeight)
////                ),
////                subitems: subItems
////            )
//
//
//            // Section
//            let section = NSCollectionLayoutSection(group: groups)
//
//            // MARK: - Stories commented
//            if index == 0 {
//                section.boundarySupplementaryItems = [
//                    NSCollectionLayoutBoundarySupplementaryItem(
//                        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.3)),
//                        elementKind: UICollectionView.elementKindSectionHeader,
//                        alignment: .top
//                    )
//
//                ]
//            }
//
//
//
//            section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0)
//            section.interGroupSpacing = 2
//
//
//            return section
//        })
//
//        )
//
//        view.addSubview(collectionView)
//        collectionView.backgroundColor = .systemBackground
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//
//        collectionView.register(PostEditHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PostEditHeaderCollectionViewCell.identifier)
//
//        collectionView.register(
//            PostCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostCollectionViewCell.identifier
//        )
//
//        collectionView.register(
//            PostEditCaptionCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostEditCaptionCollectionViewCell.identifier
//        )
//
//        collectionView.register(
//            PostEditNameCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostEditNameCollectionViewCell.identifier
//        )
//
//        collectionView.register(
//            PostEditGenreCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostEditGenreCollectionViewCell.identifier
//        )
//
//        collectionView.register(
//            PostEditLocationCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostEditLocationCollectionViewCell.identifier
//        )
//
//        collectionView.register(
//            PostEditAdditionalLocationCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostEditAdditionalLocationCollectionViewCell.identifier
//        )
//
//        collectionView.register(
//            PostEditInfoCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostEditInfoCollectionViewCell.identifier
//        )
//
//        collectionView.register(
//            PostEditRatingCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostEditRatingCollectionViewCell.identifier
//        )
//        
//        collectionView.register(
//            PostEditHeaderCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostEditHeaderCollectionViewCell.identifier
//        )
//
//
//
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 500, right: 0)
//
//        self.collectionView = collectionView
//    }
//
//}
