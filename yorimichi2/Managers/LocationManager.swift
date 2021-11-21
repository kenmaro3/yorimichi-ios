//
//  LocationManager.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/27.
//

import Foundation
import Mapbox

//class LocationManager{
//    static let shared = LocationManager()
//    private var locationManager:CLLocationManager!
//
//    func getCurrentLocation(){
//
//    }
//
//    func determineMyCurrentLocation() {
//        locationManager = CLLocationManager()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
//        locationManager.requestLocation()
//
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.startUpdatingLocation()
//            locationManager.startUpdatingHeading()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let userLocation:CLLocation = locations[0] as CLLocation
//
//        // Call stopUpdatingLocation() to stop listening for location updates,
//        // other wise this function will be called every time when user location changes.
//
//       // manager.stopUpdatingLocation()
//
////        print("user latitude = \(userLocation.coordinate.latitude)")
////        print("user longitude = \(userLocation.coordinate.longitude)")
//        let userCurrentLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
//
//
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
//    {
//        print("Error \(error)")
//    }
//
//
//}
