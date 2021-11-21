//
//  NotificationCellViewModels.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import Foundation

struct LikeNotificationCellViewModel: Equatable{
    let username: String
    let profilePictureUrl: URL
    let postUrl: URL
    let date: String
    
}

struct FollowNotificationCellViewModel: Equatable{
    let username: String
    let profilePictureUrl: URL
    let isCurrentUserFollowing: Bool
    let date: String
}

struct CommentNotificationCellViewModel: Equatable{
    let username: String
    let profilePictureUrl: URL
    let postUrl: URL
    let date: String
    
}
