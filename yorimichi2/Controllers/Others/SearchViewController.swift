//
//  SearchViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/27.
//

import UIKit
import Mapbox
import MapboxSearchUI
import MapboxSearch

protocol SearchViewControllerDelegate: AnyObject{
    func searchViewControllerDidTapLeave()
}

class SearchViewController: UIViewController {
    
    weak var delegate: SearchViewControllerDelegate?
    
    var searchController = MapboxSearchController()
    lazy var panelController = MapboxPanelController(rootViewController: searchController)
    
    private var centeringCurrentLocation: Bool = true
    
    
    // locationManager で現在地を取得する
    private var locationManager:CLLocationManager!
    
    private var userCurrentLocation = CLLocationCoordinate2D()
    

    
    private let focusButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "location.fill", withConfiguration:  UIImage.SymbolConfiguration(pointSize: 22))
        button.backgroundColor = UIColor.systemGray.withAlphaComponent(0.5)
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    
    private let mapView: MGLMapView = {
        let map = MGLMapView()
        let url = URL(string: "mapbox://styles/mapbox/streets-v11")
        map.styleURL = url
        return map

    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(mapView)
        view.addSubview(focusButton)

        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 40.74699, longitude: -73.98742), zoomLevel: 9, animated: false)
        mapView.showsUserLocation = true
        mapView.showsUserHeadingIndicator = true
         
        mapView.setCenter(userCurrentLocation, zoomLevel: 15, animated: false)
         
         
        // Set the map view's delegate
        mapView.delegate = self
         
        // Allow the map view to display the user's location
        mapView.showsUserLocation = true
        
//        mapView.layer.zPosition = 1
//        goButton.layer.zPosition = 2
//        focusButton.layer.zPosition = 2
        
        if(centeringCurrentLocation){
            determineMyCurrentLocation()
            print("VIEW WILL APPEAR")
        }
        

        focusButton.addTarget(self, action: #selector(didTapFocus), for: .touchUpInside)
        
        searchController.delegate = self
        addChild(panelController)

        
    }

    @objc func didTapClose(){
        dismiss(animated: true, completion: nil)
        delegate?.searchViewControllerDidTapLeave()
    }
    
    func showAnnotation(_ annotations: [MGLAnnotation], isPOI: Bool) {
        guard !annotations.isEmpty else { return }
         
        if let existingAnnotations = mapView.annotations {
        mapView.removeAnnotations(existingAnnotations)
        }
        mapView.addAnnotations(annotations)
         
        if annotations.count == 1, let annotation = annotations.first {
        mapView.setCenter(annotation.coordinate, zoomLevel: 15, animated: true)
        } else {
        mapView.showAnnotations(annotations, animated: true)
        }
    }
    

    
    @objc private func didTapFocus(){
        print("focus tapped")
        mapView.setCenter(userCurrentLocation, zoomLevel: 15, animated: true)
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mapView.frame = view.bounds
        
        let focusButtonSize: CGFloat = 40
        
        focusButton.frame = CGRect(x: view.right - focusButton.width - 20, y: view.bottom * 0.5, width: focusButtonSize, height: focusButtonSize)
        focusButton.layer.cornerRadius = focusButtonSize/2
    }

}

extension SearchViewController: MGLMapViewDelegate{
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }
     
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        let camera = MGLMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 2000, pitch: 15, heading: 0)
        mapView.fly(to: camera, withDuration: 1,
                    peakAltitude: 2000, completionHandler: nil)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        // "mapbox://examples.2uf7qges" is a map ID referencing a tileset. For more
        // more information, see mapbox.com/help/define-map-id/


    }
    
}

extension SearchViewController: CLLocationManagerDelegate{
    
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

        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.

       // manager.stopUpdatingLocation()

//        print("user latitude = \(userLocation.coordinate.latitude)")
//        print("user longitude = \(userLocation.coordinate.longitude)")
        userCurrentLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        if(centeringCurrentLocation){
            mapView.setCenter(userCurrentLocation, zoomLevel: 15, animated: false)

        }
        centeringCurrentLocation = false
        
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
}

extension SearchViewController{
    private func updateYorimichiNameAndLocation(name: String, location: CLLocationCoordinate2D){
        print("called")
        print(name)
        print(location)
        UserDefaults.standard.setValue(name, forKey: "yorimichiPostName")
        UserDefaults.standard.setValue("\(location.latitude)", forKey: "yorimichiPostCoordinateLat")
        UserDefaults.standard.setValue("\(location.longitude)", forKey: "yorimichiPostCoordinateLng")
        
    }
}

extension SearchViewController: SearchControllerDelegate {
    func categorySearchResultsReceived(results: [SearchResult]) {
        let annotations = results.map { searchResult -> MGLPointAnnotation in
            let annotation = MGLPointAnnotation()
            annotation.coordinate = searchResult.coordinate
            annotation.title = searchResult.name
            annotation.subtitle = searchResult.address?.formattedAddress(style: .medium)
            return annotation
    }
     
    showAnnotation(annotations, isPOI: false)
    }
     
    func searchResultSelected(_ searchResult: SearchResult) {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = searchResult.coordinate
        annotation.title = searchResult.name
        annotation.subtitle = searchResult.address?.formattedAddress(style: .medium)
        updateYorimichiNameAndLocation(name: searchResult.name, location: searchResult.coordinate)
         
        showAnnotation([annotation], isPOI: searchResult.type == .POI)
    }
     
    func userFavoriteSelected(_ userFavorite: FavoriteRecord) {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = userFavorite.coordinate
        annotation.title = userFavorite.name
        annotation.subtitle = userFavorite.address?.formattedAddress(style: .medium)
         
        showAnnotation([annotation], isPOI: true)
        updateYorimichiNameAndLocation(name: userFavorite.name, location: userFavorite.coordinate)
    }
}
