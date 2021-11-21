//
//  PhotoCollectionViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import SDWebImage
import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .label
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with image: UIImage?){
        imageView.image = image
    }
    
    public func configure(with url: URL?){
        imageView.sd_setImage(with: url, completed: nil)
    }
    
}
