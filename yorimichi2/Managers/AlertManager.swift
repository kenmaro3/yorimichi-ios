//
//  AlertManager.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/11.
//

import Foundation
import UIKit
import SafariServices

class AlertManager{
    static let shared = AlertManager()
    
    public func presentError(title: String, message: String, completion: @escaping (UIAlertController) -> Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        completion(alert)
    }
    
}
