//
//  PostEditHeaderCollectionViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/27.
//

import UIKit

protocol PostEditHeaderCollectionViewCellDelegate: AnyObject{
    func postEditHeaderCollectionViewCellDidTap()
    
}

class PostEditHeaderCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: PostEditHeaderCollectionViewCellDelegate?
    
    static let identifier = "PostEditHeaderCollectionViewCell"
    
    public let label: UILabel = {
        let label = UILabel()
        label.text = "ヨリミチの詳細をぜひ教えてください！"
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(label)
        
        contentView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        contentView.addGestureRecognizer(tap)
    }
    
    @objc private func didTap(){

        delegate?.postEditHeaderCollectionViewCellDidTap()
        
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 10, y: 0, width: contentView.width-20, height: contentView.height)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    
    public func configure(with text: String){
        label.text = text
    }
}
