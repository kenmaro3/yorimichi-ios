//
//  MapViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import UIKit
import Mapbox
import SDWebImage
import FloatingPanel
import StoreKit
import ProgressHUD
import MapKit

class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 44.0, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}

class MapViewController: UIViewController, FloatingPanelControllerDelegate, UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    

    var exploreFpc: FloatingPanelController!
    
    private var annotationsYorimichi: [YorimichiAnnotationViewModel] = []
    private var annotationsHP: [HPAnnotationViewModel] = []
    
    private var annotationsSelected: [SelectedAnnotationViewModel] = []
    private var annotationsLikes: [LikesAnnotationViewModel] = []
    
    private var middleListCells: [ListExploreResultCellType] = []
    private var rightListCells: [ListYorimichiLikesCellType] = []

    
    private var offset: CGFloat = 0.0
    
    private let imageTop: CGFloat = 60
    
    let geocoder = CLGeocoder()
    
    private var centeringCurrentLocation: Bool = true
    
    private var methodsObserver: NSObjectProtocol?
    private var genreObserver: NSObjectProtocol?
    private var sourceObserver: NSObjectProtocol?
    
    
    // locationManager で現在地を取得する
    private var locationManager:CLLocationManager!
    
    
    // For Requesting Route
    private var userCurrentLocation = CLLocationCoordinate2D()
    private var selectedAnnotationsLocation: [CLLocationCoordinate2D] = []
    private var destinationLocation: CLLocationCoordinate2D?
    
    private let focusButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGray
        let image = UIImage(systemName: "location.fill", withConfiguration:  UIImage.SymbolConfiguration(pointSize: 22))
        button.backgroundColor = UIColor.systemGray.withAlphaComponent(0.5)
        button.setImage(image, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.shadowColor = UIColor.systemGray.cgColor
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0.5
        button.layer.backgroundColor = UIColor.hex(string: "#F2F2F2", alpha: 1.0).cgColor
        
        return button
    }()
    
    private let exploreButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        let image = UIImage(systemName: "globe", withConfiguration:  UIImage.SymbolConfiguration(pointSize: 22))
        button.backgroundColor = .clear
        button.layer.borderWidth = 5
        button.setImage(image, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 6
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0.5
        //button.layer.backgroundColor = UIColor.systemGray.cgColor
        button.layer.backgroundColor = UIColor.hex(string: "#F2F2F2", alpha: 1.0).cgColor
        
        return button
    }()
    

    
    private let exploreLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "ユーザ投稿検索"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.backgroundColor = UIColor.hex(string: "#F2F2F2", alpha: 1.0)
        label.clipsToBounds = true
        label.textAlignment = .center
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 10
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowOpacity = 0.5
        label.layer.cornerRadius = 10
        
        return label
    }()
    
    private let exploreHPButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        let image = UIImage(systemName: "globe", withConfiguration:  UIImage.SymbolConfiguration(pointSize: 22))
        button.backgroundColor = .clear
        button.layer.borderWidth = 5
        button.setImage(image, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 6
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0.5
        //button.layer.backgroundColor = UIColor.systemGray.cgColor
        button.layer.backgroundColor = UIColor.hex(string: "#F2F2F2", alpha: 1.0).cgColor
        
        return button
    }()
    

    
    private let exploreHPLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "ホットペッパー検索"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.backgroundColor = UIColor.hex(string: "#F2F2F2", alpha: 1.0)
        label.clipsToBounds = true
        label.textAlignment = .center
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 10
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowOpacity = 0.5
        label.layer.cornerRadius = 10
        
        return label
    }()
    
    
    private let goButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        let image = UIImage(systemName: "forward", withConfiguration:  UIImage.SymbolConfiguration(pointSize: 22))
        button.backgroundColor = .clear
        button.layer.borderWidth = 5
        button.setImage(image, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 6
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0.5
        //button.layer.backgroundColor = UIColor.systemGray.cgColor
        button.layer.backgroundColor = UIColor.hex(string: "#F2F2F2", alpha: 1.0).cgColor
        
        return button
    }()
    
    private let goLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "ヨリミチ開始"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.backgroundColor = UIColor.hex(string: "#F2F2F2", alpha: 1.0)
        label.clipsToBounds = true
        label.textAlignment = .center
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 10
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowOpacity = 0.5
        label.layer.cornerRadius = 10
        
        return label
    }()
    
    
    
    
//    private let mapView: NavigationMapView = {
    private let mapView: MGLMapView = {
        //let map = NavigationMapView()
        let map = MGLMapView()
        DatabaseManager.shared.getMapStyle(completion: { styleUrl in
            
            let url = URL(string: styleUrl)
            map.styleURL = url
            return map
            
        })
        let url = URL(string: "mapbox://styles/mapbox/streets-v11")
        map.styleURL = url
        return map

    }()
    
    private let searchController = UISearchController(searchResultsController: SearchLocationResultsViewController())
    private var searchCompleter = MKLocalSearchCompleter()
    
    private var addCandidateObserver: NSObjectProtocol?

    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]

        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         
        mapView.setCenter(userCurrentLocation, zoomLevel: 15, animated: false)
         
        if(centeringCurrentLocation){
            determineMyCurrentLocation()
        }
        
        
        addSubViews()
        addButtonTarget()
        
        // Set the map view's delegate
        mapView.delegate = self
        
        
        // 長押しのジェスチャーを認識する関数
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        mapView.addGestureRecognizer(gesture)
        
        
        // Initialize a `FloatingPanelController` object.
        exploreFpc = FloatingPanelController()
        exploreFpc.layout = MyFloatingPanelLayout()

        
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
        exploreFpc.surfaceView.appearance = appearance
        
        // Assign self as the delegate of the controller.
        exploreFpc.delegate = self // Optional
        exploreFpc.view.frame = CGRect(x: 6, y: 0, width: view.width-12, height: view.height/2)
        
        let vc = ListOnMapViewController()
        vc.delegate = self
        exploreFpc.set(contentViewController: vc)
        exploreFpc.addPanel(toParent: self, animated: true)
        
        
        setupSearch()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings)
        )
        
        
        addCandidateObserver = NotificationCenter.default.addObserver(forName: .didAddCandidateNotification, object: nil, queue: .main) { [weak self] _ in
            print("notified")
            self?.removeSelectedAnnotation()
            self?.removeOnlyCandidateYorimichi()
            self?.addCandidatesAnnotation()
        }
        
    }
    
    
    @objc private func didTapLaunch(){
        
        var wayPoints: [MKMapItem] = []
        
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: userCurrentLocation.latitude, longitude: userCurrentLocation.longitude)))
        source.name = "現在地"
        
        wayPoints.append(source)
                
        
        if let destinationLocation = destinationLocation {
            let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destinationLocation.latitude, longitude: destinationLocation.longitude)))
            destination.name = "目的地"
            
            if middleListCells.count > 0 {
                for yorimichi in middleListCells{
                    switch yorimichi {
                    case .yorimichiDB(let viewModel):
                        let yorimichiLocation = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: viewModel.post.location.lat, longitude: viewModel.post.location.lng)))
                        yorimichiLocation.name = viewModel.post.locationTitle
                        wayPoints.append(yorimichiLocation)

                    case .hp(let viewModel):
                        let yorimichiLocation = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: viewModel.shop.location.lat, longitude: viewModel.shop.location.lng)))
                        yorimichiLocation.name = viewModel.shop.name
                        wayPoints.append(yorimichiLocation)
                    }
                }
                    wayPoints.append(destination)
                    let alert = UIAlertController(title: "経路検索", message: "目的地と寄り道先どちらも設定されています。この場合、1つ目の寄り道先まで経路検索します。", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                        MKMapItem.openMaps(
                            with: wayPoints,
                            launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        )
   
                    }))
                present(alert, animated: true)
                    
            }else{
                wayPoints.append(destination)
                MKMapItem.openMaps(
                    with: wayPoints,
                    launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                )
                
            }
            
        }
        else{
            if middleListCells.count > 1 {
                for yorimichi in middleListCells{
                    switch yorimichi {
                    case .yorimichiDB(let viewModel):
                        let yorimichiLocation = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: viewModel.post.location.lat, longitude: viewModel.post.location.lng)))
                        yorimichiLocation.name = viewModel.post.locationTitle
                        wayPoints.append(yorimichiLocation)

                    case .hp(let viewModel):
                        let yorimichiLocation = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: viewModel.shop.location.lat, longitude: viewModel.shop.location.lng)))
                        yorimichiLocation.name = viewModel.shop.name
                        wayPoints.append(yorimichiLocation)
                    }
                }
                
                let alert = UIAlertController(title: "経路検索", message: "寄り道先が複数選択されています。この場合１つ目の寄り道に誘導します。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                    MKMapItem.openMaps(
                        with: wayPoints,
                        launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                    )
                    
                }))
                
                present(alert, animated: true)

            }else if( middleListCells.count==1){
                for yorimichi in middleListCells{
                    switch yorimichi {
                    case .yorimichiDB(let viewModel):
                        let yorimichiLocation = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: viewModel.post.location.lat, longitude: viewModel.post.location.lng)))
                        yorimichiLocation.name = viewModel.post.locationTitle
                        wayPoints.append(yorimichiLocation)

                    case .hp(let viewModel):
                        let yorimichiLocation = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: viewModel.shop.location.lat, longitude: viewModel.shop.location.lng)))
                        yorimichiLocation.name = viewModel.shop.name
                        wayPoints.append(yorimichiLocation)
                    }
                }
                MKMapItem.openMaps(
                    with: wayPoints,
                    launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                )
                
            }else{
                AlertManager.shared.presentError(title: "経路検索エラー", message: "目的地と寄り道先どちらも設定されていません。どちらか一方を設定してください。", completion: {[weak self] alert in
                    self?.present(alert, animated: true)
                    return
                    
                })
            }
            
            
        
            
        }
                
        

    }
    
    
    @objc private func didTapSettings(){
        print("tapped")
        let vc = MapSettingsViewController()
        present(UINavigationController(rootViewController: vc), animated: true)
        
    }
    
    private func setupSearch(){
        (searchController.searchResultsController as? SearchLocationResultsViewController)?.delegate = self
        
        // MARK: - TODO saerch bar, border, tintcolor
        searchController.searchBar.placeholder = "場所の検索 ..."
        searchController.searchBar.tintColor = .label
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.barTintColor = .label
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        
        searchCompleter.delegate = self
        searchCompleter.filterType = .locationsOnly
        
    }
    

    private func removeOnlyCandidateYorimichi(){
        var tmpMiddleListCells: [ListExploreResultCellType] = [ListExploreResultCellType]()
        middleListCells.forEach({
            print($0)
            switch $0{
            case .hp(_):
                tmpMiddleListCells.append($0)
            case .yorimichiDB(_):
                break
            }
        })
        middleListCells = tmpMiddleListCells
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        destinationLocation = nil
        removeOnlyCandidateYorimichi()
        removeDestinationAnnotation()
        addCandidatesAnnotation()
        addYorimichiLikesAnnotation()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    private func addSubViews(){
        view.addSubview(mapView)
        view.addSubview(focusButton)
        view.addSubview(exploreButton)
        view.addSubview(exploreLabel)
        view.addSubview(exploreHPButton)
        view.addSubview(exploreHPLabel)
        view.addSubview(goButton)
        view.addSubview(goLabel)
    }
    
    
    private func addButtonTarget(){
        focusButton.addTarget(self, action: #selector(didTapFocus), for: .touchUpInside)
        exploreButton.addTarget(self, action: #selector(didTapExplore), for: .touchUpInside)
        exploreHPButton.addTarget(self, action: #selector(didTapExploreHP), for: .touchUpInside)
        goButton.addTarget(self, action: #selector(didTapLaunch), for: .touchUpInside)
    }
    
    
    
    
    @objc private func didTapExplore(){
        print("tap explore")
        removeYorimichiAnnotation()
        removeHPAnnotation()
        exploreWithYorimichiDB()
    }
    
    @objc private func didTapExploreHP(){
        print("tap explore")
        removeYorimichiAnnotation()
        removeHPAnnotation()
        exploreWithHP()
    }
    
    
    private func exploreWithHP(){
        guard let genre = UserDefaults.standard.string(forKey: "genre") else {
            return
        }
        if !(foodGenreList.contains(genreDisplayStringToCode(x: genre))) && !(otherGenreList.contains(genreDisplayStringToCode(x: genre))){
            AlertManager.shared.presentError(title: "検索ジャンルエラー", message: "HotPepper検索はフードジャンルのみ実行可能です。", completion: {[weak self] alert in
                self?.present(alert, animated: true)
                return
            })
        }
        
        ProgressHUD.show("検索しています...")
        let refLocation = Location(lat: mapView.centerCoordinate.latitude, lng: mapView.centerCoordinate.longitude)
        
        HotPepperAPIManager.shared.getShops(
            currentLocation: refLocation,
            genre: GenreInfo(code: genreDisplayStringToCode(x: genre), type: .food),
            completion: {[weak self] shops in
                print(shops)
                self?.hpShopsToAnnotations(shops: shops, completion: {[weak self] annotations in
                    print("debug0")
                    print(annotations)
                    self?.annotationsHP.removeAll()
                    for annotation in annotations{
                        self?.annotationsHP.append(annotation)
                    }
                    self?.mapView.addAnnotations(annotations)
                    let cellTypes = annotations.map({
                        ListExploreResultCellType.hp(viewModel: $0)
                    })
                    let vc = ListExploreResultViewController(
                        viewModels: cellTypes
                    )
                    if (cellTypes.isEmpty){
                        ProgressHUD.dismiss()
                        AlertManager.shared.presentError(title: "場所が見つかりませんでした。", message: "ジャンルもしくは場所を変更して検索してください。", completion: { alert in
                            
                            self?.present(alert, animated: true)
                        })
                        return
                    }
                    ProgressHUD.dismiss()
                    guard let listVC = self?.exploreFpc.contentViewController as? ListOnMapViewController else {
                        fatalError()
                    }
                    listVC.updateLeft(with: cellTypes)
                    self?.exploreFpc.move(to: .full, animated: true, completion: nil)

                    
                })
            })
    }
    
    
    private func exploreWithYorimichiDB(){
        guard let genre = UserDefaults.standard.string(forKey: "genre") else {
            return
        }
        
        var genreType = GenreType.food
        if (foodGenreList.contains(genreDisplayStringToCode(x: genre))){
            genreType = GenreType.food
        }
        else if (spotGenreList.contains(genreDisplayStringToCode(x: genre))){
            genreType = GenreType.spot
        }
        else if (shopGenreList.contains(genreDisplayStringToCode(x: genre))){
            genreType = GenreType.shop
        }
        else if (otherGenreList.contains(genreDisplayStringToCode(x: genre))){
            genreType = GenreType.other
            
        }
        else{
            AlertManager.shared.presentError(title: "検索ジャンルエラー", message: "ジャンル情報が無効です。", completion: {[weak self] alert in
                self?.present(alert, animated: true)
                return
            })
        }
        
        ProgressHUD.show("検索しています...")
        let genreInfo = GenreInfo(code: genreDisplayStringToCode(x: genre), type: genreType)
        
        let refLocation = Location(lat: mapView.centerCoordinate.latitude, lng: mapView.centerCoordinate.longitude)
        //        let refLocation = Location(lat: userCurrentLocation.latitude, lng: userCurrentLocation.longitude)
        
        var totalCellTypes = [ListExploreResultCellType]()
        var totalAnnotations = [YorimichiAnnotationViewModel]()
        let group = DispatchGroup()
        group.enter()
        group.enter()
        DatabaseManager.shared.exploreYorimichiPosts(genre: genreInfo, refLocation: refLocation, completion: {[weak self] places in
            defer{
                group.leave()
            }
            print("okay")
            print(places)
            self?.postsToAnnotations(posts: places, completion: {[weak self] annotations in
                self?.annotationsYorimichi.removeAll()
                for annotation in annotations{
                    self?.annotationsYorimichi.append(annotation)
                }
//                self?.mapView.addAnnotations(annotations)
//                print(annotations)
                totalAnnotations = totalAnnotations + annotations
                let cellTypes = annotations.map({
                    ListExploreResultCellType.yorimichiDB(viewModel: $0)
                })
                totalCellTypes = totalCellTypes + cellTypes


                
                
            })
        })
        
        DatabaseManager.shared.exploreYorimichiVideoPosts(genre: genreInfo, refLocation: refLocation, completion: {[weak self] places in
            defer{
                group.leave()
            }
            print("okay======video")
            print(places)
            self?.postsToAnnotations(posts: places, completion: {[weak self] annotations in
//                self?.mapView.addAnnotations(annotations)
//                print(annotations)
                totalAnnotations = totalAnnotations + annotations
                
                let cellTypes = annotations.map({
                    ListExploreResultCellType.yorimichiDB(viewModel: $0)
                })
                totalCellTypes = totalCellTypes + cellTypes
                
            })
        })
        
        group.notify(queue: .main){
            ProgressHUD.dismiss()
            guard let listVC = self.exploreFpc.contentViewController as? ListOnMapViewController else {
                fatalError()
            }
            if (totalCellTypes.isEmpty){
                AlertManager.shared.presentError(title: "場所が見つかりませんでした。", message: "ジャンルもしくは場所を変更して検索してください。", completion: { alert in
                    
                    self.present(alert, animated: true)
                })
                ProgressHUD.dismiss()
                return
            }
            self.annotationsYorimichi = totalAnnotations
            self.mapView.addAnnotations(totalAnnotations)
            listVC.updateLeft(with: totalCellTypes)
            self.exploreFpc.move(to: .full, animated: true, completion: nil)

        }
        
    }
    
    public func addYorimichiLikesAnnotation(){
        guard let user = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        guard let listVC = self.exploreFpc.contentViewController as? ListOnMapViewController else {
            fatalError()
        }
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        DatabaseManager.shared.yorimichiLikes(for: user, completion: {[weak self] posts in
            self?.postsToLikesAnnotations(posts: posts, completion: {[weak self] annotations in
                defer{
                    group.leave()
                }
                
                let cellTypes = annotations.map({
                    ListYorimichiLikesCellType.yorimichiDB(viewModel: $0)
                })
               
                guard let strongSelf = self else {
                    return
                }
                //strongSelf.rightListCells = strongSelf.rightListCells + cellTypes
                strongSelf.rightListCells = cellTypes
                
                listVC.updateRight(with: strongSelf.rightListCells)
            })
            self?.postsToLikesAnnotations(posts: posts, completion: { annotations in
                defer{
                    group.leave()
                    
                }
//                for annotation in annotations{
//                    self?.annotationsLikes.append(annotation)
//                }
                
                print("\n\nposts")
                print(posts)
                print("\n\nannotations")
                print(annotations)
                
                self?.annotationsLikes = annotations
                self?.mapView.addAnnotations(annotations)
                
            })
            
            
        })
    }
    
    public func addCandidatesAnnotation(){
        guard let user = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        guard let listVC = self.exploreFpc.contentViewController as? ListOnMapViewController else {
            fatalError()
        }
        DatabaseManager.shared.candidates(for: user, completion: {[weak self] posts in
            self?.postsToAnnotations(posts: posts, completion: {[weak self] annotations in
                
                let cellTypes = annotations.map({
                    ListExploreResultCellType.yorimichiDB(viewModel: $0)
                })
               
                guard let strongSelf = self else {
                    return
                }
                strongSelf.middleListCells = strongSelf.middleListCells + cellTypes
                

                listVC.updateMiddle(with: strongSelf.middleListCells)
            })
            self?.postsToSelectedAnnotations(posts: posts, completion: { annotations in
                for annotation in annotations{
                    self?.annotationsSelected.append(annotation)
                }
                self?.mapView.addAnnotations(annotations)
                
            })
            
            
        })
    }
    
    public func addHPCandidateAnnotation(shop: Shop){
        guard let listVC = self.exploreFpc.contentViewController as? ListOnMapViewController else {
            fatalError()
        }
        self.hpShopsToAnnotations(shops: [shop], completion: {[weak self] annotations in
            let cellTypes = annotations.map({
                ListExploreResultCellType.hp(viewModel: $0)
            })
            guard let strongSelf = self else {
                return
            }
            strongSelf.middleListCells = strongSelf.middleListCells + cellTypes
            
            print(strongSelf.middleListCells)
            listVC.updateMiddle(with: strongSelf.middleListCells)
            self?.middleListCells = strongSelf.middleListCells
            
            
            
        })
            
        self.hpShopsToSelectedAnnotations(shops: [shop], completion: {[weak self] annotations in
            for annotation in annotations{
                self?.annotationsSelected.append(annotation)
            }
            self?.mapView.addAnnotations(annotations)
            
        })
            
            
    }
    
    
    private func hpShopsToAnnotations(shops: [Shop], completion: @escaping ([HPAnnotationViewModel]) -> Void){
        let tmpAnnotationsHP: [HPAnnotationViewModel] = shops.map({
            let annotation = HPAnnotationViewModel(id: $0.id, url: $0.postUrlString, jumpUrl: $0.jumpUrl, shop: $0)
            annotation.title = $0.name
            annotation.subtitle = $0.info
            let lat = $0.location.lat
            let lng = $0.location.lng
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
            return annotation
        })
        completion(tmpAnnotationsHP)
    }
    
    
    private func postsToAnnotations(posts: [Post], completion: @escaping ([YorimichiAnnotationViewModel]) -> Void){
        let tmpAnnotationsYorimichi: [YorimichiAnnotationViewModel] = posts.map({
            let annotation = YorimichiAnnotationViewModel(id: $0.id, post: $0)
            annotation.title = $0.locationTitle
            annotation.subtitle = $0.locationSubTitle
            annotation.coordinate = $0.location.getCoord
            return annotation
        })
        completion(tmpAnnotationsYorimichi)
    }
    
    private func postsToLikesAnnotations(posts: [Post], completion: @escaping ([LikesAnnotationViewModel]) -> Void){
        let tmpAnnotationsYorimichi: [LikesAnnotationViewModel] = posts.map({
            let annotation = LikesAnnotationViewModel(id: $0.id, post: $0)
            annotation.title = $0.locationTitle
            annotation.subtitle = $0.locationSubTitle
            annotation.coordinate = $0.location.getCoord
            return annotation
        })
        completion(tmpAnnotationsYorimichi)
    }
    
    private func postsToSelectedAnnotations(posts: [Post], completion: @escaping ([SelectedAnnotationViewModel]) -> Void){
        let tmpAnnotationsSelected: [SelectedAnnotationViewModel] = posts.map({
            let annotation = SelectedAnnotationViewModel(id: $0.id)
            annotation.title = $0.locationTitle
            annotation.subtitle = $0.locationSubTitle
            annotation.coordinate = $0.location.getCoord
            return annotation
        })
        completion(tmpAnnotationsSelected)
    }
    
    private func hpShopsToSelectedAnnotations(shops: [Shop], completion: @escaping ([SelectedAnnotationViewModel]) -> Void){
        let tmpAnnotationsSelected: [SelectedAnnotationViewModel] = shops.map({
            let annotation = SelectedAnnotationViewModel(id: $0.id)
            annotation.title = $0.name
            annotation.subtitle = $0.info
            let lat = $0.location.lat
            let lng = $0.location.lng
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
            return annotation
        })
        completion(tmpAnnotationsSelected)
    }
    
    @objc func didTapSearch(){
        removeYorimichiAnnotation()
        removeHPAnnotation()
        exploreFpc.removePanelFromParent(animated: true, completion: nil)
    }


    
    @objc private func didTapFriends(){
        removeYorimichiAnnotation()
        removeHPAnnotation()
        exploreFpc.removePanelFromParent(animated: true, completion: nil)
        
    }

    
    
    @objc private func didTapFocus(){
        print("focus tapped")
        mapView.setCenter(userCurrentLocation, zoomLevel: 15, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
        setupFrame()
    }

}


extension MapViewController: SearchLocationResultsViewControllerDelegate{
    func searchResultsViewControllerDidSelected(title: String, subTitle: String, location: Location) {
        let annotation = DestinationAnnotationViewModel(url: "")
        
        destinationLocation = location.getCoord
        annotation.title = title
        
        annotation.coordinate = location.getCoord
        annotation.title = subTitle
        self.showAnnotation([annotation], isPOI: false)
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension MapViewController: MKLocalSearchCompleterDelegate {
    
    // 正常に検索結果が更新されたとき
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        print(completer.results)
        guard let resultsVC = searchController
                .searchResultsController as? SearchLocationResultsViewController else {
            return
        }
        print(completer.results)
        resultsVC.delegate = self
        resultsVC.update(with: completer.results)
        
    }
    
    // 検索が失敗したとき
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // エラー処理
    }
}


extension MapViewController: ListOnMapViewControllerDelegate{
    func listOnMapViewControllerDidSelectLiked(index: Int, viewModel: ListYorimichiLikesCellType) {
        print("\n\nid of each annotation")
        annotationsSelected.forEach{
            print($0.id)
        }
        print("id of tapped viewModel")
        switch viewModel{
        case .yorimichiDB(let viewModel):
            let targetAnnotations = annotationsLikes.filter{
                $0.id == viewModel.id
            } as? [LikesAnnotationViewModel]
            if let targetAnnotation = targetAnnotations?[0] {
                mapView.selectAnnotation(targetAnnotation, animated: true, completionHandler: nil)
                
            }
                
            }
            
    }
    
    
    func ListOnMapMiddleViewControllerDidYorimichiDoubleTapped(_ cell: ListExploreResultYorimichiTableViewCell, didTapPostWith viewModel: YorimichiAnnotationViewModel) {
        let actionSheet = UIAlertController(
            title: "ヨリミチ先の消去",
            message: "ヨリミチ候補を消去しますか？",
            preferredStyle: .actionSheet
        )
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
            DispatchQueue.main.async {
                
                let group = DispatchGroup()
                
                // # of Groups: 2
                group.enter()
                group.enter()
                
                guard let cellTitle = viewModel.title else{
                    return
                }
                
                // Remove Yorimichi Candidates from Database
                guard let username = UserDefaults.standard.string(forKey: "username") else {
                    return
                }
                DatabaseManager.shared.removeYorimichiCandidate(with: viewModel.post, for: username, completion: {res in
                    defer{
                        group.leave()
                    }
                    if res{
                        
                        // Removing Annotation from Map
                        if let annotations = self?.mapView.annotations {
                            annotations.forEach{
                                if let title = $0.title as? String {
                                    if(title == cellTitle){
                                        self?.mapView.removeAnnotation($0)
                                        
                                    }
                                }
                                else{
                                }
                            }
                        }
                        
                        self?.annotationsSelected = self?.annotationsSelected.filter{
                            $0.id != viewModel.id
                        } ?? []
                        
                        
                    }
                    else{
                        AlertManager.shared.presentError(title: "ヨリミチの削除に失敗しました。", message: "ヨリミチ情報の削除に失敗しました、再度お試しください。", completion: { [weak self] alert in
                            self?.present(alert, animated: true)
                        }
                        )
                        
                    }
                })
                
                if (viewModel.post.isVideo){
                    
                    DatabaseManager.shared.updateYorimichiVideo(state: .no, postID: viewModel.post.id, owner: viewModel.post.user.username, completion: { res in
                        defer{
                            group.leave()
                        }
                        if res{
                            
                        }
                        else{
                            AlertManager.shared.presentError(title: "ヨリミチの削除に失敗しました。", message: "ヨリミチ情報の削除に失敗しました、再度お試しください。", completion: { [weak self] alert in
                                self?.present(alert, animated: true)
                            }
                            )
                        }
                        
                    })
                }
                else{
                    
                    DatabaseManager.shared.updateYorimichi(state: .no, postID: viewModel.post.id, owner: viewModel.post.user.username, completion: { res in
                        defer{
                            group.leave()
                        }
                        if res{
                            
                        }
                        else{
                            AlertManager.shared.presentError(title: "ヨリミチの削除に失敗しました。", message: "ヨリミチ情報の削除に失敗しました、再度お試しください。", completion: { [weak self] alert in
                                self?.present(alert, animated: true)
                            }
                            )
                        }
                        
                    })
                }
                
                
                group.notify(queue: .main){
                    // After all, notice this to Home Navigation Controller
                    NotificationCenter.default.post(name: .didAddCandidateNotification, object: nil)
                }
            }
        }))
        present(actionSheet, animated: true)
        
    }
    
    func ListOnMapMiddleViewControllerDidHPDoubleTapped(_ cell: ListExploreResultHPTableViewCell, didTapPostWith viewModel: HPAnnotationViewModel) {
        print("HP tapped")
        
        let actionSheet = UIAlertController(
            title: "ヨリミチ先の消去",
            message: "ヨリミチ候補を消去しますか？",
            preferredStyle: .actionSheet
        )
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
            DispatchQueue.main.async {
                guard let cellTitle = viewModel.title
                else {
                    return
                }
                // Removing Annotation from Map
                print("\ndebug: count \(self?.mapView.annotations?.count)")
                if let annotations = self?.mapView.annotations {
                    annotations.forEach{
                        print("here=== \($0)")
                        if let title = $0.title as? String {
                            print("\ndebug: \(title), \(cellTitle)")
                            if(title == cellTitle){
                                self?.mapView.removeAnnotation($0)
                            }
                        }
                        else{
                        }
                    }
                }
                
                var tmpMiddleListCells: [ListExploreResultCellType] = []
                
                self?.middleListCells.forEach{
                    switch $0{
                    case .yorimichiDB(let vm):
                        if(vm.id == viewModel.id){
                        }
                        else{
                            tmpMiddleListCells.append(.yorimichiDB(viewModel: vm))
                        }
                    case .hp(let vm):
                        if(vm.id == viewModel.id){
                        }
                        else{
                            tmpMiddleListCells.append(.hp(viewModel: vm))
                        }
                    }
                }
                
                self?.annotationsSelected = self?.annotationsSelected.filter{
                    $0.id != viewModel.id
                } ?? []
                guard let listVC = self?.exploreFpc.contentViewController as? ListOnMapViewController else {
                    fatalError()
                }
                self?.middleListCells = tmpMiddleListCells
                listVC.updateMiddle(with: tmpMiddleListCells)
                
            }
        }))
        present(actionSheet, animated: true)
        
        
    }
    
    
    func listOnMapLeftViewControllerDidHPDoubleTapped(_ cell: ListExploreResultHPTableViewCell, didTapPostWith viewModel: HPAnnotationViewModel) {
        ProgressHUD.showAdded("ヨリミチ候補に追加されました。")
        addHPCandidateAnnotation(shop: viewModel.shop)
    }
    
    
    
    private func findIndexFromIdYorimichi(id: String, completion: (Int) -> Void){
        for (i, el) in zip(annotationsYorimichi.indices, annotationsYorimichi){
            print("\(id), \(el.post.id)")
            if id == el.post.id {
                completion(i)
            }
        }
    }
                            
                            
    private func findIndexFromIdHP(id: String, completion: (Int) -> Void){
        for (i, el) in zip(annotationsHP.indices, annotationsHP){
            if id == el.shop.id {
                completion(i)
            }
        }
    }
    
    
    func listOnMapViewControllerDidSelect(index: Int, viewModel: ListExploreResultCellType) {
        print("index: \(index), count: \(annotationsYorimichi.count)")
        switch viewModel{
        case .yorimichiDB(let viewModel):
//            mapView.selectAnnotation(annotationsYorimichi[index], animated: true, completionHandler: nil)
            
            let targetAnnotations = annotationsYorimichi.filter{
                $0.id == viewModel.id
            } as? [YorimichiAnnotationViewModel]
            if let targetAnnotation = targetAnnotations?[0] {
                mapView.selectAnnotation(targetAnnotation, animated: true, completionHandler: nil)
                
            }
            
        case .hp(let viewModel):
//            mapView.selectAnnotation(annotationsHP[index], animated: true, completionHandler: nil)
            let targetAnnotations = annotationsHP.filter{
                $0.id == viewModel.id
            } as? [HPAnnotationViewModel]
            if let targetAnnotation = targetAnnotations?[0] {
                mapView.selectAnnotation(targetAnnotation, animated: true, completionHandler: nil)
                
            }
            
        }
    }
    
    func listOnMapViewControllerDidSelectSelected(index: Int, viewModel: ListExploreResultCellType) {
        print("\n\nid of each annotation")
        annotationsSelected.forEach{
            print($0.id)
        }
        print("id of tapped viewModel")
        switch viewModel{
        case .yorimichiDB(let viewModel):
            let targetAnnotations = annotationsSelected.filter{
                $0.id == viewModel.id
            } as? [SelectedAnnotationViewModel]
            if let targetAnnotation = targetAnnotations?[0] {
                mapView.selectAnnotation(targetAnnotation, animated: true, completionHandler: nil)
                
            }
            //mapView.selectAnnotation(annotationsSelected[index], animated: true, completionHandler: nil)
            
            
        case .hp(let viewModel):
            let targetAnnotations = annotationsSelected.filter{
                $0.id == viewModel.id
            } as? [SelectedAnnotationViewModel]
            if let targetAnnotation = targetAnnotations?[0] {
                mapView.selectAnnotation(targetAnnotation, animated: true, completionHandler: nil)
                
            }
            
        }
    }
}



extension MapViewController: MGLMapViewDelegate{
    // This delegate method is where you tell the map to load a view for a specific annotation. To load a static MGLAnnotationImage, you would use `-mapView:imageForAnnotation:`.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This example is only concerned with point annotations.
        
        if annotation is CurrentLocationAnnotationViewModel{
            // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
            let reuseIdentifier = "userCurrentLocation"
            
            // For better performance, always try to reuse existing annotations.
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            
            if annotationView == nil{
                annotationView = CurrentLocationAnnotationView(reuseIdentifier: reuseIdentifier)
                annotationView!.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
                return annotationView

            }
            
        }

        
        
        // If there’s no reusable annotation view available, initialize a new one.
            if annotation is YorimichiAnnotationViewModel{
                // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
                let tmpAnnotation = annotation as! YorimichiAnnotationViewModel
                let reuseIdentifier = "\(annotation.coordinate.longitude)"
                
                // For better performance, always try to reuse existing annotations.
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: YorimichiAnnotationView.identifier) as? YorimichiAnnotationView
                
                annotationView = YorimichiAnnotationView(reuseIdentifier: reuseIdentifier)
                annotationView?.configure(with: tmpAnnotation.post)
                
                let size: CGFloat = tmpAnnotation.selectedForYorimichi ? 60 : 40
                annotationView!.bounds = CGRect(x: 0, y: 0, width: size, height: size)
                
                
//                annotationView!.layer.borderColor = UIColor.systemRed.cgColor
                return annotationView
                
            } else if annotation is HPAnnotationViewModel{
                // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
                let tmpAnnotation = annotation as! HPAnnotationViewModel
                let reuseIdentifier = "\(annotation.coordinate.longitude)"
                
                // For better performance, always try to reuse existing annotations.
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: HPAnnotationView.identifier) as? HPAnnotationView
                print("here")
                print(tmpAnnotation.url)
                
                annotationView = HPAnnotationView(reuseIdentifier: reuseIdentifier)
                annotationView?.configure(with: tmpAnnotation.url)
                
                annotationView!.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
                return annotationView
                
            }
            else if annotation is DestinationAnnotationViewModel{
            // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
            let reuseIdentifier = "\(annotation.coordinate.longitude)"
            
            // For better performance, always try to reuse existing annotations.
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
                annotationView = DestinationAnnotationView(reuseIdentifier: reuseIdentifier)
                annotationView!.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
                return annotationView
            }
        else if annotation is SelectedAnnotationViewModel{
            // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
            let reuseIdentifier = "\(annotation.coordinate.longitude)"
            
            // For better performance, always try to reuse existing annotations.
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            annotationView = SelectedAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
            return annotationView
        }
        
        else if annotation is LikesAnnotationViewModel{
            print("\nlikes annotation view model called")
            let tmpAnnotation = annotation as? LikesAnnotationViewModel
            print(tmpAnnotation?.post)
            // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
            let reuseIdentifier = "\(annotation.coordinate.longitude)"
            
            // For better performance, always try to reuse existing annotations.
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            annotationView = LikesAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
            return annotationView
            
        }
        
        return MGLAnnotationView()
        
        
    }
    
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
    }
    
    

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        // Create point to represent where the symbol should be placed
        let point = MGLPointAnnotation()
        point.coordinate = mapView.centerCoordinate
         
        // Create a data source to hold the point data
        let shapeSource = MGLShapeSource(identifier: "marker-source", shape: point, options: nil)
         
        // Create a style layer for the symbol
        let shapeLayer = MGLSymbolStyleLayer(identifier: "marker-style", source: shapeSource)
         
//        // Add the image to the style's sprite
//        if let image = UIImage(named: "standing_man") {
//            print("\n\n++++++++++++++++++++++++++")
//            style.setImage(image, forName: "standing_man")
//        }
         
        // Tell the layer to use the image in the sprite
        shapeLayer.iconImageName = NSExpression(forConstantValue: "standing_man")
         
        // Add the source and style layer to the map
        style.addSource(shapeSource)
        style.addLayer(shapeLayer)
    }


    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotationView: MGLAnnotationView) {
        print("indeed called")
        print(annotationView)
    }
    

    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
//        let camera = MGLMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 2000, pitch: 15, heading: 0)
//        mapView.fly(to: camera, withDuration: 1,
        //                    peakAltitude: 2000, completionHandler: nil)
        
        let tmp = mapView.convert(CGRect(x: 0, y: 0, width: view.width, height: view.height), toCoordinateBoundsFrom: .none)
        print("tmp")
        print(tmp)

        let sw = tmp.sw
        let ne = tmp.ne
        offset = (ne.latitude - sw.latitude)/5

        let centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude - offset, longitude: annotation.coordinate.longitude)
        mapView.setCenter(centerCoordinate, animated: true)
        


        print(annotation)
        
        if annotation is YorimichiAnnotationViewModel {
            let index = findIndex1(annotation: annotation as! YorimichiAnnotationViewModel)
            print("here================")
            print(index)

            guard let listVC = self.exploreFpc?.contentViewController?.children.first as? ListOnMapLeftViewController else {
                fatalError()
            }
            listVC.tableView.scrollToRow(at: NSIndexPath(row: index, section: 0) as IndexPath, at: .top, animated: true)
        }
        else if annotation is HPAnnotationViewModel {
            let index = findIndex2(annotation: annotation as! HPAnnotationViewModel)
            print("here================")
            print(index)
            guard let listVC = self.exploreFpc?.contentViewController?.children.first as? ListOnMapLeftViewController else {
                fatalError()
            }
            listVC.tableView.scrollToRow(at: NSIndexPath(row: index, section: 0) as IndexPath, at: .top, animated: true)
            
        }

        
    }
    
    private func findIndex1(annotation: YorimichiAnnotationViewModel) -> Int{
        for (i, el) in zip(annotationsYorimichi.indices, annotationsYorimichi){
            if annotation == el {
                return i
            }
        }
        return 0
    }
    
    private func findIndex2(annotation: HPAnnotationViewModel) -> Int{
        for (i, el) in zip(annotationsHP.indices, annotationsHP){
            if annotation == el {
                return i
            }
        }
        return 0
    }
    
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .ended else { return }
        
        
        let spot = gesture.location(in: mapView)
//        guard let userDestinationLocation = mapView.convert(spot, toCoordinateFrom: mapView) else { return }
        
        let tmpMapView: MGLMapView? = mapView
        let userDestinationLocation = mapView.convert(spot, toCoordinateFrom: tmpMapView)
        
        let annotation = DestinationAnnotationViewModel(url: "")
        annotation.title = "Destination"
        
        annotation.coordinate = userDestinationLocation
        annotation.title = "Chosen Destination"
        destinationLocation = userDestinationLocation
        showAnnotation([annotation], isPOI: false)
        
     
    }
    

    private func removeCurrentLocationAnnotation(){
        if let existingAnnotations = mapView.annotations{
            existingAnnotations.forEach{ annotation in
                if annotation is CurrentLocationAnnotationViewModel{
                    mapView.removeAnnotation(annotation)
                }
                    
            }
        }
    }
    
    private func removeSelectedAnnotation(){
        if let existingAnnotations = mapView.annotations{
            existingAnnotations.forEach{ annotation in
                if annotation is SelectedAnnotationViewModel{
                    mapView.removeAnnotation(annotation)
                }
            }
        }
    }
    
    private func removeYorimichiAnnotation(){
        if let existingAnnotations = mapView.annotations{
            existingAnnotations.forEach{ annotation in
                if annotation is YorimichiAnnotationViewModel {
                    mapView.removeAnnotation(annotation)
                }
                    
            }
        }
        
    }
    
    private func removeHPAnnotation(){
        if let existingAnnotations = mapView.annotations{
            existingAnnotations.forEach{ annotation in
                if annotation is HPAnnotationViewModel {
                    mapView.removeAnnotation(annotation)
                }
                    
            }
        }
        
    }
    
    
    private func removeDestinationAnnotation(){
        if let existingAnnotations = mapView.annotations{
            existingAnnotations.forEach{ annotation in
                if annotation is DestinationAnnotationViewModel{
                    mapView.removeAnnotation(annotation)
                }
                    
            }
        }
        
    }
    
    
    

    
    func showAnnotation(_ annotations: [MGLAnnotation], isPOI: Bool) {
        guard !annotations.isEmpty else { return }
        print("\n\n******here")
        print(mapView.annotations)
         
        removeDestinationAnnotation()
        
        mapView.addAnnotations(annotations)
         
        if annotations.count == 1, let annotation = annotations.first {
        mapView.setCenter(annotation.coordinate, zoomLevel: 15, animated: true)
        } else {
        mapView.showAnnotations(annotations, animated: true)
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate{
    
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
    
    private func showCurrentUserLocation(){
        var currentLocationAnnotationViewModel = CurrentLocationAnnotationViewModel(url: "")
        currentLocationAnnotationViewModel.coordinate = userCurrentLocation
        currentLocationAnnotationViewModel.title = "Current Location"
        mapView.addAnnotation(currentLocationAnnotationViewModel)

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation

        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.

       // manager.stopUpdatingLocation()

//        print("user latitude = \(userLocation.coordinate.latitude)")
//        print("user longitude = \(userLocation.coordinate.longitude)")
        userCurrentLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        removeCurrentLocationAnnotation()
        showCurrentUserLocation()
        
        if(centeringCurrentLocation){
            mapView.setCenter(userCurrentLocation, zoomLevel: 15, animated: false)

        }
        centeringCurrentLocation = false
        
        //表示更新
        if let location = locations.first {
            //逆ジオコーディング
            self.geocoder.reverseGeocodeLocation( location, completionHandler: {[weak self] ( placemarks, error ) in
                if let placemark = placemarks?.first {
                    //位置情報
                    guard let prefecture = placemark.administrativeArea,
                          let city = placemark.locality else {
                              return
                          }
                    self?.title = "\(prefecture) \(city)"
//                    self?.locationLabel1.text = placemark.administrativeArea
//                    self?.locationLabel1.sizeToFit()
//
//                    self?.locationLabel2.text = placemark.locality
//                    self?.locationLabel2.sizeToFit()
                }
            })
            
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}


extension MapViewController{
    private func setupFrame(){
//        let goButtonSize: CGFloat = 60
        
        let focusButtonSize: CGFloat = 40
        
        let exploreButtonSize: CGFloat = 55
        let routeButtonSize: CGFloat = 55
        let goButtonSize: CGFloat = 55
        
        let labelOverlap: CGFloat = -8
        
        
        focusButton.frame = CGRect(x: view.right - focusButton.width - 20, y: view.bottom * 0.5, width: focusButtonSize, height: focusButtonSize)
        focusButton.layer.cornerRadius = focusButtonSize/2
        

        
        exploreButton.frame = CGRect(x: 60 - exploreButtonSize/2, y: view.height*3.7/5, width: exploreButtonSize, height: exploreButtonSize)
        exploreButton.layer.cornerRadius = exploreButtonSize/2
        exploreLabel.sizeToFit()
        exploreLabel.frame = CGRect(x: 60 - exploreLabel.width/2 + (exploreButton.width - (exploreLabel.width + 20))/2, y: exploreButton.bottom + labelOverlap, width: exploreLabel.width+20, height: exploreLabel.height+5)
        exploreButton.center.x = view.width/4 - 30
        exploreLabel.center.x = view.width/4 - 30
        
        exploreHPButton.frame = CGRect(x: view.center.x - routeButtonSize/2, y: view.height*3.7/5, width: routeButtonSize, height: routeButtonSize)
        exploreHPButton.layer.cornerRadius = routeButtonSize/2
        exploreHPLabel.sizeToFit()
        exploreHPLabel.frame = CGRect(x: view.center.x - (exploreHPLabel.width+20)/2, y: exploreHPButton.bottom + labelOverlap, width: exploreHPLabel.width+20, height: exploreHPLabel.height+5)
        exploreHPButton.center.x = view.width/4*2
        exploreHPLabel.center.x = view.width/4*2
        
        
        goButton.frame = CGRect(x: view.right - goButtonSize - 40, y: view.height*3.7/5, width: goButtonSize, height: goButtonSize)
        goButton.layer.cornerRadius = goButtonSize/2
        goLabel.sizeToFit()
        goLabel.frame = CGRect(x: view.right - goLabel.width - 10 - 40, y: goButton.bottom + labelOverlap, width: goLabel.width+20, height: goLabel.height+5)
        goButton.center.x = view.width/4*3 + 30
        goLabel.center.x = view.width/4*3 + 30
        
    }
    
}


