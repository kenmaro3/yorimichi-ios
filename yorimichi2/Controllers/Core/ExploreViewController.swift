import Foundation

import UIKit
import MapKit
import CoreLocation

class ExploreViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource, PhotoTableViewFooterViewDelegate {
    
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
    
    func photoTableViewFooterViewDidSelect(index: Int) {
        if(index == 0){
            let vc = ExploreDetailViewController(posts: self.postsPromotion)
            vc.setTitle(title: sections[index].title)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (index == 1){
            let vc = ExploreDetailViewController(posts: self.posts)
            vc.setTitle(title: sections[index].title)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (index == 2){
            let vc = ExploreDetailViewController(posts: self.postsPopular)
            vc.setTitle(title: sections[index].title)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (index == 3){
            let vc = ExploreDetailViewController(posts: self.postsNearBy)
            vc.setTitle(title: sections[index].title)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            fatalError("index for explore detail is not allowed")
        }
    }
    
    
    private let post_show_count = 3;
    
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private struct SettingsSection{
        let title: String
        var posts: [Post]
    }
    
    private var sections: [SettingsSection] = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let targetSection = indexPath.section
        var model: Post
        if(targetSection == 0){
            model = self.postsPromotion[indexPath.row]
            let viewModel = PhotoCellViewModel(post: model)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath) as? PhotoTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: viewModel)
            //cell.delegate = self
            return cell
        }
        else if (targetSection == 1){
            model = self.posts[indexPath.row]
            let viewModel = PhotoCellViewModel(post: model)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath) as? PhotoTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: viewModel)
            //cell.delegate = self
            return cell
        }
        else if (targetSection == 2){
            model = self.postsPopular[indexPath.row]
            let viewModel = PhotoCellViewModel(post: model)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath) as? PhotoTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: viewModel)
            //cell.delegate = self
            return cell
        }
        else if (targetSection == 3){
            model = self.postsNearBy[indexPath.row]
            let viewModel = PhotoCellViewModel(post: model)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath) as? PhotoTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: viewModel)
            //cell.delegate = self
            return cell
        }
        else{
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let targetSection = indexPath.section;
        
        if(targetSection == 0){
            let model = postsPromotion[indexPath.row]
            let vc = PhotoPostViewController(model: model)
            navigationController?.pushViewController(vc, animated: true)
            
        }
        else if (targetSection == 1){
            let model = posts[indexPath.row]
            let vc = PhotoPostViewController(model: model)
            navigationController?.pushViewController(vc, animated: true)
            
        }
        else if (targetSection == 2){
            let model = postsPopular[indexPath.row]
            let vc = PhotoPostViewController(model: model)
            navigationController?.pushViewController(vc, animated: true)
            
        }
        else if (targetSection == 3){
            let model = postsNearBy[indexPath.row]
            let vc = PhotoPostViewController(model: model)
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }

    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sections[section].title
//    }
    
    
    func tableView(_ tableView: UITableView,
            viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: PhotoTableViewHeaderView.identifier) as! PhotoTableViewHeaderView
        
        
        if (section == 0){
            view.title.text = sections[section].title
            view.image.image = UIImage(systemName: "wand.and.stars")
            
            view.image.tintColor = .label
            
            
            return view
            
        }
        else if (section == 1){
            view.title.text = sections[section].title
            view.image.image = UIImage(systemName: "clock")
            view.image.tintColor = .label
            return view
            
        }
        else if (section == 2){
            view.title.text = sections[section].title
            view.image.image = UIImage(systemName: "heart")
            view.image.tintColor = .label
            return view
            
        }
        else if (section == 3){
            view.title.text = sections[section].title
            view.image.image = UIImage(systemName: "location")
            view.image.tintColor = .label
            return view
            
        }
        view.title.text = sections[section].title
        view.image.image = UIImage(systemName: "clock")
        view.image.tintColor = .label
        return view
    }
    
    func tableView(_ tableView: UITableView,
            viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: PhotoTableViewFooterView.identifier) as! PhotoTableViewFooterView
        
        
        view.delegate = self
        
        view.title.text = "もっと \(sections[section].title) を見る"
        view.index = section
        return view
    }
    
    
//    func tableView(_ tableView: UITableView, titleForFooterInSection
//                   section: Int) -> String? {
//        if(section == 0){
//
//        }
//        else if (section == 1){
//
//        }
//        else if (section == 2){
//
//        }
//        else if (section == 3){
//            return "Footer \(section)"
//        }
//        else{
//            return "Footer \(section)"
//        }
//        return "Footer \(section)"
//    }

    
    private let searchVC = UISearchController(searchResultsController: SearchPostResultsViewController())

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.identifier)
        return tableView
    }()

    private var posts = [Post]()
    private var postsPromotion = [Post]()
    private var postsPopular = [Post]()
    private var postsNearBy = [Post]()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        
        tableView.separatorStyle = .none
        
        // Register the custom header view.
        tableView.register(PhotoTableViewHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: PhotoTableViewHeaderView.identifier)
        tableView.register(PhotoTableViewFooterView.self,
                           forHeaderFooterViewReuseIdentifier: PhotoTableViewFooterView.identifier)
        view.backgroundColor = .systemBackground
        
        let isGhost = UserDefaults.standard.bool(forKey: "isGhost")
        if(!isGhost){
            title = "Explore"
        }
        else{
            title = "Explore (ゴーストモード)"
        }
        (searchVC.searchResultsController as? SearchPostResultsViewController)?.delegate = self

        searchVC.searchBar.placeholder = "キーワード検索 ..."
        navigationItem.searchController = searchVC
        searchVC.searchResultsUpdater = self

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        fetchData()
        
        configureNavBar()

    }
    
    @objc private func didTapSettings(){
        let vc = SettingsViewController()
        present(UINavigationController(rootViewController: vc), animated: true)
    }

    private func configureNavBar(){
        let isGhost = UserDefaults.standard.bool(forKey: "isGhost")
        if isGhost{
            let settingButton = UIBarButtonItem(
                image: UIImage(systemName: "gear"),
                style: .done,
                target: self,
                action: #selector(didTapSettings)
            )
            navigationItem.rightBarButtonItems = [settingButton]
        }
        else{
            
        }
    }
    
    private func filterForRecent(allPosts: [Post], completion: (Bool) -> Void){
        let now = Date()
        let modifiedDate = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        
        var recentPosts = allPosts.filter{
            $0.date > modifiedDate
            
        }
        recentPosts.sort{ $0.date > $1.date}
        self.posts = recentPosts
        completion(true)
        return
        
    }
    
    private func filterForPopular(allPosts: [Post], completion: (Bool) -> Void){
        let now = Date()
        let modifiedDate = Calendar.current.date(byAdding: .day, value: -30, to: now)!
        
        let recentPosts = allPosts.filter{
            $0.date > modifiedDate
            
        }
        
        if(recentPosts.count == 0){
            self.postsPopular = []
            completion(true)
            return
            
        }
        
        let sortedIndices = recentPosts.enumerated()
            .sorted{ $0.element.likers.count > $1.element.likers.count }
            .map{ $0.offset }
        
        var resPost: [Post] = []
        
        let sortedIndicesLimited = sortedIndices[0..<min(10, sortedIndices.count)]
        for i in 0..<min(10, sortedIndices.count){
            resPost.append(recentPosts[sortedIndices[i]])
        }
        
        self.postsPopular = resPost
        completion(true)
        return

    }
    
    private func filterForNearBy(allPosts: [Post], completion: (Bool) -> Void){
        let now = Date()
        let modifiedDate = Calendar.current.date(byAdding: .day, value: -30, to: now)!
        
        let recentPosts = posts.filter{
            $0.date > modifiedDate
            
        }
        
        if(recentPosts.count == 0){
            self.postsNearBy = []
            completion(true)
            return
            
        }
        
        var distanceList = [Float]()
        
        guard let currentLocation = currentLocation else {
            self.postsNearBy = []
            completion(true)
            return
        }

        recentPosts.forEach{
            let latDiff = currentLocation.coordinate.latitude - $0.location.lat
            let lngDiff = currentLocation.coordinate.longitude - $0.location.lng
            
            distanceList.append(Float(latDiff*latDiff+lngDiff*lngDiff))
        }
        
        let sortedIndices = distanceList.enumerated()
            .sorted{ $0.element < $1.element }
            .map{$0.offset}
        
        var resPost: [Post] = []
        
        
        let sortedIndicesLimited = sortedIndices[0..<min(10, sortedIndices.count)]
        for i in 0..<min(10, sortedIndices.count){
            resPost.append(recentPosts[sortedIndices[i]])
        }
        
        self.postsNearBy = resPost
        completion(true)
        return

    }


    private func fetchData(){
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        group.enter()
        
        
        DatabaseManager.shared.explorePostsPromotion(currentLocation: self.currentLocation ?? CLLocation()){ posts in
            defer{
                group.leave()
            }
            self.postsPromotion = posts
        }
        
        DatabaseManager.shared.exploreAllYorimichiPosts(completion: {[weak self] allPosts in
            self?.filterForRecent(allPosts: allPosts, completion: { res in
                defer{
                    group.leave()
                }
            })
            self?.filterForPopular(allPosts: allPosts, completion: { res in
                defer{
                    group.leave()
                }
            })
            self?.filterForNearBy(allPosts: allPosts, completion: { res in
                defer{
                    group.leave()
                }
            })
            
            
        })
        
        
        
        group.notify(queue: .global()){
            self.sections.append(
                SettingsSection(title: "プロモーション", posts: Array(self.postsPromotion[0..<min(self.postsPromotion.count, self.post_show_count)]) )
            )
            self.sections.append(
                SettingsSection(title: "最新の投稿", posts: Array(self.posts[0..<min(self.posts.count, self.post_show_count)]) )
            )
            self.sections.append(
                SettingsSection(title: "人気の投稿", posts: Array(self.postsPopular[0..<min(self.postsPopular.count, self.post_show_count)]) )
            )
            self.sections.append(
                SettingsSection(title: "周辺の投稿", posts: Array(self.postsNearBy[0..<min(self.postsNearBy.count, self.post_show_count)]) )
            )
            
            self.tableView.reloadData()
            
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    /// when user hit the keyboard key
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsVC = searchController.searchResultsController as? SearchPostResultsViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            return
        }

        DatabaseManager.shared.findPlacesSubString(with: query){ results in
            resultsVC.update(with: results)
        }
    }
}

extension ExploreViewController: SearchPostResultsViewControllerDelegate{
    func searchPostResultsViewController(_ vc: SearchPostResultsViewController, didSelectResultsPlace locationTitle: String) {
        print("\n\n==================================")
        print(locationTitle)
        let vc = SpecificPostsViewController(locationTitle: locationTitle)
        //vc.fetchData(with: locationTitle)
        navigationController?.pushViewController(vc, animated: true)
//        let vc = PhotoPostViewController(model: post)
//        navigationController?.pushViewController(vc, animated: true)
    }


}

extension ExploreViewController: CLLocationManagerDelegate{
    
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
        print("\n\nhere==============")
        print("explore updating location \(self.currentLocation)")
        DatabaseManager.shared.explorePostsNearBy(currentLocation: self.currentLocation ?? CLLocation(), completion: { posts in
            self.postsNearBy = posts
            self.tableView.reloadData()
        })
        locationManager.stopUpdatingLocation()
        
        

        
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}

//extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return posts.count
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
//            fatalError()
//        }
//        let model = posts[indexPath.row]
//        cell.configure(with: URL(string: model.postUrlString))
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        let model = posts[indexPath.row]
//        print("\n\ndebug")
//        print(model)
//        let vc = PhotoPostViewController(model: model)
//        navigationController?.pushViewController(vc, animated: true)
//    }
//}
//


//class ExploreViewController: UIViewController, UISearchResultsUpdating {
//    private let searchVC = UISearchController(searchResultsController: SearchPostResultsViewController())
//
//    private let collectionView: UICollectionView = {
//        let layout = UICollectionViewCompositionalLayout{ index, _  -> NSCollectionLayoutSection? in
//            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
//            let fullItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
//            let tripletItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1)))
//            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)), subitem: fullItem, count: 2)
//            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(160)), subitems: [item, verticalGroup])
//            let threeItemGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(160)), subitem: tripletItem, count: 3)
//            let finalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(320)), subitems: [horizontalGroup, threeItemGroup])
//
//            return NSCollectionLayoutSection(group: finalGroup)
//        }
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .systemBackground
//        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
//        return collectionView
//
//    }()
//
//
//    private var posts = [Post]()
//
//    // MARK: - Lifecycle
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .systemBackground
//        title = "Explore"
//        (searchVC.searchResultsController as? SearchPostResultsViewController)?.delegate = self
//
//        searchVC.searchBar.placeholder = "キーワード検索 ..."
//        navigationItem.searchController = searchVC
//        searchVC.searchResultsUpdater = self
//
//        view.addSubview(collectionView)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//
//        fetchData()
//
//    }
//
//
//    private func fetchData(){
//        DatabaseManager.shared.explorePosts{ [weak self] posts in
//            DispatchQueue.main.async {
//                self?.posts = posts
//                self?.collectionView.reloadData()
//            }
//        }
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        collectionView.frame = view.bounds
//    }
//
//    /// when user hit the keyboard key
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let resultsVC = searchController.searchResultsController as? SearchPostResultsViewController,
//              let query = searchController.searchBar.text,
//              !query.trimmingCharacters(in: .whitespaces).isEmpty
//        else {
//            return
//        }
//
//        DatabaseManager.shared.findPlacesSubString(with: query){ results in
//            resultsVC.update(with: results)
//        }
//    }
//}
//
//extension ExploreViewController: SearchPostResultsViewControllerDelegate{
//    func searchPostResultsViewController(_ vc: SearchPostResultsViewController, didSelectResultsPlace locationTitle: String) {
//        print("\n\n==================================")
//        print(locationTitle)
//        let vc = SpecificPostsViewController(locationTitle: locationTitle)
//        //vc.fetchData(with: locationTitle)
//        navigationController?.pushViewController(vc, animated: true)
////        let vc = PhotoPostViewController(model: post)
////        navigationController?.pushViewController(vc, animated: true)
//    }
//
//
//}
//
//extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return posts.count
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
//            fatalError()
//        }
//        let model = posts[indexPath.row]
//        cell.configure(with: URL(string: model.postUrlString))
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        let model = posts[indexPath.row]
//        print("\n\ndebug")
//        print(model)
//        let vc = PhotoPostViewController(model: model)
//        navigationController?.pushViewController(vc, animated: true)
//    }
//}
//
