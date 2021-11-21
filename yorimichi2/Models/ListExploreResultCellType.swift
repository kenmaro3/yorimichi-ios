//
//  ListExploreResultCellType.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/01.
//

import Foundation


enum ListExploreResultCellType{
    case yorimichiDB(viewModel: YorimichiAnnotationViewModel)
    case google(viewModel: GoogleAnnotationViewModel)
    case hp(viewModel: HPAnnotationViewModel)
    
}
