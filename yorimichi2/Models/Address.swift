//
//  Address.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/02.
//

import Foundation


struct AddressInfo{
    let name: String?
    let country: String?
    let postalCode: String?
    let administrativeArea: String?
    let subAdministrativeArea: String?
    let locality: String?
    let subLocality: String?
    let subThoroughfare: String?
    
    var toStringShort: String? {
        var res = ""
        if let subLocality = subLocality {
            res += " \(subLocality)"
        }
        if let subThoroughfare = subThoroughfare {
            res += " \(subThoroughfare)"
        }
        
        return res
    }
    
}
