//
//  SinglePostShopCellType.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/26.
//

import Foundation

//enum SinglePostShopEditCellType{
//    case post(viewModel: PostCollectionViewCellViewModel)
//    case caption(viewModel: PostEditCaptionCollectionViewCellViewModel)
//    case name(viewModel: PostEditNameCollectionViewCellViewModel)
//    case location(viewModel: PostEditLocationCollectionViewCellViewModel)
//    case additionalLocation(viewModel: PostEditAdditionalLocationCollectionViewCellViewModel)
//    case info(viewModel: PostEditInfoCollectionViewCellViewModel)
//    case rating(viewModel: PostEditRatingCollectionViewCellViewModel)
//}

enum SingleYorimichiPostEditCellType{
    case post
    case captionHeader
    case caption
    case nameHeader
    case name
    case genreHeader
    case genre
    case locationHeader
    case location
    case additionalLocationHeader
    case additionalLocation
    case infoHeader
    case info
    case ratingHeader
    case rating
}

enum SingleYorimichiPostShowCellType{
//    case poster(viewModel: PosterCollectionViewCellViewModel)
    case post(viewModel: PostCollectionViewCellViewModel)
    case actions(viewModel: PostActionsCollectionViewCellViewModel)
    case likeCount(viewModel: PostLikesCollectionViewCellViewModel)
//    case caption(viewModel: PostCaptionCollectionViewCellViewModel)
    case timestamp(viewModel: PostDatetimeCollectionViewCellViewModel)
    case comment(viewModel: PostComment)
    case name(viewModel: PostNameCollectionViewCellViewModel)
    case location(viewModel: PostLocationCollectionViewCellViewModel)
    case additionalLocation(viewModel: PostAdditionalLocationCollectionViewCellViewModel)
    case info(viewModel: PostInfoCollectionViewCellViewModel)
    case rating(viewModel: PostRatingCollectionViewCellViewModel)
}
