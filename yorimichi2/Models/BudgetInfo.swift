//
//  BudgetInfo.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/25.
//

import Foundation

struct Budget: Codable{
    var code: String
    var str: String
}

func mapGooglePriceToString(x: Int) -> String{
    if( x == -1){
        return "記載なし"
    }else if(x == 0){
        return "無料"
    }else if (x == 1){
        return "とても安価"
    }else if (x == 2){
        return "やや安価"
        
    }else if (x == 3){
        return "やや高価"
        
    }else if (x == 4){
        return "高価"
    }
    
    return "データなし"
}
