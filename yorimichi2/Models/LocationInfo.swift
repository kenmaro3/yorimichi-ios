//
//  LocationInfo.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/25.
//

import Foundation
import UIKit
import CoreLocation

struct LocationInfo : Codable{
   var userId: String
   var lat: String
   var lng: String
}

struct Location: Codable{
    let lat: CGFloat
    let lng: CGFloat
    
    var getCoord: CLLocationCoordinate2D {
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        return coord
    }
    
    var getLocation: CLLocation{
        let location = CLLocation(latitude: lat, longitude: lng)
        return location
    }
    
    var toString: String{
        return "\(lat), \(lng)"
    }
}
