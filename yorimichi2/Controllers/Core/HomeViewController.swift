import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    // locationManager で現在地を取得する
    private var locationManager:CLLocationManager!
    public var currentLocation: CLLocation?
    /// ロケーションマネージャのセットアップ
    func setupLocationManager() {
        locationManager = CLLocationManager()
        // 位置情報取得許可ダイアログの表示
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        // マネージャの設定
        let status = CLLocationManager.authorizationStatus()
        // ステータスごとの処理
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            // 位置情報取得を開始
            locationManager.startUpdatingLocation()
        }
        
        // ステータスごとの処理
        if status == .authorizedWhenInUse {
            locationManager.delegate = self // これを追加
            // 位置情報取得を開始
            locationManager.startUpdatingLocation()
        }
    }
    
    private let emptyLabelForForYou: UILabel = {
        let label = UILabel()
        label.text =  "投稿がありません"
        label.textColor = .label
        label.isHidden = true
        return label
    }()
    
    private let emptyLabelForFollowings: UILabel = {
        let label = UILabel()
        label.text =  "投稿がありません"
        label.textColor = .label
        label.isHidden = true
        return label
    }()
    
    private let horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    let forYorPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical,
        options: [:])
    
    let followingPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical,
        options: [:])
    

    public let control: UISegmentedControl = {
        let titles = ["フォロー中", "あなたへのオススメ"]
        let control = UISegmentedControl(items: titles)
        control.selectedSegmentIndex = 1
        control.backgroundColor = .secondarySystemBackground
        control.selectedSegmentTintColor = .systemGray2
        return control
    }()

    private var forYouPosts = [(cellType: HomeScrollCellType, id: String)]()
    private var followingPosts = [(cellType: HomeScrollCellType, id: String)]()
    
    private var postObserver: NSObjectProtocol?
    private var yorimichiObserver: NSObjectProtocol?

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        view.addSubview(horizontalScrollView)
        view.addSubview(emptyLabelForForYou)
        view.addSubview(emptyLabelForFollowings)
        
        horizontalScrollView.contentSize = CGSize(width: view.width*2, height: view.height)
        
        //fetchPostForYou()
        fetchPostFollowing()
        
        horizontalScrollView.contentInsetAdjustmentBehavior = .never
        
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y:0)
        horizontalScrollView.delegate = self
        setUpHeaderButtons()
        
        postObserver = NotificationCenter.default.addObserver(forName: .didPostNotification, object: nil, queue: .main) { [weak self] _ in
            self?.forYouPosts = [(cellType: HomeScrollCellType, id: String)]()
            self?.fetchPostForYou()
            self?.followingPosts = [(cellType: HomeScrollCellType, id: String)]()
            self?.fetchPostFollowing()

        }
        
        yorimichiObserver = NotificationCenter.default.addObserver(forName: .didAddCandidateNotification, object: nil, queue: .main) { [weak self] _ in
            self?.forYouPosts = [(cellType: HomeScrollCellType, id: String)]()
            self?.fetchPostForYou()

        }
    }
    
    private func fetchPostForYou(){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        let group = DispatchGroup()
        
        group.enter()
        
        print("debug Location \(self.currentLocation)")
        DatabaseManager.shared.explorePostsNearBy(currentLocation: self.currentLocation ?? CLLocation(), completion: {[weak self] posts in
            
            defer{
                group.leave()
            }
            
            posts.forEach{
                self?.forYouPosts.append((cellType: .photo(viewModel: HomeScrollPhotoViewModel(post: $0)), id: $0.id))
            }
        })
        
        
        
//        DatabaseManager.shared.getNotFollowingNotBlocking(username: username, completion: { randomUsers in
//            defer{
//                group.leave()
//            }
//
//            randomUsers.forEach{ user in
//                // Fetch User posts images
//                group.enter()
//                DatabaseManager.shared.postsRecent(for: user, completion: {[weak self] result in
//                    defer{
//                        group.leave()
//                    }
//
//                    switch result{
//                    case .success(let posts):
//                        //self?.posts = posts
//                        posts.forEach{
//                            self?.forYouPosts.append((cellType: .photo(viewModel: HomeScrollPhotoViewModel(post: $0)), id: $0.id))
//                        }
//
//                    case .failure:
//                        break
//                    }
//
//                })
//
//                // Fetch User video posts
//                group.enter()
//                DatabaseManager.shared.videoPostsRecent(for: user, completion: {[weak self] result in
//                    defer{
//                        group.leave()
//                    }
//
//                    switch result{
//                    case .success(let posts):
//                        print("here======")
//                        print(posts)
//                        posts.forEach{
//                            self?.forYouPosts.append((cellType: .video(viewModel: HomeScrollVideoViewModel(post: $0)), id: $0.id))
//
//                        }
//                    case .failure:
//                        print("failure======")
//                        break
//
//                    }
//                })
//            }
//        })
        
        group.notify(queue: .main){
            print("\n\nNotify")
            if(self.forYouPosts.isEmpty){
                print("\n\nEmpty")
                self.emptyLabelForForYou.isHidden = false
            }
            else{
                self.emptyLabelForForYou.isHidden = true
            }
            self.setUpForYouFeed()
        }
        
    }
    
    private func fetchPostFollowing(){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        let group = DispatchGroup()
        
        group.enter()
        
        DatabaseManager.shared.followingNotBlocking(for: username, completion: { userStrings in
            defer{
                group.leave()
            }
            print("\n\nhere")
            print(userStrings)
            userStrings.forEach{ userString in

                // Fetch User posts images
                group.enter()
                DatabaseManager.shared.postsRecent(for: userString, completion: {[weak self] result in
                    defer{
                        group.leave()
                    }
                    print("here1")
                    
                    switch result{
                    case .success(let posts):
                        print("here2")
                        print(posts)
                        //self?.posts = posts
                        //self?.posts = posts
                        
                        if(posts.count > 0){
                            posts.forEach{
                                self?.followingPosts.append((cellType: .photo(viewModel: HomeScrollPhotoViewModel(post: $0)), id: $0.id))
                            }
                        }
                        
                    case .failure:
                        break
                    }
                    
                })
                
                // Fetch User video posts
                group.enter()
                DatabaseManager.shared.videoPostsRecent(for: userString, completion: {[weak self] result in
                    defer{
                        group.leave()
                    }
                    
                    switch result{
                    case .success(let posts):
                        print("here======")
                        print(posts)
                        //                self?.posts = posts.map({
                        //                    return .video(viewModel: ProfileVideoCellViewModel(post: $0))
                        //                })
                        print(posts.count)
                        if(posts.count > 0){
                            posts.forEach{
                                self?.followingPosts.append((cellType: .video(viewModel: HomeScrollVideoViewModel(post: $0)), id: $0.id))
                            }
                        }
                    case .failure:
                        print("failure======")
                        break
                        
                    }
                })
            }
        })
        
        
      
        
        
        
        group.notify(queue: .main){
            if(self.followingPosts.isEmpty){
                self.emptyLabelForFollowings.isHidden = false
            }
            else{
                self.emptyLabelForFollowings.isHidden = true
            }
            self.setUpFollowingFeed()
        }
        

        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.frame = view.bounds
        emptyLabelForForYou.sizeToFit()
        emptyLabelForForYou.center = view.center
        emptyLabelForFollowings.sizeToFit()
        emptyLabelForFollowings.center = view.center
        
        
    }
    
    private func setUpHeaderButtons(){


        control.addTarget(self, action: #selector(didChangeSegmentControl(_:)), for: .valueChanged)
        
        navigationItem.titleView = control
        
    }
    
    @objc private func didChangeSegmentControl(_ sender: UISegmentedControl){
        horizontalScrollView.setContentOffset(CGPoint(x: view.width*CGFloat(sender.selectedSegmentIndex), y: 0), animated: true)
        
    }
    
    private func setUpFeed(){

        
        
        
        
        // For You, Following
        
        setUpFollowingFeed()

        
    }
    
    private func setUpFollowingFeed(){
        
        
        guard let model = followingPosts.first else {

            return
        }

        switch model.cellType{
        case .photo(let viewModel):
            let cellVC = PhotoPostViewController(model: viewModel.post)
            cellVC.delegate = self
            followingPageViewController.setViewControllers(
                [cellVC],
                direction: .forward,
                animated: true,
                completion: nil
            )
            
        case .video(let viewModel):
            followingPageViewController.setViewControllers(
                [VideoPostViewController(model: viewModel.post)],
                direction: .forward,
                animated: true,
                completion: nil
            )
        }
        
        followingPageViewController.dataSource = self
        
        horizontalScrollView.addSubview(followingPageViewController.view)
        followingPageViewController.view.frame = CGRect(x: 0, y: 0, width: horizontalScrollView.width, height: horizontalScrollView.height)
        
        addChild(followingPageViewController)
        followingPageViewController.didMove(toParent: self)
    }
    
    private func setUpForYouFeed(){
        
        guard let model = forYouPosts.first else {
            print("faling 1")
            return
        }
        
        switch model.cellType{
        case .photo(let viewModel):
            print("\n\n\nfalling 2")
            let vc = PhotoPostViewController(model: viewModel.post)
            vc.delegate = self
            forYorPageViewController.setViewControllers(
                [vc],
                direction: .forward,
                animated: true,
                completion: nil
            )
            
        case .video(let viewModel):
            print("\n\n\nfalling 3")
            let vc = VideoPostViewController(model: viewModel.post)
            vc.delegate = self
            forYorPageViewController.setViewControllers(
                [vc],
                direction: .forward,
                animated: true,
                completion: nil
            )
        }
        
        
        
//        let vc = VideoPostViewController(model: model, isDelegateButtonAction: true)
//        vc.delegate = self
//        forYorPageViewController.setViewControllers(
//            [vc],
//            direction: .forward,
//            animated: true,
//            completion: nil
//        )
//
        
        
        forYorPageViewController.dataSource = self
        
        horizontalScrollView.addSubview(forYorPageViewController.view)
        forYorPageViewController.view.frame = CGRect(x: view.width, y: 0, width: horizontalScrollView.width, height: horizontalScrollView.height)
        
        addChild(forYorPageViewController)
        forYorPageViewController.didMove(toParent: self)
    }
}

extension HomeViewController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        guard let fromPost = (viewController as? VideoPostViewController)?.model else {
//            return nil
//        }
//
        if let fromPost = (viewController as? VideoPostViewController)?.model{
            guard let index = currentPosts.firstIndex(where: {
                $0.id == fromPost.id
            }) else {
                return nil
            }
            
            if index == 0{
                return nil
            }
            
            let priorIndex = index - 1
            let model = currentPosts[priorIndex]
            
            switch model.cellType{
            case .photo(let viewModel):
                let vc = PhotoPostViewController(model: viewModel.post)
//                vc.delegate = self
                return vc
            case .video(let viewModel):
                let vc = VideoPostViewController(model: viewModel.post)
                vc.delegate = self
                return vc

            }
            
        }
        else if let fromPost = (viewController as? PhotoPostViewController)?.model{
            guard let index = currentPosts.firstIndex(where: {
                $0.id == fromPost.id
            }) else {
                return nil
            }
            
            if index == 0{
                return nil
            }
            
            let priorIndex = index - 1
            let model = currentPosts[priorIndex]
            
            switch model.cellType{
            case .photo(let viewModel):
                let vc = PhotoPostViewController(model: viewModel.post)
//                vc.delegate = self
                return vc
            case .video(let viewModel):
                let vc = VideoPostViewController(model: viewModel.post)
                vc.delegate = self
                return vc

            }
        }
        else{
            return nil
        }
        
                
        
                
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        guard let fromPost = (viewController as? VideoPostViewController)?.model else {
//            return nil
//        }
//
//        guard let index = currentPosts.firstIndex(where: {
//            $0.identifier == fromPost.identifier
//        }) else {
//            return nil
//        }
//
//        guard index < (currentPosts.count - 1) else {
//            return nil
//        }
//
//
//        let nextIndex = index + 1
//        let model = currentPosts[nextIndex]
//        let vc = VideoPostViewController(model: model, isDelegateButtonAction: true)
//        vc.delegate = self
//        return vc
//
        
//        guard let fromPost = (viewController as? VideoPostViewController)?.model else {
//            return nil
//        }
        
        if let fromPost = (viewController as? VideoPostViewController)?.model{
            print("let 1========")
            guard let index = currentPosts.firstIndex(where: {
                $0.id == fromPost.id
            }) else {
                print("fall1")
                return nil
            }
            
            guard index < (currentPosts.count - 1) else {
                print("fall2")
                return nil
            }

            
            let nextIndex = index + 1
            let model = currentPosts[nextIndex]
            
            switch model.cellType{
            case .photo(let viewModel):
                print("fall3 photo=======")
                print(viewModel.post)
                let vc = PhotoPostViewController(model: viewModel.post)
//                vc.delegate = self
                return vc
            case .video(let viewModel):
                print("fall3 video=======")
                let vc = VideoPostViewController(model: viewModel.post)
                vc.delegate = self
                return vc

            }
            
        }
        else if let fromPost = (viewController as? PhotoPostViewController)?.model{
            print("let 2========")
            print(fromPost)
            guard let index = currentPosts.firstIndex(where: {
                $0.id == fromPost.id
            }) else {
                return nil
            }
            
            guard index < (currentPosts.count - 1) else {
                return nil
            }

            
            let nextIndex = index + 1
            let model = currentPosts[nextIndex]
            
            switch model.cellType{
            case .photo(let viewModel):
                print("let 2 photo========")
                
                let vc = PhotoPostViewController(model: viewModel.post)
                //                vc.delegate = self
                return vc
            case .video(let viewModel):
                print("let 2 video========")

                let vc = VideoPostViewController(model: viewModel.post)
                vc.delegate = self
                return vc

            }
        }
        else{
            return nil
        }
        
        
    }
    
    
    var currentPosts: [(cellType: HomeScrollCellType, id: String)] {
        
        if horizontalScrollView.contentOffset.x == 0{
            // Following
            return followingPosts
            
        }
        else{
            // For You
            return forYouPosts
        }
    }
    
    
}

extension HomeViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x <= (view.width/2){
            control.selectedSegmentIndex = 0
            emptyLabelForForYou.removeFromSuperview()
            view.addSubview(emptyLabelForFollowings)
        }
        else if scrollView.contentOffset.x > (view.width/2){
            control.selectedSegmentIndex = 1
            emptyLabelForFollowings.removeFromSuperview()
            view.addSubview(emptyLabelForForYou)
        }
    }
}


extension HomeViewController: VideoPostViewControllerDelegate{
    func videoPostViewControllerDidTapComment(_ vc: VideoPostViewController, didTapCommentButtonFor post: Post) {
        
        print("+++++++++")
        horizontalScrollView.isScrollEnabled = false
        
        if horizontalScrollView.contentOffset.x == 0{
            // following
            followingPageViewController.dataSource = nil
        }
        else{
            forYorPageViewController.dataSource = nil
        }

    }
    
    func videoPostViewControllerDidTapCommentClose() {
        horizontalScrollView.isScrollEnabled = true
        forYorPageViewController.dataSource = self
        followingPageViewController.dataSource = self
    }
    
    func videoPostViewControllerDidTapComment() {
        
    }
    
    func videoPostViewController(_ vc: VideoPostViewController, didTapCommentButtonFor post: Post) {
        
        print("delegate called")
        horizontalScrollView.isUserInteractionEnabled = false
        if horizontalScrollView.contentOffset.x == 0{
           // following
            followingPageViewController.dataSource = nil
            
        }
        else{
            // for you
            forYorPageViewController.dataSource = nil
        }
        let vc = CommentsViewController(viewModel: CommentsViewModel(type: .video(viewModel: post)))
        vc.delegate = self
        addChild(vc)
        vc.didMove(toParent: self)
        view.addSubview(vc.view)
        let frame = CGRect(x: 0, y: view.height, width: view.width, height: view.height*0.76)
        vc.view.frame = frame
        UIView.animate(withDuration: 0.2){
            vc.view.frame = CGRect(x: 0, y: self.view.height - frame.height, width: frame.width, height: frame.height)
        }
    }
    
    func videoPostViewController(_ vc: VideoPostViewController, didTapProfileButtonFor post: Post) {
        let user = post.user
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension HomeViewController: CommentsViewControllerDeleagate{
    func commentsViewControllerDidTapComment(with viewController: CommentsViewController, withText text: String, type: ShowingCommentSegment) {
    }
    
    func commentsViewControllerDidTapCloseForComments(with viewController: CommentsViewController) {
        
        
    }
    
    
}

extension HomeViewController: PhotoPostViewControllerDelegate{
    func photoPostViewControllerDidTapCommentClose() {
        horizontalScrollView.isScrollEnabled = true
        forYorPageViewController.dataSource = self
        followingPageViewController.dataSource = self
    }
    
    func photoPostViewControllerDidTapComment(_ vc: PhotoPostViewController, didTapCommentButtonFor post: Post) {
        
        horizontalScrollView.isScrollEnabled = false
        
        if horizontalScrollView.contentOffset.x == 0{
            // following
            followingPageViewController.dataSource = nil
        }
        else{
            forYorPageViewController.dataSource = nil
        }
//        let vc = CommentsViewController(viewModel: CommentsViewModel(type: .photo(viewModel: post)))
//        addChild(vc)
//        vc.didMove(toParent: self)
//        view.addSubview(vc.view)
//        let frame = CGRect(x: 0, y: view.height, width: view.width, height: view.height*0.76)
//        vc.view.frame = frame
//        UIView.animate(withDuration: 0.2){
//            vc.view.frame = CGRect(x: 0, y: self.view.height - frame.height, width: frame.width, height: frame.height)
//        }
    }
    
    func photoPostViewControllerDidTapComment() {
    }
    
    
}


extension HomeViewController: CLLocationManagerDelegate{
    
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
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        self.currentLocation = userLocation
        fetchPostForYou()
        locationManager.stopUpdatingLocation()
        
        

        
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}
