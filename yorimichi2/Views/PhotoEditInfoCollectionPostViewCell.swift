//
//  PhotoEditInfoCollectionPostViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/09.
//

import UIKit

class PhotoEditInfoCollectionPostViewCell: UICollectionViewListCell {
   static let identifier = "PhotoEditInfoCollectionPostViewCell"
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(imageView)
        self.addBorder(width: 0.5, color: UIColor.secondarySystemBackground, position: .bottom)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        frame = contentView.bounds
        let imageSize: CGFloat = 100
        let imagePadding: CGFloat = 5
        imageView.frame = CGRect(x: (contentView.width-imageSize)/2, y: (contentView.height-imageSize)/2 + imagePadding, width: imageSize, height: imageSize - imagePadding*2)
        
    }
    
    
}
