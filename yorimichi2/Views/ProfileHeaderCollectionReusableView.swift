//
//  ProfileHeaderCollectionReusableView.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/21.
//

import UIKit

protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject{
    func profileHeaderCollectionReusableViewDidTapImage(_ header: ProfileHeaderCollectionReusableView)
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    public let countContainerView = ProfileHeaderCountView()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        label.text = "this is my bio.."
        return label
        
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(countContainerView)
        addSubview(bioLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        imageView.addGestureRecognizer(tap)
        
    }
    
    @objc private func didTapImage(){
        delegate?.profileHeaderCollectionReusableViewDidTapImage(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = width/4
        imageView.layer.cornerRadius = imageSize/2
        imageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        
        countContainerView.frame = CGRect(
            x: imageView.right+5,
            y: 3,
            width: width-imageView.right-10,
            height: imageSize
        )
        
        let bioSize = bioLabel.sizeThatFits(
            bounds.size
        )
        bioLabel.frame = CGRect(
            x: 5,
            y: imageView.bottom+10,
            width: width-10,
            height: bioSize.height + 40
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        bioLabel.text = nil
    }
    
    public func configure(with viewModel: ProfileHeaderViewModel){
        var text = ""
        if let name = viewModel.name {
            text = name + "\n"
        }
        text += viewModel.bio ?? "プロフィールへようこそ"
        imageView.sd_setImage(with: viewModel.profilePictureUrl, completed: nil)
        bioLabel.text = text
        bioLabel.sizeToFit()
        let containerViewModel = ProfileHeaderCountViewModel(followerCount: viewModel.followerCount,
                                                             followingCount: viewModel.followingCount,
                                                             postsCount: viewModel.postsCount,
                                                             actionType: viewModel.buttonType)
        countContainerView.configure(with: containerViewModel)
    }
    
}
