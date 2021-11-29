//
//  VideoPostViewController.swift
//  tiktok
//
//  Created by Kentaro Mihara on 2021/11/03.
//

import AVFoundation
import UIKit
import ProgressHUD
import FloatingPanel
import SafariServices

protocol VideoPostViewControllerDelegate: AnyObject{
    func videoPostViewController(_ vc: VideoPostViewController, didTapCommentButtonFor post: Post)
    func videoPostViewController(_ vc: VideoPostViewController, didTapProfileButtonFor post: Post)
    func videoPostViewControllerDidTapComment(_ vc: VideoPostViewController, didTapCommentButtonFor post: Post)
//    func videoPostViewControllerDidTapCloseForComments(with viewController: CommentsViewController)
    
    func videoPostViewControllerDidTapCommentClose()
}

class VideoPostViewController: UIViewController, FloatingPanelControllerDelegate {
    weak var delegate: VideoPostViewControllerDelegate?
    
    private var isLiked: Bool = false
    private var isYorimichi: Bool = false
    public var model: Post
    
    private var fpc: FloatingPanelController!
    
    private let profileView: PostHeaderView
    
    

    private let yorimichiButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.clipsToBounds = true
        let image = UIImage(named: "logo")
        button.setImage(image, for: .normal)
        return button
    }()

    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "text.bubble.fill"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
//    private let profileButton: UIButton = {
//        let button = UIButton()
//        button.setBackgroundImage(UIImage(named: "test"), for: .normal)
//        button.tintColor = .white
//        button.imageView?.contentMode = .scaleAspectFill
//        button.layer.masksToBounds = true
//        return button
//    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = ""
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        
        return label
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = ""
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let location2Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    
    var player: AVPlayer?
    private var playerDidFinishObserver: NSObjectProtocol?
    
    private let videoView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.clipsToBounds = true
        return view
        
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
    }()
    
    
    
    // MARK: - Init
    
    init(model: Post){
        self.model = model
        self.profileView = PostHeaderView()
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVideo()
        configureText()
        view.addSubview(videoView)
        view.addSubview(profileView)
        view.addSubview(timestampLabel)
        view.addSubview(locationLabel)
        view.addSubview(location2Label)
        profileView.backgroundColor = .systemBackground
        
        view.backgroundColor = .black
        setUpButtons()
//        setUpDoubleTapToLike()
        fetchUser()
        view.addSubview(captionLabel)
        
        setUpLikeButton()
        setUpYorimichiButton()
        setUpFPC()
        
        

    }
    

    
    private func fetchUser(){
        StorageManager.shared.profilePictureURL(for: model.user.username){[weak self] profilePictureURL in
            guard let strongSelf = self,
//                  let postUrl = URL(string: model.postUrlString),
                  let profilePictureUrl = profilePictureURL else {
//                      completion(false)
                      return
                  }
            let postHeaderViewModel: PostHeaderViewModel = PostHeaderViewModel(username: strongSelf.model.user.username, profilePictureURL: profilePictureUrl)
            strongSelf.profileView.delegate = self
            strongSelf.profileView.configure(with: postHeaderViewModel)
        }
    }
    
    @objc func didTapMoreButton(){
        print("more tapped")
    }
    
    @objc func didTapUsername(){
        print("username tapped")
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: 60)
        videoView.frame = CGRect(x: 0, y: profileView.bottom, width: view.width, height: view.height-profileView.bottom)


//        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        spinner.center = videoView.center
        
        let size: CGFloat = 40
        let tabBarHeight: CGFloat = 0
        let timestampHeight:  CGFloat = 50
        let locationHeight:  CGFloat = 50
        
        let yStart: CGFloat = view.height - (size * 5) - 30 - view.safeAreaInsets.bottom - tabBarHeight
        for(index, button) in [yorimichiButton, likeButton, commentButton, shareButton].enumerated(){
            button.frame = CGRect(x: view.width-size-10, y: yStart + CGFloat(index) * size + CGFloat(index) * 10, width: size, height: size)
        }
        
        yorimichiButton.layer.cornerRadius = size/2
        
        captionLabel.sizeToFit()
        let labelSize = captionLabel.sizeThatFits(CGSize(width:  view.width-size-12, height: view.height))
        captionLabel.frame = CGRect(
            x: 5,
            y: view.height-10-view.safeAreaInsets.bottom-labelSize.height - timestampHeight - 10 - locationHeight*2 - 10*2,
            width: view.width-size-12,
            height: labelSize.height)
        
        locationLabel.frame = CGRect(x: 5, y: captionLabel.bottom + 10, width: view.width-size-12, height: locationHeight)
        location2Label.frame = CGRect(x: 5, y: locationLabel.bottom + 10, width: view.width-size-12, height: locationHeight)
        timestampLabel.frame = CGRect(x: 5, y: location2Label.bottom + 10, width: view.width-size-12, height: timestampHeight)
        

    }
    
    

    
    private func configureText(){
        captionLabel.text = model.caption
        locationLabel.text = model.locationTitle
        location2Label.text = model.locationSubTitle
        timestampLabel.text = model.postedDate

        
    }

    private func configureVideo(){
//        guard let path = Bundle.main.path(forResource: "video", ofType: "mp4") else {
//            print("falling here======")
//            return
//        }
        ProgressHUD.show("ロード中...")
        
        StorageManager.shared.getDownLoadUrl(for: model, completion: {[weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                switch result{
                case .success(let url):
//                    strongSelf.spinner.stopAnimating()
//                    strongSelf.spinner.removeFromSuperview()
                    strongSelf.player = AVPlayer(url: url)
                    
                    let playerLayer = AVPlayerLayer(player: strongSelf.player)
//                    let frame = strongSelf.view.frame
//                    playerLayer.frame = strongSelf.view.bounds
                    
                    if let tmp = strongSelf.navigationController?.navigationBar.frame.height{
                        print(tmp)
                        playerLayer.frame = CGRect(x: 0, y: 0, width: strongSelf.view.width, height: strongSelf.videoView.height-tmp)
                    } else {
                        playerLayer.frame = CGRect(x: 0, y: 0, width: strongSelf.view.width, height: strongSelf.videoView.height)
                    }

//                    playerLayer.masksToBounds = true

                    
                    playerLayer.videoGravity = .resizeAspectFill
                    strongSelf.videoView.layer.addSublayer(playerLayer)
                    strongSelf.player?.volume = 0
                    
                    ProgressHUD.dismiss()
                    self?.player?.play()
                     
                    guard let player = strongSelf.player else {
                        return
                    }
                    
                    strongSelf.playerDidFinishObserver = NotificationCenter.default.addObserver(
                        forName: .AVPlayerItemDidPlayToEndTime,
                        object: player.currentItem,
                        queue: .main,
                        using: { _ in
                            player.seek(to: .zero)
                            player.play()
                            
                        })
                    
                case .failure:
                    ProgressHUD.showFailed("ビデオのロードに失敗しました。")
//                    let url = URL(fileURLWithPath: path)
//                    strongSelf.player = AVPlayer(url: url)
//
//                    let playerLayer = AVPlayerLayer(player: strongSelf.player)
//                    playerLayer.frame = strongSelf.view.bounds
//                    playerLayer.videoGravity = .resizeAspectFill
//                    strongSelf.view.layer.addSublayer(playerLayer)
//                    strongSelf.player?.volume = 0
//
//                    strongSelf.player?.play()
                    break
                    
                }
                
            }
            
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ProgressHUD.dismiss()
    }
    
    @objc private func didTapProfileButton(){
        let user = model.user
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    private func setUpFPC(){
        // Initialize a `FloatingPanelController` object.
        fpc = FloatingPanelController()
        fpc.layout = CommentFloatingPanelLayout()
        // appearance
        // Create a new appearance.
        let appearance = SurfaceAppearance()

        // Define shadows
        let shadow = SurfaceAppearance.Shadow()
        shadow.color = UIColor.black
        shadow.offset = CGSize(width: 0, height: 16)
        shadow.radius = 24
        shadow.spread = 12
        appearance.shadows = [shadow]
        
        // Define corner radius and background color
        appearance.cornerRadius = 12.0
        appearance.backgroundColor = .clear

        // Set the new appearance
        fpc.surfaceView.appearance = appearance
        
        // Assign self as the delegate of the controller.
        fpc.delegate = self // Optional
        fpc.view.frame = CGRect(x: 6, y: 0, width: view.width-12, height: view.height/2)
    }
    
    
    private func setUpButtons(){
        view.addSubview(likeButton)
        view.addSubview(commentButton)
        view.addSubview(shareButton)
        view.addSubview(yorimichiButton)
        
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        yorimichiButton.addTarget(self, action: #selector(didTapYorimichi), for: .touchUpInside)
        
        
    }
    
    
    @objc private func didTapYorimichi(){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        
        for targetUser in model.likers {
            group.enter()
            DatabaseManager.shared.removeYorimichiLikes(with: model, for: targetUser, completion: { res in
                defer{
                    group.leave()
                }
                
            })
        }
        
        for targetUser in model.yorimichi {
            group.enter()
            DatabaseManager.shared.removeYorimichiCandidate(with: model, for: targetUser, completion: { res in
                defer{
                    group.leave()
                }
                
            })
        }
        
        DatabaseManager.shared.checkIfCandidateRegistered(with: model, completion: {[weak self] res in
            defer{
                group.leave()
            }
            if(!res){

            }
            else{
                guard let model = self?.model else {
                    return
                }
                DatabaseManager.shared.removeYorimichiCandidate(with: model, for: username, completion: { res in
                    print(res)
                    ProgressHUD.showSuccess("ヨリミチ候補から削除されました。")
                    NotificationCenter.default.post(name: .didAddCandidateNotification, object: nil)
                    
                })
            }
            
        })
        
        DatabaseManager.shared.addYorimichiCandidate(with: model, for: username, completion: { res in
            defer{
                group.leave()
            }
            print(res)
            ProgressHUD.showAdded("ヨリミチ候補に追加されました。")
            NotificationCenter.default.post(name: .didAddCandidateNotification, object: nil)
            
        })
        
        DatabaseManager.shared.updateYorimichiVideo(
            state: isYorimichi ? .no: .yes,
            postID: model.id,
            owner: model.user.username,
            completion: {[weak self] success in
                defer{
                    group.leave()
                }
                guard success else{
                    print("failed to yorimichi on")
                    return
                }
                
                guard let isYorimichi = self?.isYorimichi else {
                    return
                }
                if isYorimichi{
                    let image = UIImage(named: "logo")
                    self?.yorimichiButton.setImage(image, for: .normal)
                    self?.yorimichiButton.tintColor = .white
                    
                    
                }else{
                    let image = UIImage(systemName: "checkmark.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50))
                    self?.yorimichiButton.setImage(image, for: .normal)
                    self?.yorimichiButton.tintColor = .white
                }
                self?.isYorimichi = !isYorimichi
            })
        
        
    }
    
    private func setUpLikeButton(){
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        isLiked = model.likers.contains(currentUsername)
        if !isLiked{
            let image = UIImage(systemName: "suit.heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .white
        }else{
            let image = UIImage(systemName: "suit.heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .systemRed
        }
    }
    
    private func setUpYorimichiButton(){
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        print("setUpYorimichiButton called")
        isYorimichi = model.yorimichi.contains(currentUsername)
        print(isYorimichi)
        if !isYorimichi{
            let image = UIImage(named: "logo")
            yorimichiButton.setImage(image, for: .normal)
            yorimichiButton.tintColor = .white
            
            
        }else{
            let image = UIImage(systemName: "checkmark.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50))
            yorimichiButton.setImage(image, for: .normal)
            yorimichiButton.tintColor = .white
        }
        
        
    }
    
    @objc private func didTapLike(){
//        model.isLikedByCurrentUser = !model.isLikedByCurrentUser
//
//        likeButton.tintColor = model.isLikedByCurrentUser ? .systemRed : .white
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        
        DatabaseManager.shared.updateLikeVideo(
            state: isLiked ? .unlike: .like,
            postID: model.id,
            owner: model.user.username,
            completion: {[weak self] success in
                defer{
                    group.leave()
                }
                guard success else{
                    print("failed to like")
                    return
                }
                
            })
        
        if (isLiked){
            DatabaseManager.shared.removeYorimichiLikes(with: model, for: username, completion: { success in
                defer{
                    group.leave()
                }
            })
        }
        else{
            
            DatabaseManager.shared.addYorimichiLikes(with: model, for: username, completion: { success in
                defer{
                    group.leave()
                }
            })
        }
        
        group.notify(queue: .main){
            if self.isLiked{
                let image = UIImage(systemName: "suit.heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
                self.likeButton.setImage(image, for: .normal)
                self.likeButton.tintColor = .white
            }else{
                let image = UIImage(systemName: "suit.heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
                self.likeButton.setImage(image, for: .normal)
                self.likeButton.tintColor = .systemRed
            }
            self.isLiked = !self.isLiked
        }
    }
    
    
    @objc private func didTapComment(){
        print("did tap comment")
        
        let vc = CommentsViewController(viewModel: CommentsViewModel(type: .video(viewModel: model)))
        vc.delegate = self
        delegate?.videoPostViewControllerDidTapComment(self, didTapCommentButtonFor: model)
        fpc.set(contentViewController: vc)
        fpc.addPanel(toParent: self, animated: true)
        
    }
    @objc private func didTapShare(){
        AlertManager.shared.presentError(title: "共有機能", message: "実装予定です。アップデートをお待ちください。", completion: {[weak self] alert in
            self?.present(alert, animated: true)
        })
        
//        guard let url = URL(string: "https://tiktok.com") else {return}
//        let vc =  UIActivityViewController(activityItems: [url], applicationActivities: [])
//        present(vc, animated: true)

    }
    
//    private func setUpDoubleTapToLike(){
//        let tap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
//        tap.numberOfTapsRequired = 2
//
//        view.addGestureRecognizer(tap)
//        view.isUserInteractionEnabled = true
//
//
//    }
    
    @objc private func didDoubleTap(_ gesture: UITapGestureRecognizer){
//        if !model.isLikedByCurrentUser{
//            model.isLikedByCurrentUser = true
//        }
        
        let touchPoint = gesture.location(in: view)
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = .systemRed
       
        
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        imageView.center = touchPoint
        
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        view.addSubview(imageView)
        
        UIView.animate(withDuration: 0.2){
            imageView.alpha = 1
        } completion:  { done in
            if done{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                    
                    UIView.animate(withDuration: 0.3){
                        imageView.alpha = 0
                        
                    } completion: { done in
                        if done{
                            imageView.removeFromSuperview()
                        }
                        
                }
                    
                }
            }
            
        }
        
    }
    
    


}


extension VideoPostViewController: CommentsViewControllerDeleagate{
    func commentsViewControllerDidTapComment(with viewController: CommentsViewController, withText text: String) {
        print("delegate at videoPostViewcontroller")
        guard let currentUserName = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        DatabaseManager.shared.isTargetUserBlocked(for: model.user.username, with: currentUserName, completion: { isBlocked in
            if(isBlocked){
                ProgressHUD.showFailed("コメントを投稿できませんでした。")
                return
            }
            else{
                
                // Find User
                DatabaseManager.shared.findUser(username: currentUserName, completion: {[weak self] user in
                    guard let user = user else {
                        print("cannot find user aborte")
                        ProgressHUD.showFailed("コメントを投稿できませんでした。")
                        return
                    }
                    
                    guard let strongSelf = self else {
                        ProgressHUD.showFailed("コメントを投稿できませんでした。")
                        return
                    }
                    
                    DatabaseManager.shared.createCommentsVideo(postID: strongSelf.model.id,
                                                               owner: strongSelf.model.user.username,
                                                               comment: PostComment(text: text,
                                                                                    user: user,
                                                                                    date: Date()
                                                                                   ),
                                                               completion: { success in
                        DispatchQueue.main.async {
                            guard success else{
                                print("failed to add comment")
                                ProgressHUD.showFailed("コメントを投稿できませんでした。")
                                return
                            }
                            ProgressHUD.showSuccess("コメントを投稿しました。")
                        }
                        
                    })
                    
                    
                })
            }
            
        })
        
    }
    
    func commentsViewControllerDidTapCloseForComments(with viewController: CommentsViewController) {
        // close comments with animation
        print("delegate calle")
        
        
        delegate?.videoPostViewControllerDidTapCommentClose()
        fpc.removePanelFromParent(animated: true, completion: nil)

        
    }
    
    private func isCurrentUserOwnsThisPost() -> Bool{
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return false
        }
        
        if username == model.user.username{
            return true
        }
        else{
            return false
        }
        
        
    }
    
}


extension VideoPostViewController: PostHeaderViewDelegate{
    func postHeaderViewDidTapUsername(_ view: PostHeaderView) {
        let vc = ProfileViewController(user: model.user)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func postHeaderViewDidTapMore(_ view: PostHeaderView) {
        let sheet = UIAlertController(title: "投稿アクション", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "投稿の共有", style: .default, handler: {[weak self] _ in
            DispatchQueue.main.async {
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
            }
            
        }))
        
        if isCurrentUserOwnsThisPost(){
            sheet.addAction(UIAlertAction(title: "投稿の削除", style: .default, handler: {[weak self] _ in
                print("delete called")
                let group = DispatchGroup()
                group.enter()
                group.enter()
                
                ProgressHUD.show("ポストを削除しています...")
                guard let post = self?.model else{
                    return
                }
                DatabaseManager.shared.deleteVideoPost(post: post, completion: { res in
                    defer{
                        group.leave()
                    }
                    if !res{
                        print("error")
                        ProgressHUD.showError("削除に失敗しました。")
                    }
                    else{
                        DatabaseManager.shared.deleteYorimichiVideoPost(post: post, completion: { res in
                            if !res{
                                print("error")
                                ProgressHUD.showError("削除に失敗しました。")
                            }
                            else{
                                DatabaseManager.shared.deleteYorimichiVideoPostAtAll(post: post, completion: { res in
                                    if !res{
                                        print("error")
                                        ProgressHUD.showError("削除に失敗しました。")
                                    }
                                    else{
                                    }
                                    
                                    
                                })
                            }
                            
                            
                        })
                    }
                    
                })
                
                StorageManager.shared.deleteVideoPost(post: post, completion: { res in
                    defer{
                        group.leave()
                    }
                    if !res {
                        ProgressHUD.showError("削除に失敗しました。")
                    }
                    else{
                        
                    }
                    
                })
                
                
                group.notify(queue: .main){
                    ProgressHUD.showSuccess("削除しました。")
                    NotificationCenter.default.post(name: .didPostNotification, object: nil)
                }
                
            }))
        }
        
        sheet.addAction(UIAlertAction(title: "投稿を通報する", style: .destructive, handler: {[weak self] _ in
            guard let url = URL(string: "https://yorimichi-privacy-policy.webflow.io/") else {
                return
            }
            let vc = SFSafariViewController(url: url)
            DispatchQueue.main.async {
                self?.present(vc, animated: true)
            }

                
                
        }))
        present(sheet, animated: true)
    }
    
    
}

//extension VideoPostViewController: CommentBarViewDelegate{
//    func commentBarViewDidTapComment(_ commentBarView: CommentBarView, withText text: String) {
//        print("this delegate ")
//        guard let currentUserName = UserDefaults.standard.string(forKey: "username") else {
//            return
//        }
//
//
//
//        // Find user
//        DatabaseManager.shared.findUser(username: currentUserName, completion: {[weak self] user in
//            guard let user = user else {
//                print("cannot find user, abort")
//                return
//            }
//            guard let strongSelf = self else {
//                return
//            }
//            DatabaseManager.shared.createCommentsVideo(postID: strongSelf.model.id,
//                                                       owner: strongSelf.model.user.username,
//                                                       comment: PostComment(text: text,
//                                                                             user: user,
//                                                                             date: Date()
//                                                                            ),
//                                                       completion: { success in
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
