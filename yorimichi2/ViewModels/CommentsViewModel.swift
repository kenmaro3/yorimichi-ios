//
//  CommentsViewModel.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/08.
//

import Foundation


enum CommentsSourceType{
    case photo(viewModel: Post)
    case video(viewModel: Post)
}

struct CommentsViewModel{
    let type: CommentsSourceType
    
}
