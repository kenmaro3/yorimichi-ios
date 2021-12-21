//
//  ProfileHeaderCollectionReusableView.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/21.
//

import UIKit

protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject{
    func profileHeaderCollectionReusableViewDidTapImage(_ header: ProfileHeaderCollectionReusableView)
    func profileHeaderCollectionReusableViewShowAlert(alert: UIAlertController)
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
    private var twitterId: String?
    private var instagramId: String?
    
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
        label.text = "プロフィールへようこそ"
        return label
        
    }()
    
    private let twitterLinkIcon: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "twitter"), for: .normal)
        return button
    }()
    
    private let instagramLinkIcon: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "instagram"), for: .normal)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(countContainerView)
        addSubview(bioLabel)
        addSubview(twitterLinkIcon)
        addSubview(instagramLinkIcon)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        imageView.addGestureRecognizer(tap)
        
        twitterLinkIcon.addTarget(self, action: #selector(didTapTwitterLink), for: .touchUpInside)
        instagramLinkIcon.addTarget(self, action: #selector(didTapInstagramLink), for: .touchUpInside)
        
    }
    
    @objc private func didTapTwitterLink(){
        print("twitter tapped")
        if let twitterId = twitterId {
            let appURL = URL(string: "twitter://user?screen_name=\(twitterId)")!
            let webURL = URL(string: "https://twitter.com/\(twitterId)")!
            
            if UIApplication.shared.canOpenURL(appURL as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL)
                } else {
                    UIApplication.shared.openURL(appURL)
                }
            } else {
                //redirect to safari because the user doesn't have Instagram
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(webURL)
                } else {
                    UIApplication.shared.openURL(webURL)
                }
            }
            
        }
        else{
            
            let alert = UIAlertController(title: "Twitter連携エラー", message: "TwitterのIDが登録されていません。プロフィールの編集からIDを連携してください。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            delegate?.profileHeaderCollectionReusableViewShowAlert(alert: alert)
        }
    }
    
    @objc private func didTapInstagramLink(){
        print("ig tapped")
        if let instagramId = instagramId {
            let appURL = URL(string: "instagram://user?screen_name=\(instagramId)")!
            let webURL = URL(string: "https://instagram.com/\(instagramId)")!
            
            if UIApplication.shared.canOpenURL(appURL as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL)
                } else {
                    UIApplication.shared.openURL(appURL)
                }
            } else {
                //redirect to safari because the user doesn't have Instagram
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(webURL)
                } else {
                    UIApplication.shared.openURL(webURL)
                }
            }
            
        }
        else{
            let alert = UIAlertController(title: "Instagram連携エラー", message: "InstagramのIDが登録されていません。プロフィールの編集からIDを連携してください。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            delegate?.profileHeaderCollectionReusableViewShowAlert(alert: alert)
        }
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
            x: 15,
            y: imageView.bottom+10,
            width: width-30,
            height: bioSize.height + 40
        )
        
        let twitterLinkIconSize: CGFloat = 20
        twitterLinkIcon.frame = CGRect(
            x: 15,
            y: bioLabel.bottom+10,
            width: twitterLinkIconSize,
            height: twitterLinkIconSize
        )
        
        let instagramLinkIconSize: CGFloat = 20
        instagramLinkIcon.frame = CGRect(
            x: twitterLinkIcon.right + 20,
            y: bioLabel.bottom+10,
            width: instagramLinkIconSize,
            height: instagramLinkIconSize
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
        twitterId = viewModel.twitterId
        instagramId = viewModel.instagramId
        let containerViewModel = ProfileHeaderCountViewModel(
            followerCount: viewModel.followerCount,
            followingCount: viewModel.followingCount,
            postsCount: viewModel.postsCount,
            actionType: viewModel.buttonType)
        countContainerView.configure(with: containerViewModel)
    }
    
}
