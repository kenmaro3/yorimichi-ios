//
//  VideoPostCollectionViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/06.
//

import UIKit
import AVFoundation

class VideoPostCollectionViewCell: UICollectionViewCell {
    static let identifier = "VideoPostCollectionViewCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        contentView.addSubview(imageView)
        contentView.backgroundColor = .secondarySystemBackground
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
    
    
    func configure(with post: Post){
        guard let thumbnailUrl = URL(string: post.postThumbnailUrlString) else {
            return
        }
        imageView.sd_setImage(with: thumbnailUrl, completed: nil)
        
    }
}
