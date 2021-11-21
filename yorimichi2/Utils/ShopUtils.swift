//
//  ShopUtils.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/25.
//

//import Foundation
//import UIKit
//import Firebase
//import FirebaseStorage
//import SWXMLHash
//import Mapbox
//import Alamofire
//
//
//class Image{
//    var url: String
//    var image: UIImageView
//    
//    init(url:String, loadImage: Bool=true){
//        self.url = url
//        self.image = UIImageView()
//        if(loadImage){
//            //self.image.image = UIImage(url: url)
//            self.image.image = UIImage()
//        }else{
//            
//        }
//        
//    }
//}
//
//
//
//struct Time{
//    var openingHours: String
//    var closingHours: String
//}
//
//
//func parseShopHP(x: XMLIndexer, currentLocation: CLLocationCoordinate2D, selectedGenre: String) -> Shop{
//    let shop1_shop = (x["name"].element?.text)!
//    let shop1_photo = Image(url: (x["photo"]["mobile"]["l"].element?.text)!)
//    let shop1_logo = Image(url: (x["logo_image"].element?.text)!)
//    let shop1_time = Time(openingHours: (x["open"].element?.text)!, closingHours: (x["close"].element?.text)!)
//    let shop1_budget = Budget(code: (x["budget"]["code"].element?.text)!, str: (x["budget"]["name"].element?.text)!)
//    let shop1_info = (x["genre"]["catch"].element?.text)!
//    let lat = (x["lat"].element?.text)!
//    let lng = (x["lng"].element?.text)!
//    let jumpUrl = (x["urls"]["pc"].element?.text)!
//    let id = (x["id"].element?.text)!
//    let type = "hotpepper";
//    var location = CLLocationCoordinate2D()
//    location.latitude = Double(lat)!
//    location.longitude = Double(lng)!
//    //var shop_distance = round(currentLocation.distance(to: location))
//    var shop_distance = 100.0
//    //var genre = Genre(code: selectedGenre, name: genreCodeToString(x: selectedGenre))
//    var genre = GenreInfo(code: selectedGenre)
//    
//    
//    
//    
//    let shop1 = Shop(shop: shop1_shop, photo: shop1_photo, logo: shop1_logo, info: shop1_info, time: shop1_time, budget: shop1_budget, coordinate: Coordinate(ido: NSString(string: lat).floatValue, keido:NSString(string: lng).floatValue), jumpUrl:jumpUrl, id: id, type: type, distance: shop_distance, genre: genre)
//    
//    let shop1 = Shop(
//        id: (x["name"].element?.text)!,
//        genre: <#T##GenreInfo#>,
//        name: <#T##String#>,
//        location: <#T##Location#>,
//        info: <#T##String#>,
//        time: <#T##Time#>,
//        budget: <#T##Budget#>,
//        postUrlString: <#T##String#>,
//        jumpUrl: <#T##String#>,
//        image:
//    )
//    
//    return shop1
//}
//
//
