//
//  ProfileSegmentedCollectionViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2022/01/22.
//

import UIKit

class ProfileSegmentedCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProfileSegmentedCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemRed
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    }
    
    
}
