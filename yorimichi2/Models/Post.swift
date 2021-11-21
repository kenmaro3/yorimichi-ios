//
//  Post.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import Foundation

struct Post: Codable{
    let id: String
    let caption: String
    let locationTitle: String
    let locationSubTitle: String
    let location: Location
    let postedDate: String
    var likers: [String]
    var yorimichi: [String]
    let postUrlString: String
    let postThumbnailUrlString: String
    let genre: GenreInfo
    let user: User
    let isVideo: Bool
    
    
    var storageReference: String? {
        return "yorimichiData/\(genre.code)/\(id).png"
    }
    
    var videoChildPath: String{
        return "\(user.username.lowercased())/videos/\(id).mov"
    }
    
    var videoThumbnailChildPath: String{
        return "\(user.username.lowercased())/videos/\(id).png"
    }
    
    var date: Date{
        return DateFormatter.formatter.date(from: postedDate) ?? Date()
    }
}
