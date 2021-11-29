//
//  HotPepperAPIManager.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/01.
//

import Foundation
import UIKit
import Alamofire
import SWXMLHash

final class HotPepperAPIManager{
    static let shared = HotPepperAPIManager()
    
    private init(){}
    
    private let key = "3198bfa20cb8a0e0"
    
    // HotPepper api を呼ぶメイン関数
    func getShops(currentLocation: Location, genre: GenreInfo, completion: @escaping([Shop]) -> Void){
        
        let group = DispatchGroup()
        
        var shops: [Shop] = []
        
        // Getリクエストを送る
        var url = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=\(key)&lat=\(currentLocation.lat)&lng=\(currentLocation.lng)&range=2&order=4"
        
        // もしジャンルがお任せであれば=G000, genreは空白としてクエリを送る
        if(genre.code != "G000" && genre.code != "A000"){
            url += "&genre=\(genre.code)"
        }

        // XML型がレスポンスとして返却される
        print(url)
        group.enter()
        Alamofire.request(url).response{[weak self] response in
            defer{
                group.leave()
            }
            
            if let result = response.data {
                let xml = XMLHash.parse(result)
                print("showing http response at getFromHP ============================================")
//                print(xml)
                
                for shop in xml["results"]["shop"].all{
                    guard let parsedShop = self?.parseShop(x: shop, genre: genre) else {
                        print("falling")
                        return
                    }
                    shops.append(parsedShop)
                }
            }
            
        }
        
        group.notify(queue: .main){
            print(shops)
            completion(shops)
        }
    }
    
    // HotPepperAPIのためのXMLパーサ
    func parseShop(x: XMLIndexer, genre: GenreInfo) -> Shop{
        let shop1_budget = Budget(code: (x["budget"]["code"].element?.text)!, str: (x["budget"]["name"].element?.text)!)
        let lat = (x["lat"].element?.text)!
        let lng = (x["lng"].element?.text)!
        
        
        let shop1 = Shop(
            id: (x["id"].element?.text)!,
            genre: genre,
            name: (x["name"].element?.text)!,
            location: Location(lat: CGFloat(NSString(string: lat).floatValue), lng: CGFloat(NSString(string: lng).floatValue)),
            info: (x["genre"]["catch"].element?.text)!,
            budget: shop1_budget,
            postUrlString: (x["photo"]["pc"]["l"].element?.text)!,
            jumpUrl: (x["urls"]["pc"].element?.text)!,
            image: UIImage()
        )
        
        return shop1
    }
}
