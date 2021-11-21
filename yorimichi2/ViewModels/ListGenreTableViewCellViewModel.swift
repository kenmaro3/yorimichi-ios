//
//  ListGenreTableViewCellViewModel.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/25.
//

import Foundation
import UIKit

struct GenreSection{
    let title: String
    let options: [GenreOption]
    
}

struct GenreOption{
    let title: String
    let image: UIImage
}
