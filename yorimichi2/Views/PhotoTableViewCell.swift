//
//  PhotoTableViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2022/01/22.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    static let identifier = "PhotoTableViewCell"
    
    
    private let container: UIView = {
        let container = UIView()
        container.backgroundColor = .secondarySystemBackground
        return container
    }()



    private var profilePictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
        
    }()
    
    private let profileName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    private let info: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        selectionStyle = .none
        
        contentView.addSubview(container)
        print("here contentView===========")
        print(contentView.bounds)
        
        let isGhost = UserDefaults.standard.bool(forKey: "isGhost")
        if(!isGhost){
            container.addSubview(profileName)
            container.addSubview(profilePictureImageView)
        }
        
        container.addSubview(postImageView)
        container.addSubview(label)
        container.addSubview(info)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 20, bottom: 2, right: 20))
        
//        print("*****")
//        print(contentView.frame)
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//        print("*****")
//        print(contentView.frame)
        

        container.frame = CGRect(x: 6, y: 3, width: contentView.width-12, height: contentView.height-6)
        
        container.layer.cornerRadius = 8
        
        
        let isGhost = UserDefaults.standard.bool(forKey: "isGhost")
        if(!isGhost){
            let imageSize: CGFloat = 24
            profilePictureImageView.frame = CGRect(x: 20, y: 6, width: imageSize, height: imageSize)
            profilePictureImageView.layer.cornerRadius = imageSize/2
            
            let postSize: CGFloat = container.height - 12
            postImageView.frame = CGRect(x: container.width-postSize-10, y: 6, width: postSize, height: postSize)
            postImageView.clipsToBounds = true
            postImageView.layer.cornerRadius = 10
            
            
            
            profileName.sizeToFit()
            info.sizeToFit()
            label.sizeToFit()
            
            profileName.frame = CGRect(x: profilePictureImageView.right + 20, y: 10, width: profileName.width, height: profileName.height)
            
            label.frame = CGRect(x: 20, y: profilePictureImageView.bottom+14, width: container.width-postImageView.width - 30, height: label.height)
            
            
            info.frame = CGRect(x: 20, y: label.bottom + 10, width: container.width-postImageView.width - 30, height: info.height)
        }
        else{
            let imageSize: CGFloat = 24
            
            let postSize: CGFloat = container.height - 12
            postImageView.frame = CGRect(x: container.width-postSize-10, y: 6, width: postSize, height: postSize)
            postImageView.clipsToBounds = true
            postImageView.layer.cornerRadius = 10
            
            
            
            info.sizeToFit()
            label.sizeToFit()
            
            
            label.frame = CGRect(x: 20, y: 6+14, width: container.width-postImageView.width - 30, height: label.height)
            
            info.frame = CGRect(x: 20, y: label.bottom + 10, width: container.width-postImageView.width - 30, height: info.height)
            
        }
        

        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        postImageView.image = nil
        profileName.text = nil
    }
    
    public func configure(with viewModel: PhotoCellViewModel){
        

        
        if viewModel.post.isVideo{
            
            guard let url = URL(string: viewModel.post.postThumbnailUrlString) else {
                return
            }

            postImageView.sd_setImage(with: url, completed: nil)
            label.text = viewModel.post.locationTitle
            info.text = viewModel.post.caption
            label.sizeToFit()
            info.sizeToFit()
            
//            profilePictureImageView.sd_setImage(with: viewModel.post.user.profilePictureUrl, completed: nil)
            profileName.text = viewModel.post.user.username
            profileName.sizeToFit()
        }else{
            
            guard let url = URL(string: viewModel.post.postUrlString) else {
                return
            }
            
            postImageView.sd_setImage(with: url, completed: nil)
            label.text = viewModel.post.locationTitle
            info.text = viewModel.post.caption
            label.sizeToFit()
            info.sizeToFit()
            
//            profilePictureImageView.sd_setImage(with: viewModel.post.user.profilePictureUrl, completed: nil)
            profileName.text = viewModel.post.user.username
            profileName.sizeToFit()
            
            StorageManager.shared.profilePictureURL(for: viewModel.post.user.username, completion: {[weak self] url in
                
                if let url = url {
                    self?.profilePictureImageView.sd_setImage(with: url, completed: nil)
                    
                }
                else{
                    self?.profilePictureImageView = UIImageView(image: UIImage(systemName: "person.crop.circle"))
                    
                }
                
            })
            
        }

        
    }
    
}
