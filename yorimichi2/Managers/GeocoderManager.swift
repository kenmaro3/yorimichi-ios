//
//  GeocoderManager.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/02.
//

import Foundation
import CoreLocation
import ProgressHUD

class GeocoderManager{
    static let shared = GeocoderManager()
    
    private init(){}
    
    let geocoder = CLGeocoder()
    
    public func getAddressFromLocation(location: Location, completion: @escaping (AddressInfo) -> Void){
        
        let tmpLocation: CLLocation = CLLocation(latitude: location.lat, longitude: location.lng)

        //逆ジオコーディング
        geocoder.reverseGeocodeLocation( tmpLocation, completionHandler: {[weak self] ( placemarks, error ) in
            if let placemark = placemarks?.first {
                //位置情報
                
                let info = AddressInfo(
                    name: placemark.name,
                    country: placemark.country,
                    postalCode: placemark.postalCode,
                    administrativeArea: placemark.administrativeArea,
                    subAdministrativeArea: placemark.subAdministrativeArea,
                    locality: placemark.locality,
                    subLocality: placemark.subLocality,
                    subThoroughfare: placemark.subThoroughfare
                )
                
                completion(info)
            }
            else{
                completion(AddressInfo(name: nil, country: nil, postalCode: nil, administrativeArea: nil, subAdministrativeArea: nil, locality: nil, subLocality: nil, subThoroughfare: nil))
            }
        })
        completion(AddressInfo(name: nil, country: nil, postalCode: nil, administrativeArea: nil, subAdministrativeArea: nil, locality: nil, subLocality: nil, subThoroughfare: nil))
        
    }
    
    public func getLocationFromAddress(address: String, completion: @escaping(Location?) -> Void){
        
        var searchWord = address
        var arr:[String] = address.components(separatedBy: ",")
        if (arr.count > 3){
            var shorten = arr[..<3]
            searchWord = shorten.joined(separator: ",")
        }
        CLGeocoder().geocodeAddressString(searchWord) { placemarks, error in

            guard let lat = placemarks?.first?.location?.coordinate.latitude,
                  let lng = placemarks?.first?.location?.coordinate.longitude else{
                      completion(nil)
                      return
                  }
            
            let location = Location(lat: lat, lng: lng)
            completion(location)
            return
        }

    }
    
    
    

}
