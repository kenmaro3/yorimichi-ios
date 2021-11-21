//
//  GoogleAPIManager.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/25.
//

import Foundation
import UIKit
import Alamofire

final class GoogleAPIManager{
    static let shared = GoogleAPIManager()
    
    private init(){}
    
    private let baseUrl = "https://us-central1-tinder-clone-mern-91837.cloudfunctions.net/api/"
    private let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    
    private var locationStr = "&location=35.7147758,139.6766393"
    private var radiusStr = "&radius=1000&language=ja"
    private var keywordStr = "&keyword=居酒屋"
    
    private let key = "AIzaSyDejxy3rs8ZhDyinwSrXsbXGIfo8C79gK4"
    
    
    
    public func getShops(location: Location, genre: GenreInfo, radius: CGFloat, size: Int, completion: @escaping ([Shop]) -> Void){
        
        let searchUrl = "\(baseUrl)getShop"
        
        // Getリクエストのパラメター
        let parameters: [String: Any] = ["lat": "\(location.lat)", "lng": "\(location.lng)", "radius": "\(radius)", "keyword": genre.getSearchString]
        
        // Json型がレスポンスとして返却される
        let headers: HTTPHeaders = ["Content-Type": "application/json, text/plain;charset=utf-8"]
        
        print("will call")
        Alamofire.request(searchUrl, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: headers).responseJSON { response in
            guard let data = response.data else {
                print("called and failed")
                return
            }
            
            do{
                let responseString = String(data: data, encoding: .utf8)
                let tmp = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                
                // TmpShopクラスに一旦パース
                let tmpShops = try? JSONDecoder.init().decode([TmpShop].self, from: data)
                
                // TmpShopからShopクラスに変換
                self.convertTmpShopToShop(x: tmpShops!, currentLocation: location, genre: genre, size: size, completion: { shops in
                    
                    completion(shops)
                })
                
            }catch let error{
                print(error)
                completion([])
            }
            
            
        }
        
    }
    
    func convertTmpShopToShop(x: [TmpShop], currentLocation: Location, genre: GenreInfo, size: Int, completion: @escaping( [Shop]) -> Void) -> Void{
        
        let group = DispatchGroup()
        
        var tmp_shops = [Shop]()
        
        var displaySize = size
        if size >= x.count{
            displaySize = x.count - 1
        }
        
        if (displaySize == 0 || displaySize == -1){
            completion(tmp_shops)
            return
        }
        
        for i in 0..<displaySize{
            group.enter()
            var shop_shop = x[i].name ?? "";
//            var shop_photo = Image(url: "", loadImage: false);
//            var shop_logo = Image(url: "", loadImage: false);
            
            var tmp_opening = x[i].open_now ?? true;
            var tmp_closing = x[i].open_now ?? true;
            
        
            
//            var shop_time = Time(openingHours: tmp_opening ? "営業中" : "営業時間外", closingHours: tmp_closing ? "営業中" : "営業時間外")
                

            var shop_budget = Budget(code: "", str: mapGooglePriceToString(x: x[i].price_level ?? -1))
            var shop_info = "Google Rating: "
            var shop_id = x[i].id ?? "";
            var shop_type = "google"
            if(x[i].rating != nil){
                shop_info += String(x[i].rating!);
            }else{
                shop_info += "情報なし";
            }
        
//            var shop_coordinate = Coordinate(ido: (x[i].lat)!, keido: (x[i].lng)!);
            let location = Location(lat: CGFloat((x[i].lat)!), lng: CGFloat((x[i].lng)!))
            guard let x_lat = x[i].lat,
                  let x_lng = x[i].lng else{
                      return
                  }
//            var targetLocation = CLLocation(latitude: x_lat.double, longitude: x_lng.double)
//            var shop_distance = round(currentLocation.getLocation.distance(from: targetLocation))
            //var shop_distance = 100.0

            
            let baseUrl = "https://us-central1-tinder-clone-mern-91837.cloudfunctions.net/api/"
            let searchUrl = "\(baseUrl)getImage"
            let parameters: [String: Any] = ["reference" : (x[i].photo_ref ?? "")]
            let headers: HTTPHeaders = ["Content-Type": "application/json, text/plain;charset=utf-8"]
            
            
            if (x[i].photo_ref != nil){
                Alamofire.request(searchUrl, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: headers).responseJSON { response in
                    defer{
                        group.leave()
                    }
                    guard let data = response.data else {
                        return
                    }
                    do {
                        let dataDecoded : Data = Data(base64Encoded: data, options: .ignoreUnknownCharacters)!
                        let decodedimage = UIImage(data: dataDecoded)
//                        shop_photo.image.image = decodedimage!;
                        
//                        var shop = Shop(shop: shop_shop, photo: shop_photo, logo: shop_logo, info: shop_info, time: shop_time, budget: shop_budget, coordinate: shop_coordinate, jumpUrl:"", id:shop_id, type:shop_type, distance: shop_distance, genre: genre)
                        let shop = Shop(
                            id: shop_id,
                            genre: genre,
                            name: shop_shop,
                            location: location,
                            info: shop_info,
                            budget: shop_budget,
                            postUrlString: "",
                            jumpUrl: "",
                            image: decodedimage!
                        )
                        tmp_shops.append(shop)
                        print(tmp_shops.count)
                        

                    } catch let error {
                        print("Error: \(error)")
                    }
                }
            }
        }
        group.notify(queue: .main){
            completion(tmp_shops)
        }
        
        
    //    closure_append(tmp_shops)

        
        
    }

}

