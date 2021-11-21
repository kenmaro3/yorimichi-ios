//
//  PhotoEditInfoCellType.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/09.
//

import Foundation

enum PhotoEditInfoCellType{
    case post(viewModel: PhotoEditInfoPostViewModel)
    case video(viewModel: PhotoEditInfoVideoViewModel)
    case caption
    case location(viewModel: PhotoEditInfoLocationViewModel)
    case genre(viewModel: PhotoEditInfoGenreViewModel)
}
