//
//  Shop.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import Foundation
import UIKit

struct Coordinate: Codable  {
    var ido: Float
    var keido: Float
}

struct YrmcItem: Codable {
    var info: String
    var coordinate: Coordinate
    var name: String
    var imagePath: String
    var category: String
}

struct YrmcList: Decodable  {
    var data: [YrmcItem]
}

struct Shop{
    var id: String
    var genre: GenreInfo
    var name: String
    var location: Location
    var info: String
    var budget: Budget
    let postUrlString: String
    var jumpUrl: String
    var image: UIImage
}

struct TmpShop: Decodable{
    var name: String?;
    var open_now: Bool?;
    var photo_ref: String?;
    var id: String?;
    var price_level: Int?;
    var vicinity: String?;
    var user_ratings_total: Int?;
    var rating: Float?;
    var lat: Float?;
    var lng: Float?;
    
    private enum CodingKeys: String, CodingKey {
        case name
        case open_now
        case id
        case price_level
        case vicinity
        case user_ratings_total
        case rating
        case photo_ref
        case lat
        case lng
        
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = container.contains(.name) ? try container.decode(String?.self, forKey: .name) : nil
        open_now = container.contains(.open_now) ? try container.decode(Bool?.self, forKey: .open_now) : nil
        id = container.contains(.id) ? try container.decode(String?.self, forKey: .id) : nil
        price_level = container.contains(.price_level) ? try container.decode(Int?.self, forKey: .price_level) : nil
        vicinity = container.contains(.vicinity) ? try container.decode(String?.self, forKey: .vicinity) : nil
        user_ratings_total = container.contains(.user_ratings_total) ? try container.decode(Int?.self, forKey: .user_ratings_total) : nil
        rating = container.contains(.rating) ? try container.decode(Float?.self, forKey: .rating) : nil
        photo_ref = container.contains(.photo_ref) ? try container.decode(String?.self, forKey: .photo_ref) : nil
        lat = container.contains(.lat) ? try container.decode(Float?.self, forKey: .lat) : nil
        lng = container.contains(.lng) ? try container.decode(Float?.self, forKey: .lng) : nil
//
        
        
    }
}
