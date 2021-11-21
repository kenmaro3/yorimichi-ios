//
//  SourceInfo.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/31.
//

import Foundation

let sourceList = [
    "S000",
    "S001",
    "S002",
]

func sourceCodeToString(x: String) -> String{
    if(x == "S000"){
        return "Yorimichi DB"
    }else if(x == "S001"){
        return "Hot Pepper"
    }else if(x == "S002"){
        return "Google"
    }else{
        return ""
    }
    
}
