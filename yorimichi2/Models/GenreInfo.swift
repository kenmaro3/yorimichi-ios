//
//  GenreInfo.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/25.
//

import Foundation
import UIKit

enum GenreType: Codable{
    case other
    case food
    case spot
    case shop
}

struct GenreInfo: Codable, Hashable{
    let code: String
    let type: GenreType

    var getSearchString: String {
        switch type{
        case .other:
            let str = otherGenreCodeToString(x: code)
            return str
        case .food:
            let str = foodGenreCodeToString(x: code)
            return str
        case .shop, .spot:
            return ""
            
        }
    }

    var getDisplayString: String {
        let str = genreCodeToDisplayString(x: code)
        return str
    }
}


let otherGenreList = [
    "A000"
]


let foodGenreList = [
    // フード
    "G000", // フードおまかせ
    "G001", // 居酒屋
    "G002", // (ダイニングバー) OR (バル)
    "G003", // 創作料理
    "G004", // 和食
    "G005", // 洋食
    "G006", // (イタリアン) OR (フレンチ)
    "G007", // 中華
    "G008", // 焼肉
    "G009", // アジア料理
    "G010", // 各国料理
    "G011", // カラオケ
    "G012", // バー
    "G013", // ラーメン
    "G014", // カフェ
    "G015", // その他グルメ
    "G016", // お好み焼き
    "G017" // 韓国料理
    
]

let spotGenreList = [
    // スポット
    "S001", // 自然
    "S002", // デートスポット
    "S003", // ファミリースポット
    "S004" // イベント
]

let shopGenreList = [
    // お買い物情報
    "P001" // セール情報
]

func otherGenreCodeToString(x: String) -> String{
    if(x == "A000"){
        return "全て"
    }
    else{
        fatalError("Genre Unknown Code")
    }
}

func foodGenreCodeToString(x: String) -> String{
    if(x == "G000"){
        return "フードおまかせ"
    }else if(x == "G001"){
        return "居酒屋"
    }else if(x == "G002"){
        return "(ダイニングバー) OR (バル)"
    }else if(x == "G003"){
        return "創作料理"
    }else if(x == "G004"){
        return "和食"
    }else if(x == "G005"){
        return "洋食"
    }else if(x == "G006"){
        return "(イタリアン) OR (フレンチ)"
    }else if(x == "G007"){
        return "中華"
    }else if(x == "G008"){
        return "焼肉"
    }else if(x == "G009"){ return "アジア料理"
    }else if(x == "G010"){
        return "各国料理"
    }else if(x == "G011"){
        return "カラオケ"
    }else if(x == "G012"){
        return "バー"
    }else if(x == "G013"){
        return "ラーメン"
    }else if(x == "G014"){
        return "カフェ"
    }else if(x == "G015"){
        return "その他グルメ"
    }else if(x == "G016"){
        return "お好み焼き"
    }else if(x == "G017"){
        return "韓国料理"
    }
    
    else{
        fatalError("Genre Unknown Code")
    }
}

func spotGenreCodeToDisplayString(x: String) -> String{
    if(x == "S001"){
        return "自然"
    }else if(x == "S002"){
        return "デートスポット"
    }else if(x == "S003"){
        return "ファミリースポット"
    }else if(x == "S004"){
        return "イベント"
    }
    else{
        fatalError("Genre Unknown Code")
    }
}

func shopGenreCodeToDisplayString(x: String) -> String {
    if(x == "P001"){
        return "セール情報"
    }
    else{
        fatalError("Genre Unknown Code")
    }
}


func otherGenreCodeToDisplayString(x: String) -> String{
    if(x == "A000"){
        return "なんでも"
    }
    else{
        fatalError("Genre Unknown Code")
    }
}

func genreCodeToDisplayString(x: String) -> String{
    if(x == "A000"){
        return "なんでも"
    }else if(x == "G000"){
        return "フードおまかせ"
    }else if(x == "G001"){
        return "居酒屋"
    }else if(x == "G002"){
        return "ダイニングバー, バル"
    }else if(x == "G003"){
        return "創作料理"
    }else if(x == "G004"){
        return "和食"
    }else if(x == "G005"){
        return "洋食"
    }else if(x == "G006"){
        return "イタリアン, フレンチ"
    }else if(x == "G007"){
        return "中華"
    }else if(x == "G008"){
        return "焼肉"
    }else if(x == "G009"){
        return "アジア料理"
    }else if(x == "G010"){
        return "各国料理"
    }else if(x == "G011"){
        return "カラオケ"
    }else if(x == "G012"){
        return "バー"
    }else if(x == "G013"){
        return "ラーメン"
    }else if(x == "G014"){
        return "カフェ"
    }else if(x == "G015"){
        return "その他グルメ"
    }else if(x == "G016"){
        return "お好み焼き"
    }else if(x == "G017"){
        return "韓国料理"
    }else if(x == "S001"){
        return "自然"
    }else if(x == "S002"){
        return "デートスポット"
    }else if(x == "S003"){
        return "ファミリースポット"
    }else if(x == "S004"){
        return "イベント"
    }else if(x == "P001"){
        return "セール情報"
    }
    else{
        fatalError("Genre Unknown Code")
    }
    
}

func genreDisplayStringToCode(x: String) -> String{
    if (x == "なんでも"){
        return "A000"
    }else if (x == "フードおまかせ"){
        return "G000"
    }else if(x == "居酒屋"){
        return "G001"
    }else if(x == "ダイニングバー, バル"){
        return "G002"
    }else if(x == "創作料理"){
        return "G003"
    }else if(x == "和食"){
        return "G004"
    }else if(x == "洋食"){
        return "G005"
    }else if(x == "イタリアン, フレンチ"){
        return "G006"
    }else if(x == "中華"){
        return "G007"
    }else if(x == "焼肉"){
        return "G008"
    }else if(x == "アジア料理"){
        return "G009"
    }else if(x == "各国料理"){
        return "G010"
    }else if(x == "カラオケ"){
        return "G011"
    }else if(x == "バー"){
        return "G012"
    }else if(x == "ラーメン"){
        return "G013"
    }else if(x == "カフェ"){
        return "G014"
    }else if(x == "その他グルメ"){
        return "G015"
    }else if(x == "お好み焼き"){
        return "G016"
    }else if(x == "韓国料理"){
        return "G017"
    }else if(x == "自然"){
        return "S001"
    }else if(x == "デートスポット"){
        return "S002"
    }else if(x == "ファミリースポット"){
        return "S003"
    }else if(x == "イベント"){
        return "S004"
    }else if(x == "セール情報"){
        return "P001"
    }else{
        fatalError("Genre Unknown Display String")
    }
    
}
