//
//  Notification.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import Foundation

enum PostType: Codable{
    case photo
    case video
}

struct IGNotification: Codable{
    let notificationType: Int // 1: like, 2: comment, 3: follow
    let identifier: String
    let profilePictureUrl: String
    let username: String
    let dateString: String
    
    // Like/Comment
    let postId: String?
    let postUrl: String?
    let postType: PostType?
    
    var date: Date{
        return DateFormatter.formatter.date(from: dateString) ?? Date()
    }
    
}
