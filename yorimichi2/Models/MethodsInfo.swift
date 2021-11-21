//
//  MethodsInfo.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/30.
//

import Foundation



let methodList = [
    "M000",
    "M001",
]

func methodCodeToString(x: String) -> String{
    if(x == "M000"){
        return "Walk"
    }else if(x == "M001"){
        return "Drive"
    }else{
        return ""
    }
    
}
