//
//  ProfileHeaderViewModel.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/21.
//

import Foundation

enum ProfileButtonType{
    case edit
    case follow(isFollowing: Bool)
}

struct ProfileHeaderViewModel{
    let profilePictureUrl: URL?
    let followerCount: Int
    let followingCount: Int
    let postsCount: Int
    let bio: String?
    let name: String?
    let buttonType: ProfileButtonType
    let twitterId: String?
    let instagramId: String?
    
}
