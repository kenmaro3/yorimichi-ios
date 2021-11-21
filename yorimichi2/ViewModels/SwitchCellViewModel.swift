//
//  SwitchCellViewModel.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/06.
//

import Foundation

enum SwitchType{
    case photo
    case video
}


struct SwitchCellViewModel{
    let title: String
    var isOn: Bool
    let type: SwitchType
    
    mutating func setOn(_ on: Bool){
        self.isOn = on
    }
}
