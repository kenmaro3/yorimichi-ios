//
//  Notification.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import Foundation


struct IGNotification: Codable{
    let notificationType: Int // 1: like, 2: comment, 3: follow
    let identifier: String
    let profilePictureUrl: String
    let username: String
    let dateString: String
    
    // Follow/Unfollow
    let isFollowing: Bool?
    
    // Like/Comment
    let postId: String?
    let postUrl: String?
    
}
