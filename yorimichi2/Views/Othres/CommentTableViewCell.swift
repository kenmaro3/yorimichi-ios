//
//  CommentTableViewCell.swift
//  tiktok
//
//  Created by Kentaro Mihara on 2021/11/03.
//

import UIKit
import SDWebImage

//protocol CommentTableViewCellDelegate: AnyObject{
//    func commentTableViewCellDidTapCell(user: User)
//}

class CommentTableViewCell: UITableViewCell {
    static let identifier = "CommentTableViewCell"
    
//    weak var delegate: CommentBarViewDelegate?
    
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = .black
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = .systemGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        clipsToBounds = true
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(commentLabel)
        contentView.addSubview(dateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dateLabel.sizeToFit()
        commentLabel.sizeToFit()
        
        let imageSize: CGFloat = 44
        avatarImageView.frame = CGRect(x: 10, y: 5, width: imageSize, height: imageSize)
        avatarImageView.layer.cornerRadius = imageSize/2
        
        let commentLabelHeight = min(contentView.height-dateLabel.top, commentLabel.height)
        commentLabel.frame = CGRect(x: avatarImageView.right+10, y: 5, width: contentView.width - avatarImageView.width - 10, height: commentLabelHeight)
        dateLabel.frame = CGRect(x: avatarImageView.right+10, y: commentLabel.bottom, width: dateLabel.width, height: dateLabel.height)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarImageView.image = nil
        commentLabel.text = nil
        dateLabel.text = nil
    }
    
    public func configure(with model: PostComment){
        commentLabel.text = model.text
        dateLabel.text = .date(from: model.date)
        
        StorageManager.shared.profilePictureURL(for: model.user.username, completion: {[weak self] url in
            self?.avatarImageView.sd_setImage(with: url, completed: nil)
    
        })
    }
    

}
