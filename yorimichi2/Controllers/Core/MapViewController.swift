//
//  MapViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import UIKit
import Mapbox
//import MapboxSearchUI
//import MapboxSearch
import SDWebImage
import FloatingPanel
import StoreKit
import ProgressHUD
import MapKit
//import MapboxDirections
//import MapboxCoreNavigation
//import MapboxNavigation
//import Turf

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

//    private var routeOptions: NavigationRouteOptions?
//    private var routes: [Route]?
//    private var route: Route?
//
//    var currentRoute: Route? {
//        get {
//        return routes?.first
//        }
//        set {
//        guard let selected = newValue else { routes?.remove(at: 0); return }
//        guard let routes = routes else { self.routes = [selected]; return }
//        self.routes = [selected] + routes.filter { $0 != selected }
//        }
//    }
    
    
    var exploreFpc: FloatingPanelController!
    
    private var annotationsYorimichi: [YorimichiAnnotationViewModel] = []
    private var annotationsHP: [HPAnnotationViewModel] = []
    
    private var annotationsGoogle: [GoogleAnnotationViewModel] = []
    
    private var annotationsSelected: [SelectedAnnotationViewModel] = []
    private var annotationsLikes: [LikesAnnotationViewModel] = []
    
    private var middleListCells: [ListExploreResultCellType] = []
    private var rightListCells: [ListYorimichiLikesCellType] = []

    
    private var offset: CGFloat = 0.0
    
    private let imageTop: CGFloat = 60
    
    let geocoder = CLGeocoder()
    
//    var searchController = MapboxSearchController()
//    lazy var panelController = MapboxPanelController(rootViewController: searchController)
    
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
    
//    private let exploreGoogleButton: UIButton = {
//        let button = UIButton()
//        button.tintColor = .black
//        let image = UIImage(systemName: "globe", withConfiguration:  UIImage.SymbolConfiguration(pointSize: 22))
//        button.backgroundColor = .clear
//        button.layer.borderWidth = 5
//        button.setImage(image, for: .normal)
//        button.layer.borderColor = UIColor.white.cgColor
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowRadius = 6
//        button.layer.shadowOffset = CGSize(width: 0, height: 0)
//        button.layer.shadowOpacity = 0.5
//        //button.layer.backgroundColor = UIColor.systemGray.cgColor
//        button.layer.backgroundColor = UIColor.hex(string: "#F2F2F2", alpha: 1.0).cgColor
//
//        return button
//    }()
//
//
//
//    private let exploreGoogleLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.text = "グーグル検索"
//        label.textColor = .black
//        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
//        label.backgroundColor = UIColor.hex(string: "#F2F2F2", alpha: 1.0)
//        label.clipsToBounds = true
//        label.textAlignment = .center
//        label.layer.shadowColor = UIColor.black.cgColor
//        label.layer.shadowRadius = 10
//        label.layer.shadowOffset = CGSize(width: 0, height: 0)
//        label.layer.shadowOpacity = 0.5
//        label.layer.cornerRadius = 10
//
//        return label
//    }()
    
//    private let routeButton: UIButton = {
//        let button = UIButton()
//        button.tintColor = .black
//        let image = UIImage(systemName: "map", withConfiguration:  UIImage.SymbolConfiguration(pointSize: 22))
//        button.backgroundColor = UIColor.systemGray.withAlphaComponent(0.5)
//        button.layer.borderColor = UIColor.white.cgColor
//        button.layer.borderWidth = 5
//        button.setImage(image, for: .normal)
//
//        button.layer.borderColor = UIColor.white.cgColor
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowRadius = 6
//        button.layer.shadowOffset = CGSize(width: 0, height: 0)
//        button.layer.shadowOpacity = 0.5
//        button.layer.backgroundColor = UIColor.hex(string: "#F2F2F2", alpha: 1.0).cgColor
//
//        return button
//    }()
//
//    private let routeLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.text = "経路を検索"
//        label.textColor = .black
//        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
//        label.backgroundColor = UIColor.hex(string: "#F2F2F2", alpha: 1.0)
//        label.clipsToBounds = true
//        label.textAlignment = .center
//        label.layer.cornerRadius = 10
//
//        return label
//    }()
//
//    private let goButton: UIButton = {
//        let button = UIButton()
//        button.tintColor = .black
//        let image = UIImage(systemName: "forward.fill", withConfiguration:  UIImage.SymbolConfiguration(pointSize: 22))
//        button.backgroundColor = UIColor.systemGray.withAlphaComponent(0.5)
//        button.layer.borderColor = UIColor.white.cgColor
//        button.layer.borderWidth = 5
//        button.setImage(image, for: .normal)
//
//        button.layer.borderColor = UIColor.white.cgColor
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowRadius = 6
//        button.layer.shadowOffset = CGSize(width: 0, height: 0)
//        button.layer.shadowOpacity = 0.5
//        button.layer.backgroundColor = UIColor.hex(string: "#F2F2F2", alpha: 1.0).cgColor
//
//        return button
//    }()
//
//    private let goLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.text = "出発する"
//        label.textColor = .black
//        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
//        label.backgroundColor = UIColor.hex(string: "#F2F2F2", alpha: 1.0)
//        label.clipsToBounds = true
//        label.textAlignment = .center
//        label.layer.cornerRadius = 10
//
//        return label
//    }()
    
    
//    private let mapView: NavigationMapView = {
    private let mapView: MGLMapView = {
        //let map = NavigationMapView()
        let map = MGLMapView()
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
        
        resetDestinationNameAndLocation()
        
        
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
            self?.removeOnlyCandidateYorimichi()
            self?.addCandidatesAnnotation()
        }
        
    }
    
//    func setUpRouteOption(waypoints: [Waypoint]){
//        guard let transportationMethod = UserDefaults.standard.string(forKey: "methods") else {
//            return
//        }
//
//        if (transportationMethod.lowercased() == "walk"){
//            routeOptions = NavigationRouteOptions(waypoints: waypoints, profileIdentifier: .walking)
//
//        }
//        else if(transportationMethod.lowercased() == "drive"){
//            routeOptions = NavigationRouteOptions(waypoints: waypoints, profileIdentifier: .automobile)
//
//        }
//        else if(transportationMethod.lowercased() == "cycling"){
//            routeOptions = NavigationRouteOptions(waypoints: waypoints, profileIdentifier: .cycling)
//
//        }
//        else{
//            fatalError("unknown transportation method")
//        }
//
//    }
//
//
//    private func showRoute(){
//        guard let routeOptions = routeOptions else {
//            return
//        }
//        Directions.shared.calculate(routeOptions) { [weak self] (session, result) in
//            switch result {
//                case .failure(let error):
//                print(error.localizedDescription)
//                case .success(let response):
//                guard let routes = response.routes, let strongSelf = self else {
//                    return
//                }
//                strongSelf.routeOptions = routeOptions
//                strongSelf.routes = routes
//                strongSelf.goButton.isHidden = false
//                strongSelf.mapView.show(routes)
//                strongSelf.mapView.showWaypoints(on: strongSelf.currentRoute!)
//            }
//        }
//    }
//
//    // 描画のための経路検索
//    func requestRouteNormal() {
//        // Requirements
//        // with destination and Yorimichi Both exist
//
//        guard let destinationLocation = destinationLocation else {
//            return
//        }
//
//        let origin = Waypoint(coordinate: userCurrentLocation, name: "start")
//
//        let destination = Waypoint(coordinate: destinationLocation, name: "end")
//
//        var navigationArray = [Waypoint]()
//
//        navigationArray.append(origin)
//
//
//
//        for (i, location) in zip(selectedAnnotationsLocation.indices, selectedAnnotationsLocation){
//            let tmp = Waypoint(coordinate: location, name: "yori_\(i)")
//            navigationArray.append(tmp)
//        }
//        navigationArray.append(destination)
//
//
//        setUpRouteOption(waypoints: navigationArray)
//        showRoute()
//    }
//
//    // 描画のための経路検索
//    func requestRouteOnlyDestination() {
//        // Requirements
//        // with destination and Yorimichi Both exist
//
//        guard let destinationLocation = destinationLocation else {
//            return
//        }
//
//        let origin = Waypoint(coordinate: userCurrentLocation, name: "start")
//
//        let destination = Waypoint(coordinate: destinationLocation, name: "end")
//
//        var navigationArray = [Waypoint]()
//        navigationArray.append(origin)
//        navigationArray.append(destination)
//
//        setUpRouteOption(waypoints: navigationArray)
//        showRoute()
//    }
//
//    // 描画のための経路検索
//    func requestRouteOnlyYorimichi() {
//        // Requirements
//        // with destination and Yorimichi Both exist
//
//
//        let origin = Waypoint(coordinate: userCurrentLocation, name: "start")
//
//
//        var navigationArray = [Waypoint]()
//
//        navigationArray.append(origin)
//
//
//
//        for (i, location) in zip(selectedAnnotationsLocation.indices, selectedAnnotationsLocation){
//            let tmp = Waypoint(coordinate: location, name: "yori_\(i)")
//            navigationArray.append(tmp)
//        }
//
//        setUpRouteOption(waypoints: navigationArray)
//        showRoute()
//    }
    
//    @objc private func didTapLaunch(){
//        // Pass the first generated route to the the NavigationViewController
//        guard let option = routeOptions,
//              let route = currentRoute
//        else {
//            AlertManager.shared.presentError(title: "ナビゲーションエラー", message: "経路が設定されていません。", completion: {[weak self] alert in
//                self?.present(alert, animated: true)
//
//            })
//            return
//        }
//        let viewController = NavigationViewController(for: route, routeIndex: 0, routeOptions: option)
//        viewController.modalPresentationStyle = .fullScreen
//        present(viewController, animated: true, completion: nil)
//    }
    
    
    @objc private func didTapSettings(){
        print("tapped")
        let vc = MapSettingsViewController()
        present(UINavigationController(rootViewController: vc), animated: true)
        
    }
    
    private func setupSearch(){
        (searchController.searchResultsController as? SearchResultsViewController)?.delegate = self
        
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
            case .hp(_), .google(_):
                tmpMiddleListCells.append($0)
            case .yorimichiDB(_):
                break
            }
        })
        middleListCells = tmpMiddleListCells
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        removeOnlyCandidateYorimichi()
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
//        view.addSubview(exploreGoogleButton)
//        view.addSubview(exploreGoogleLabel)
//        view.addSubview(routeButton)
//        view.addSubview(routeLabel)
//        view.addSubview(goButton)
//        view.addSubview(goLabel)
    }
    
    
    private func addButtonTarget(){
        focusButton.addTarget(self, action: #selector(didTapFocus), for: .touchUpInside)
        exploreButton.addTarget(self, action: #selector(didTapExplore), for: .touchUpInside)
        exploreHPButton.addTarget(self, action: #selector(didTapExploreHP), for: .touchUpInside)
//        exploreGoogleButton.addTarget(self, action: #selector(didTapExploreGoogle), for: .touchUpInside)
//        routeButton.addTarget(self, action: #selector(didTapRoute), for: .touchUpInside)
//        goButton.addTarget(self, action: #selector(didTapLaunch), for: .touchUpInside)
    }
    
    
//    @objc private func didTapRoute(){
//        if let routes = routes {
//            self.routes = nil
//            mapView.removeRoutes()
//            return
//        }
//        print("\n\ndidTapRoute=========")
//        print(annotationsSelected)
//
//        if annotationsSelected.count == 0 {
//            if let destinationLocation = destinationLocation {
//                requestRouteOnlyDestination()
//            }
//            else{
//                AlertManager.shared.presentError(title: "経路検索エラー", message: "目的地とヨリミチどちらも設定されていません。", completion: {[weak self] alert in
//                    self?.present(alert, animated: true)
//
//                })
//            }
//        }
//        else{
//
//            selectedAnnotationsLocation = annotationsSelected.map{
//                $0.coordinate
//            }
//
//            if let destinationLocation = destinationLocation {
//                requestRouteNormal()
//
//            }
//            else{
//                requestRouteOnlyYorimichi()
//            }
//
//        }
//    }
    
    
    @objc private func didTapExplore(){
        print("tap explore")
        removeYorimichiAnnotation()
        removeHPAnnotation()
        removeGoogleAnnotation()
        exploreWithYorimichiDB()
    }
    
    @objc private func didTapExploreHP(){
        print("tap explore")
        removeYorimichiAnnotation()
        removeHPAnnotation()
        removeGoogleAnnotation()
        exploreWithHP()
    }
    
//    @objc private func didTapExploreGoogle(){
//        print("tap explore")
//        removeYorimichiAnnotation()
//        removeHPAnnotation()
//        removeGoogleAnnotation()
//        exploreWithGoogle()
//    }
    
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
    
//    private func exploreWithGoogle(){
//        guard let genre = UserDefaults.standard.string(forKey: "genre") else {
//            return
//        }
//        if !(foodGenreList.contains(genreDisplayStringToCode(x: genre))){
//            AlertManager.shared.presentError(title: "検索ジャンルエラー", message: "Google検索はフードジャンルのみ実行可能です。", completion: {[weak self] alert in
//                self?.present(alert, animated: true)
//                return
//            })
//        }
//
//        ProgressHUD.show("検索しています...")
//        let refLocation = Location(lat: mapView.centerCoordinate.latitude, lng: mapView.centerCoordinate.longitude)
//        GoogleAPIManager.shared.getShops(
//            location: refLocation,
//            genre: GenreInfo(code: genreDisplayStringToCode(x: genre), type: .food),
//            radius: 500,
//            size: 5,
//            completion: {[weak self] shops in
//                self?.googleShopsToAnnotations(shops: shops, completion: {[weak self] annotations in
//                    print("debug0")
//                    print(annotations)
//                    self?.annotationsGoogle.removeAll()
//                    for annotation in annotations{
//                        self?.annotationsGoogle.append(annotation)
//                    }
//                    self?.mapView.addAnnotations(annotations)
//                    let cellTypes = annotations.map({
//                        ListExploreResultCellType.google(viewModel: $0)
//                    })
//                    if (cellTypes.isEmpty){
//                        AlertManager.shared.presentError(title: "場所が見つかりませんでした。", message: "ジャンルもしくは場所を変更して検索してください。", completion: { alert in
//
//                            self?.present(alert, animated: true)
//                        })
//                        ProgressHUD.dismiss()
//                        return
//                    }
//                    let vc = ListExploreResultViewController(
//                        viewModels: cellTypes
//                    )
//                    ProgressHUD.dismiss()
//                    guard let listVC = self?.exploreFpc.contentViewController as? ListOnMapViewController else {
//                        fatalError()
//                    }
//                    listVC.updateLeft(with: cellTypes)
//
//                    self?.exploreFpc.move(to: .full, animated: true, completion: nil)
//                })
//            })
//    }
    
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
    
    public func addGoogleCandidateAnnotation(shop: Shop){
        guard let listVC = self.exploreFpc.contentViewController as? ListOnMapViewController else {
            fatalError()
        }
        self.googleShopsToAnnotations(shops: [shop], completion: {[weak self] annotations in
            let cellTypes = annotations.map({
                ListExploreResultCellType.google(viewModel: $0)
            })
            guard let strongSelf = self else {
                return
            }
            strongSelf.middleListCells = strongSelf.middleListCells + cellTypes
            
            print(strongSelf.middleListCells)
            listVC.updateMiddle(with: strongSelf.middleListCells)
            self?.middleListCells = strongSelf.middleListCells
            
            
            
        })
            
        self.googleShopsToSelectdAnnotations(shops: [shop], completion: {[weak self] annotations in
            for annotation in annotations{
                self?.annotationsSelected.append(annotation)
            }
            self?.mapView.addAnnotations(annotations)
            
        })
    }
    
    private func googleShopsToAnnotations(shops: [Shop], completion: @escaping ([GoogleAnnotationViewModel]) -> Void){
        let tmpAnnotationsGoogle: [GoogleAnnotationViewModel] = shops.map({
            let annotation = GoogleAnnotationViewModel(id: $0.id, image: $0.image, shop: $0)
            annotation.title = $0.name
            annotation.subtitle = $0.info
            let lat = $0.location.lat
            let lng = $0.location.lng
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
            return annotation
        })
        completion(tmpAnnotationsGoogle)
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
    
    private func googleShopsToSelectdAnnotations(shops: [Shop], completion: @escaping ([SelectedAnnotationViewModel]) -> Void){
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
        removeGoogleAnnotation()
        exploreFpc.removePanelFromParent(animated: true, completion: nil)
    }


    
    @objc private func didTapFriends(){
        removeYorimichiAnnotation()
        removeHPAnnotation()
        removeGoogleAnnotation()
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

extension MapViewController: SearchResultsViewControllerDelegate{
    func searchResultsViewController(_ vc: SearchResultsViewController, didSelectResultsUser user: User) {
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// when user hit the keyboard key
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsVC = searchController.searchResultsController as? SearchLocationResultsViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            return
        }
        
        searchCompleter.queryFragment = query
        
//        DatabaseManager.shared.findUsers(with: query){ results in
//            resultsVC.update(with: results)
//        }
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

//extension MapViewController: NavigationViewControllerDelegate {
//    // Show an alert when arriving at the waypoint and wait until the user to start next leg.
//    func navigationViewController(_ navigationViewController: NavigationViewController, didArriveAt waypoint: Waypoint) -> Bool {
//        let isFinalLeg = navigationViewController.navigationService.routeProgress.isFinalLeg
//        if isFinalLeg {
//            return true
//        }
//
//        let alert = UIAlertController(title: "ヨリミチ先 \(waypoint.name ?? "Unknown")　に到着しました。", message: "ナビゲーションを再開しますか?", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
//            // Begin the next leg once the driver confirms
//            if !isFinalLeg {
//                navigationViewController.navigationService.routeProgress.legIndex += 1
//                navigationViewController.navigationService.start()
//            }
//        }))
//        navigationViewController.present(alert, animated: true, completion: nil)
//
//        return false
//    }
//
//    func navigationViewControllerDidDismiss(_ navigationViewController: NavigationViewController, byCanceling canceled: Bool) {
//        dismiss(animated: true, completion: nil)
//    }
//}




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
                    case .google(let vm):
                        if(vm.id == viewModel.id){
                        }
                        else{
                            tmpMiddleListCells.append(.google(viewModel: vm))
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
    
    func ListOnMapMiddleViewControllerDidGoogleDoubleTapped(_ cell: ListExploreResultGoogleTableViewCell, didTapPostWith viewModel: GoogleAnnotationViewModel) {
        print("google tapped")
        let actionSheet = UIAlertController(
            title: "ヨリミチ先の消去",
            message: "ヨリミチ候補を消去しますか？",
            preferredStyle: .actionSheet
        )
        
        actionSheet.addAction(UIAlertAction(title: "いいえ", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "はい", style: .destructive, handler: { [weak self] _ in
            DispatchQueue.main.async {
                guard let cellTitle = viewModel.title
                else {
                    return
                }
                // Removing Annotation from Map
                if let annotations = self?.mapView.annotations {
                    annotations.forEach{
                        if let title = $0.title as? String {
                            if(title == cellTitle){
                                self?.mapView.removeAnnotation($0)
                                
                            }
                        }
                        else{
//
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
                    case .google(let vm):
                        if(vm.id == viewModel.id){
                        }
                        else{
                            tmpMiddleListCells.append(.google(viewModel: vm))
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
    
    func listOnMapLeftViewControllerDidGoogleDoubleTapped(_ cell: ListExploreResultGoogleTableViewCell, didTapPostWith viewModel: GoogleAnnotationViewModel) {
        ProgressHUD.showAdded("ヨリミチ候補に追加されました。")
        addGoogleCandidateAnnotation(shop: viewModel.shop)
    }
    
    func listOnMapViewControllerDidTapYorimichiButton(id: String, viewModel: ListExploreResultCellType) {
        
        switch viewModel{
        case .yorimichiDB(viewModel: let viewModel):
            findIndexFromIdYorimichi(id: id, completion: {[weak self] index in
                self?.mapView.selectAnnotation(
                    annotationsYorimichi[index],
                    animated: true,
                    completionHandler: nil)
                
                guard let listVC = self?.exploreFpc.contentViewController as? ListOnMapViewController else {
                    fatalError()
                }
                
                
            })
                
        case .google(viewModel: let viewModel):
            findIndexFromIdGoogle(id: id, completion: {[weak self] index in
                self?.mapView.selectAnnotation(
                    annotationsYorimichi[index],
                    animated: true,
                    completionHandler: nil)
                
                let annotation = SelectedAnnotationViewModel(id: viewModel.id)
                annotation.title = self?.annotationsYorimichi[index].title
                annotation.subtitle = self?.annotationsYorimichi[index].subtitle
                guard let coordinate = self?.annotationsYorimichi[index].coordinate else {
                    return
                }
                annotation.coordinate = coordinate
                
    
                self?.mapView.addAnnotation(annotation)
                
            })
            
        case .hp(viewModel: let viewModel):
            findIndexFromIdHP(id: id, completion: {[weak self] index in
                self?.mapView.selectAnnotation(
                    annotationsYorimichi[index],
                    animated: true,
                    completionHandler: nil)
                
                let annotation = SelectedAnnotationViewModel(id: viewModel.id)
                annotation.title = self?.annotationsYorimichi[index].title
                annotation.subtitle = self?.annotationsYorimichi[index].subtitle
                guard let coordinate = self?.annotationsYorimichi[index].coordinate else {
                    return
                }
                annotation.coordinate = coordinate
                
                self?.mapView.addAnnotation(annotation)
                
            })
            
        }
    }
    
    private func findIndexFromIdYorimichi(id: String, completion: (Int) -> Void){
        for (i, el) in zip(annotationsYorimichi.indices, annotationsYorimichi){
            print("\(id), \(el.post.id)")
            if id == el.post.id {
                completion(i)
            }
        }
    }
                            
    private func findIndexFromIdGoogle(id: String, completion: (Int) -> Void){
        for (i, el) in zip(annotationsGoogle.indices, annotationsGoogle){
            if id == el.shop.id {
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
            
        case .google(let viewModel):
//            mapView.selectAnnotation(annotationsGoogle[index], animated: true, completionHandler: nil)
            
            let targetAnnotations = annotationsGoogle.filter{
                $0.id == viewModel.id
            } as? [GoogleAnnotationViewModel]
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
            
        case .google(let viewModel):
            let targetAnnotations = annotationsSelected.filter{
                $0.id == viewModel.id
            } as? [SelectedAnnotationViewModel]
            if let targetAnnotation = targetAnnotations?[0] {
                mapView.selectAnnotation(targetAnnotation, animated: true, completionHandler: nil)
                
            }
            
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
            else if annotation is GoogleAnnotationViewModel{
                // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
                let tmpAnnotation = annotation as! GoogleAnnotationViewModel
                let reuseIdentifier = "\(annotation.coordinate.longitude)"
                
                // For better performance, always try to reuse existing annotations.
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: GoogleAnnotationView.identifier) as? GoogleAnnotationView
                
                annotationView = GoogleAnnotationView(reuseIdentifier: reuseIdentifier)
                annotationView?.configure(with: tmpAnnotation.image)
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
        else if annotation is GoogleAnnotationViewModel {
            let index = findIndex3(annotation: annotation as! GoogleAnnotationViewModel)
            print("here================")
            guard let listVC = self.exploreFpc?.contentViewController?.children.first as? ListOnMapLeftViewController else {
                fatalError()
            }
            let tmpVC = exploreFpc.contentViewController as! ListOnMapViewController
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
    
    private func findIndex3(annotation: GoogleAnnotationViewModel) -> Int{
        for (i, el) in zip(annotationsGoogle.indices, annotationsGoogle){
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
    
    private func removeGoogleAnnotation(){
        if let existingAnnotations = mapView.annotations{
            existingAnnotations.forEach{ annotation in
                if annotation is GoogleAnnotationViewModel {
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
    private func putGradient(){
        
        // Parse GeoJSON data. This example uses all M1.0+ earthquakes from 12/22/15 to 1/21/16 as logged by USGS' Earthquake hazards program.
        guard let url = URL(string: "https://www.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson") else { return }
        let source = MGLShapeSource(identifier: "earthquakes", url: url, options: nil)
        mapView.style?.addSource(source)
         
        // Create a heatmap layer.
        let heatmapLayer = MGLHeatmapStyleLayer(identifier: "earthquakes", source: source)
         
        // Adjust the color of the heatmap based on the point density.
        let colorDictionary: [NSNumber: UIColor] = [
        0.0: .clear,
        0.01: .white,
        0.15: UIColor(red: 0.19, green: 0.30, blue: 0.80, alpha: 1.0),
        0.5: UIColor(red: 0.73, green: 0.23, blue: 0.25, alpha: 1.0),
        1: .yellow
        ]
        heatmapLayer.heatmapColor = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($heatmapDensity, 'linear', nil, %@)", colorDictionary)
         
        // Heatmap weight measures how much a single data point impacts the layer's appearance.
        heatmapLayer.heatmapWeight = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:(mag, 'linear', nil, %@)",
        [0: 0,
        6: 1])
         
        // Heatmap intensity multiplies the heatmap weight based on zoom level.
        heatmapLayer.heatmapIntensity = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
        [0: 1,
        9: 3])
        heatmapLayer.heatmapRadius = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
        [0: 4,
        9: 30])
         
        // The heatmap layer should be visible up to zoom level 9.
        heatmapLayer.heatmapOpacity = NSExpression(format: "mgl_step:from:stops:($zoomLevel, 0.75, %@)", [0: 0.75, 9: 0])
        mapView.style?.addLayer(heatmapLayer)
         
        // Add a circle layer to represent the earthquakes at higher zoom levels.
        let circleLayer = MGLCircleStyleLayer(identifier: "circle-layer", source: source)
         
        let magnitudeDictionary: [NSNumber: UIColor] = [
        0: .white,
        0.5: .yellow,
        2.5: UIColor(red: 0.73, green: 0.23, blue: 0.25, alpha: 1.0),
        5: UIColor(red: 0.19, green: 0.30, blue: 0.80, alpha: 1.0)
        ]
        circleLayer.circleColor = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:(mag, 'linear', nil, %@)", magnitudeDictionary)
         
        // The heatmap layer will have an opacity of 0.75 up to zoom level 9, when the opacity becomes 0.
        circleLayer.circleOpacity = NSExpression(format: "mgl_step:from:stops:($zoomLevel, 0, %@)", [0: 0, 9: 0.75])
        circleLayer.circleRadius = NSExpression(forConstantValue: 20)
        mapView.style?.addLayer(circleLayer)
        
        var coordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 35.6880488, longitude: 139.702560),
            CLLocationCoordinate2D(latitude: 35.91, longitude: 139.902560),
        ]
        let polyline = MGLPolylineFeature(coordinates: &coordinates, count: UInt(coordinates.count))
        let source2 = MGLShapeSource(identifier: "lines", features: [polyline], options: nil)
        mapView.style?.addSource(source2)
        let layerm = MGLLineStyleLayer(identifier: "my-style", source: source2)
        mapView.style?.addLayer(layerm)
        
        let source3 = MGLVectorTileSource(identifier: "trees", configurationURL: URL(string: "mapbox://examples.2uf7qges")!)
         
        mapView.style?.addSource(source3)
         
        let layer = MGLCircleStyleLayer(identifier: "tree-style", source: source3)
         
        // The source name from the source's TileJSON metadata: mapbox.com/api-documentation/maps/#retrieve-tilejson-metadata
        layer.sourceLayerIdentifier = "yoshino-trees-a0puw5"
         
        // Stops based on age of tree in years.
        let stops = [
        0: UIColor(red: 1.00, green: 0.72, blue: 0.85, alpha: 1.0),
        2: UIColor(red: 0.69, green: 0.48, blue: 0.73, alpha: 1.0),
        4: UIColor(red: 0.61, green: 0.31, blue: 0.47, alpha: 1.0),
        7: UIColor(red: 0.43, green: 0.20, blue: 0.38, alpha: 1.0),
        16: UIColor(red: 0.33, green: 0.17, blue: 0.25, alpha: 1.0)
        ]
         
        // Style the circle layer color based on the above stops dictionary.
        layer.circleColor = NSExpression(format: "mgl_step:from:stops:(AGE, %@, %@)", UIColor(red: 1.0, green: 0.72, blue: 0.85, alpha: 1.0), stops)
         
        layer.circleRadius = NSExpression(forConstantValue: 3)
         
        mapView.style?.addLayer(layer)

    }
    
    private func resetDestinationNameAndLocation(){
        UserDefaults.standard.setValue(nil, forKey: "destinationName")
        UserDefaults.standard.setValue(nil, forKey: "destinationCoordinateLat")
        UserDefaults.standard.setValue(nil, forKey: "destinationCoordinateLng")
        
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
        exploreButton.center.x = view.width/3
        exploreLabel.center.x = view.width/3
        
        exploreHPButton.frame = CGRect(x: view.center.x - routeButtonSize/2, y: view.height*3.7/5, width: routeButtonSize, height: routeButtonSize)
        exploreHPButton.layer.cornerRadius = routeButtonSize/2
        exploreHPLabel.sizeToFit()
        exploreHPLabel.frame = CGRect(x: view.center.x - (exploreHPLabel.width+20)/2, y: exploreHPButton.bottom + labelOverlap, width: exploreHPLabel.width+20, height: exploreHPLabel.height+5)
        exploreHPButton.center.x = view.width/3*2
        exploreHPLabel.center.x = view.width/3*2
        
        
//        exploreGoogleButton.frame = CGRect(x: view.right - goButtonSize - 40, y: view.height*3.7/5, width: goButtonSize, height: goButtonSize)
//        exploreGoogleButton.layer.cornerRadius = goButtonSize/2
//        exploreGoogleLabel.sizeToFit()
//        exploreGoogleLabel.frame = CGRect(x: view.right - exploreGoogleLabel.width - 10 - 40, y: exploreGoogleButton.bottom + labelOverlap, width: exploreGoogleLabel.width+20, height: exploreGoogleLabel.height+5)
//        exploreGoogleLabel.center.x = view.right - 60
//        exploreGoogleLabel.center.x = view.right - 60
        
//        routeButton.frame = CGRect(x: view.center.x - routeButtonSize/2, y: view.height*3.7/5, width: routeButtonSize, height: routeButtonSize)
//        routeButton.layer.cornerRadius = routeButtonSize/2
//        routeLabel.sizeToFit()
//        routeLabel.frame = CGRect(x: view.center.x - (routeLabel.width+20)/2, y: routeButton.bottom + labelOverlap, width: routeLabel.width+20, height: routeLabel.height+5)
//
//
//        goButton.frame = CGRect(x: view.right - goButtonSize - 40, y: view.height*3.7/5, width: goButtonSize, height: goButtonSize)
//        goButton.layer.cornerRadius = goButtonSize/2
//        goLabel.sizeToFit()
//        goLabel.frame = CGRect(x: view.right - goLabel.width - 10 - 40, y: goButton.bottom + labelOverlap, width: goLabel.width+20, height: goLabel.height+5)
//        goButton.center.x = view.right - 60
//        goLabel.center.x = view.right - 60
        
    }
    
}


