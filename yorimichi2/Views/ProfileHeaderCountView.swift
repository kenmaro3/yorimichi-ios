//
//  ProfileHeaderCountView.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/21.
//

import UIKit

protocol ProfileHeaderCountViewDelegate: AnyObject{
    func profileHeaderCountViewDidTapFollowers(_ containerView: ProfileHeaderCountView)
    func profileHeaderCountViewDidTapFollowing(_ containerView: ProfileHeaderCountView)
    func profileHeaderCountViewDidTapPosts(_ containerView: ProfileHeaderCountView)
    func profileHeaderCountViewDidTapEditProfile(_ containerView: ProfileHeaderCountView)
    func profileHeaderCountViewDidTapFollow(_ containerView: ProfileHeaderCountView)
    func profileHeaderCountViewDidTapUnFollow(_ containerView: ProfileHeaderCountView)
    
}

class ProfileHeaderCountView: UIView {
    
    weak var delegate: ProfileHeaderCountViewDelegate?
    
    private var action = ProfileButtonType.edit
    
    private var isFollowing = false
    
    private let followerCountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.setTitle("-", for: .normal)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    private let followingCountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.setTitle("-", for: .normal)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    private let postsCountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.setTitle("-", for: .normal)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    public let actionButton = FollowButton()
    
//    private let actionButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .systemBlue
//        button.setTitle("Follow", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//
//        return button
//
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(followerCountButton)
        addSubview(followingCountButton)
        addSubview(postsCountButton)
        addSubview(actionButton)
        
        addActions()
    }
    
    private func addActions(){
        followerCountButton.addTarget(self, action: #selector(didTapFollowers), for: .touchUpInside)
        followingCountButton.addTarget(self, action: #selector(didTapFollowing), for: .touchUpInside)
        postsCountButton.addTarget(self, action: #selector(didTapPosts), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        
    }
    
    
    // MARK: - Actions
    
    @objc private func didTapFollowers(){
        delegate?.profileHeaderCountViewDidTapFollowers(self)
    }
    
    @objc private func didTapFollowing(){
        delegate?.profileHeaderCountViewDidTapFollowing(self)
    }
    
    
    @objc private func didTapPosts(){
        delegate?.profileHeaderCountViewDidTapPosts(self)
    }
    
    @objc private func didTapActionButton(){
        switch action{
        case .edit:
            delegate?.profileHeaderCountViewDidTapEditProfile(self)
        case .follow(let is_following):
            if is_following{
                // unfollow
                delegate?.profileHeaderCountViewDidTapUnFollow(self)
            }
            else{
                // follow
                delegate?.profileHeaderCountViewDidTapFollow(self)
            }
            
            self.isFollowing = !is_following
            self.action = .follow(isFollowing: self.isFollowing)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonWidth: CGFloat = (width - 15)/3
        followerCountButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: height/2)
        followingCountButton.frame = CGRect(x: followerCountButton.right + 5, y: 5, width: buttonWidth, height: height/2)
        postsCountButton.frame = CGRect(x: followingCountButton.right + 5, y: 5, width: buttonWidth, height: height/2)
        
        actionButton.frame = CGRect(x: 5, y: height-42, width: width-10, height: 40)
    }
    
    public func configure(with viewModel: ProfileHeaderCountViewModel){
        followerCountButton.setTitle("\(viewModel.followerCount)\nフォロワー", for: .normal)
        followingCountButton.setTitle("\(viewModel.followingCount)\nフォロー中", for: .normal)
        postsCountButton.setTitle("\(viewModel.postsCount)\n投稿", for: .normal)
        
        self.action = viewModel.actionType
        
        
        switch viewModel.actionType{
            case .edit:
            actionButton.backgroundColor = .systemBackground
            actionButton.setTitle("プロフィールの編集", for: .normal)
            actionButton.setTitleColor(.label, for: .normal)
            actionButton.layer.borderWidth = 0.5
            actionButton.layer.borderColor = UIColor.tertiaryLabel.cgColor
            
        case .follow(let isFollowing):
            self.isFollowing = isFollowing
            actionButton.configure(for: isFollowing ? .unfollow : .follow)
            
        }
    }
    
}
