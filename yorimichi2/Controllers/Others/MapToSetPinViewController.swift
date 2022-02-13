
import UIKit
import Mapbox
import SDWebImage
import FloatingPanel
import StoreKit
import ProgressHUD
import MapKit

protocol MapToSetPinViewControllerDelegate: AnyObject{
    func mapToSetPinViewControllerDidDecide(location: CLLocationCoordinate2D)
}

class MapToSetPinViewController: UIViewController, MGLMapViewDelegate{
    weak var delegate: MapToSetPinViewControllerDelegate?
    

    public var centeringCurrentLocation: Bool = true
    // locationManager で現在地を取得する
    private var locationManager:CLLocationManager!
    
    
    // For Requesting Route
    private var userCurrentLocation = CLLocationCoordinate2D()
    
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
    
    private let decideButton: UIButton = {
        let decideButton = UIButton()
        decideButton.setTitle("決定", for: .normal)
        decideButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        decideButton.setTitleColor(.black, for: .normal)
        decideButton.addTarget(self, action: #selector(didTapDetermine), for: .touchUpInside)
        
        decideButton.layer.borderWidth = 2.0
        decideButton.layer.borderColor = UIColor.black.cgColor
        decideButton.backgroundColor = UIColor(red: 50, green:50, blue: 50, alpha: 0.9)
        decideButton.layer.masksToBounds = true
        decideButton.layer.cornerRadius = 5
        return decideButton
        
    }()
    
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "長押しして場所を選択"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.layer.borderWidth = 2.0
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 50, green: 50, blue: 50, alpha: 0.8)
        
        return label
    }()
    

    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]

        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setMapCenter()
        
        addSubViews()
        
        // Set the map view's delegate
        mapView.delegate = self
        setLongGesture()
        
        decideButton.addTarget(self, action: #selector(didTapDetermine), for: .touchUpInside)

        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: decideButton)
    }
    
    @objc private func didTapDetermine(){
        print("determined")
        
        var setLocation = CLLocationCoordinate2D()
        guard let setLatitude = mapView.annotations?[0].coordinate.latitude,
              let setLongitude = mapView.annotations?[0].coordinate.longitude else {
                  print("falled")
                  return
        }
        setLocation.latitude = setLatitude
        setLocation.longitude = setLongitude

        delegate?.mapToSetPinViewControllerDidDecide(location: setLocation)
        navigationController?.popViewController(animated: true)
   }
    
    
    private func setLongGesture(){
        // 長押しのジェスチャーを認識する関数
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        mapView.addGestureRecognizer(gesture)
        
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
        //mapView.showAnnotations([annotation], animated: true)
        
        mapView.annotations?.forEach{
            mapView.removeAnnotation($0)
        }
        showAnnotation([annotation], isPOI: false)
        
     
    }
    
    func showAnnotation(_ annotations: [MGLAnnotation], isPOI: Bool) {
        guard !annotations.isEmpty else { return }
        print("\n\n******here")
        print(mapView.annotations)
         
        mapView.addAnnotations(annotations)
         
        if annotations.count == 1, let annotation = annotations.first {
        mapView.setCenter(annotation.coordinate, zoomLevel: 15, animated: true)
        } else {
        mapView.showAnnotations(annotations, animated: true)
        }
    }
    
    private func setMapCenter(){
        mapView.setCenter(userCurrentLocation, zoomLevel: 12, animated: true)
        
        if(centeringCurrentLocation){
            
            determineMyCurrentLocation()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    private func addSubViews(){
        view.addSubview(mapView)
        view.addSubview(label)
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
        decideButton.frame = CGRect(x: 0, y: 20, width: 100, height: 50)
        label.sizeToFit()
        
        let labelWidth: CGFloat = label.width + 50
        let labelHeight: CGFloat = label.height + 50
        label.frame = CGRect(x: view.center.x - labelWidth/2, y: 100, width: labelWidth, height: labelHeight)
        
    
    }

}


extension MapToSetPinViewController: CLLocationManagerDelegate{
    
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
        
        
        if(centeringCurrentLocation){
            mapView.setCenter(userCurrentLocation, zoomLevel: 12, animated: true)
            showCurrentUserLocation()

            

        }
        centeringCurrentLocation = false
        
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}



