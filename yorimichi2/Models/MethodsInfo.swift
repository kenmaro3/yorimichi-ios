//
//  MethodsInfo.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/30.
//

import Foundation

struct MethodInfo{
    let code: String
    
    var getSearchString: String {
        let str = methodCodeToString(x: code)
        return str
    }
}

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
