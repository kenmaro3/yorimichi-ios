//
//  RequestsToBackendUtils.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/25.
//

//import Foundation
//import Mapbox
//import Alamofire
//import SWXMLHash
//
//
////// HotPepperAPIのためのXMLパーサ
////func parseShop(x: XMLIndexer, currentLocation: CLLocationCoordinate2D, selectedGenre: String) -> Shop{
////    let shop1_shop = (x["name"].element?.text)!
////    let shop1_photo = Image(url: (x["photo"]["pc"]["l"].element?.text)!)
////    let shop1_logo = Image(url: (x["logo_image"].element?.text)!)
////    let shop1_time = Time(openingHours: (x["open"].element?.text)!, closingHours: (x["close"].element?.text)!)
////    let shop1_budget = Budget(code: (x["budget"]["code"].element?.text)!, str: (x["budget"]["name"].element?.text)!)
////    let shop1_info = (x["genre"]["catch"].element?.text)!
////    let lat = (x["lat"].element?.text)!
////    let lng = (x["lng"].element?.text)!
////    let jumpUrl = (x["urls"]["pc"].element?.text)!
////    let id = (x["id"].element?.text)!
////    let type = "hotpepper"
////    var location = CLLocationCoordinate2D()
////    //var genre = Genre(code: selectedGenre, name: genreCodeToString(x: selectedGenre))
////    var genre = GenreInfo(code: selectedGenre)
////
////    location.latitude = Double(lat)!
////    location.longitude = Double(lng)!
////    //var distance = round(currentLocation.distance(to: location))
////    var distance = 100.0
////    
////    
////    let shop1 = Shop(shop: shop1_shop, photo: shop1_photo, logo: shop1_logo, info: shop1_info, time: shop1_time, budget: shop1_budget, coordinate: Coordinate(ido: NSString(string: lat).floatValue, keido:NSString(string: lng).floatValue), jumpUrl:jumpUrl, id: id, type: type, distance: distance, genre: genre)
////    
////    return shop1
////}
//
//
//
//
//// ユーザのスワイプ履歴をログとして記録する（分析目的）
//func addSwipe(swipeInfo: SwipeInfo){
//    let baseUrl = "https://us-central1-tinder-clone-mern-91837.cloudfunctions.net/api/"
//    let searchUrl = "\(baseUrl)swipe"
//    let parameters: [String: String] = ["userId": swipeInfo.userId, "shopId": swipeInfo.shopId, "searchType": swipeInfo.searchType, "action": swipeInfo.action]
//
////    var parameters: [[String: String]]
////
////    for i in 0..<swipeInfos.count{
////        var tmp_parameter: [String: String] = ["userId": swipeInfos[i].userId, "shopId": swipeInfos[i].shopId, "searchType": swipeInfos[i].searchType, "action": swipeInfos[i].action]
////        parameters.append(tmp_parameter)
////
////
////    }
//    
//        
//    let headers: HTTPHeaders = ["Content-Type": "application/json"]
//    Alamofire.request(searchUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
//        guard let data = response.data else {
//            return
//        }
//        do {
//            print("showing http response at addSwipe ============================================")
//            print(data)
//
//
//        } catch let error {
//            print("Error: \(error)")
//        }
//    }
//}
//
//// ユーザの現在地をログとして記録する（分析目的）
//func addLocation(locationInfo: LocationInfo){
//    let baseUrl = "https://us-central1-tinder-clone-mern-91837.cloudfunctions.net/api/"
//    let searchUrl = "\(baseUrl)location"
//    let parameters: [String: Any] = ["userId": locationInfo.userId, "lat": locationInfo.lat, "lng": locationInfo.lng]
//    let headers: HTTPHeaders = ["Content-Type": "application/json"]
//    Alamofire.request(searchUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
//        guard let data = response.data else {
//            return
//        }
//        do {
//            print("showing http response at addLocation ============================================")
//            print(data)
//
//
//        } catch let error {
//            print("Error: \(error)")
//        }
//    }
//}
//
//// ユーザの目的地をログとして記録する（分析目的）
//func addDestination(locationInfo: LocationInfo){
//    let baseUrl = "https://us-central1-tinder-clone-mern-91837.cloudfunctions.net/api/"
//    let searchUrl = "\(baseUrl)destination"
//    let parameters: [String: Any] = ["userId": locationInfo.userId, "lat": locationInfo.lat, "lng": locationInfo.lng]
//    let headers: HTTPHeaders = ["Content-Type": "application/json"]
//    Alamofire.request(searchUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
//        guard let data = response.data else {
//            return
//        }
//        do {
//            print("showing http response at addDestination ============================================")
//            print(data)
//
//
//        } catch let error {
//            print("Error: \(error)")
//        }
//    }
//}
//
//
////// HotPepper api を呼ぶメイン関数
////func getFromHP(currentLocation: CLLocationCoordinate2D, selectedGenre: String, closure_append: @escaping(Shop) -> Void){
////    
////    // Getリクエストを送る
////    var url = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=3198bfa20cb8a0e0&lat=\(currentLocation.latitude)&lng=\(currentLocation.longitude)&range=2&order=4"
////    
////    // もしジャンルがお任せであれば=G000, genreは空白としてクエリを送る
////    if(selectedGenre != "G000"){
////        url += "&genre=\(selectedGenre)"
////    }
////
////    // XML型がレスポンスとして返却される
////    print(url)
////            Alamofire.request(url).response{ response in
////                if let result = response.data {
////                   let xml = XMLHash.parse(result)
////                    print("showing http response at getFromHP ============================================")
////                    print(xml)
////
////                    for shop in xml["results"]["shop"].all{
////                        let parsedShop = parseShop(x: shop, currentLocation: currentLocation, selectedGenre: selectedGenre)
////                        closure_append(parsedShop)
////                    }
////                }
////                
////            }
////}
//
//
////// google place api を呼ぶメイン関数
////func getFromGoogle(currentLocation: Location, selectedGenre: String, distance: Int, completion: @escaping([Shop]) -> Void){
////
////    // Getリクエストを送る
////    let baseUrl = "https://us-central1-tinder-clone-mern-91837.cloudfunctions.net/api/"
////    let searchUrl = "\(baseUrl)getShop"
////    let genreString = genreCodeToString(x: selectedGenre);
////    // Getリクエストのパラメター
////    let parameters: [String: Any] = ["lat": String(currentLocation.latitude), "lng": String(currentLocation.longitude), "radius": String(distance), "keyword": genreString]
////
////    // Json型がレスポンスとして返却される
////    let headers: HTTPHeaders = ["Content-Type": "application/json, text/plain;charset=utf-8"]
////
////
////    Alamofire.request(searchUrl, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: headers).responseJSON { response in
////        guard let data = response.data else {
////            return
////        }
////        do {
////            print("showing http response at getFromGoogle ============================================")
////            print(selectedGenre)
////            print(data)
////            let responseString = String(data: data, encoding: .utf8)
////            let tmp = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
////
////            // TmpShopクラスに一旦パース
////            let tmpShops = try? JSONDecoder.init().decode([TmpShop].self, from: data)
////
////            // TmpShopからShopクラスに変換
////            convertTmpShopToShop(x: tmpShops!, currentLocation: currentLocation, selectedGenre: selectedGenre, {shops in
////                completion(shops)
////            })
////
////        } catch let error {
////            print("Error: \(error)")
////        }
////
////    }
////}
