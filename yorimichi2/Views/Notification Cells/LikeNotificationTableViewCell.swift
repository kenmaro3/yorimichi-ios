//
//  LikeNotificationTableViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import UIKit

protocol LikeNotificationTableViewCellDelegate: AnyObject{
    func likeNotificationTableViewCell(_ cell: LikeNotificationTableViewCell, didTapPostWith viewModel: LikeNotificationCellViewModel)
}

class LikeNotificationTableViewCell: UITableViewCell {
    static let identifier = "LikeNotificationTableViewCell"
    
    weak var delegate: LikeNotificationTableViewCellDelegate?
    
    private var viewModel: LikeNotificationCellViewModel?

    private let profilePictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
        
    }()
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        return label
    }()
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.clipsToBounds = true
        contentView.addSubview(profilePictureImageView)
        contentView.addSubview(label)
        contentView.addSubview(postImageView)
        contentView.addSubview(dateLabel)
        
        postImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPost))
        postImageView.addGestureRecognizer(tap)
    }
    
    @objc private func didTapPost(){
        guard let vm = viewModel else {
            return
        }
        
        delegate?.likeNotificationTableViewCell(self, didTapPostWith: vm)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.height/1.5
        profilePictureImageView.frame = CGRect(x: 10, y: (contentView.height - imageSize)/2, width: imageSize, height: imageSize)
        profilePictureImageView.layer.cornerRadius = imageSize/2
        
        let postSize: CGFloat = contentView.height - 6
        postImageView.frame = CGRect(x: contentView.width-postSize-10, y: 3, width: postSize, height: postSize)
        
        let labelSize = label.sizeThatFits(
            CGSize(width: contentView.width-profilePictureImageView.right-25-postSize, height: contentView.height)
        )
        
        dateLabel.sizeToFit()
        
        label.frame = CGRect(x: profilePictureImageView.right+10, y: 0, width: labelSize.width, height: contentView.height - dateLabel.height-2)
        
        dateLabel.frame = CGRect(x: profilePictureImageView.right+10, y: contentView.height-dateLabel.height - 2, width: dateLabel.width, height: dateLabel.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        profilePictureImageView.image = nil
        postImageView.image = nil
        dateLabel.text = nil
    }
    
    public func configure(with viewModel: LikeNotificationCellViewModel){
        self.viewModel = viewModel
//        profilePictureImageView.sd_setImage(with: viewModel.profilePictureUrl, completed: nil)
//        label.text = viewModel.username + " commented on your post"
        profilePictureImageView.sd_setImage(with: viewModel.profilePictureUrl, completed: nil)
        postImageView.sd_setImage(with: viewModel.postUrl, completed: nil)
        label.text = viewModel.username + " ????????????????????????????????????????????????"
        dateLabel.text = viewModel.date
        
        
    }

}
