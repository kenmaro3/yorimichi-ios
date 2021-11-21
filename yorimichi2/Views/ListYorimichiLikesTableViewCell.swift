//
//  ListYorimichiLikesTableViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/18.
//

import UIKit
import AVFoundation

// MARK: Yorimichi

protocol ListYorimichiLikesTableViewCellDelegate: AnyObject{
    func ListYorimichiLikesTableViewCellDidTapDetail(_ cell: ListYorimichiLikesTableViewCell, didTapDetailWith viewModel: LikesAnnotationViewModel)
    
    
}

class ListYorimichiLikesTableViewCell: UITableViewCell {
    static let identifier = "ListYorimichiLikesTableViewCell"
    
    weak var delegate: ListYorimichiLikesTableViewCellDelegate?
    
    private var viewModel: LikesAnnotationViewModel?
    
    private let container: UIView = {
        let container = UIView()
        container.backgroundColor = .secondarySystemBackground
        return container
    }()

    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.clipsToBounds = true
        label.textAlignment = .left
        return label
    }()
    
    private let info: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 10)
        label.clipsToBounds = true
        label.textAlignment = .left
        return label
    }()
    
    
    private let detailButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "arrow.right.to.line", withConfiguration:  UIImage.SymbolConfiguration(pointSize: 22))
        //button.backgroundColor = UIColor.systemGray.withAlphaComponent(0.5)
        button.setImage(image, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
    }()
    
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .systemBackground
        contentView.clipsToBounds = true
        contentView.addSubview(container)
        
        container.addSubview(postImageView)
        container.addSubview(label)
        container.addSubview(info)
        container.addSubview(detailButton)
        
        detailButton.addTarget(self, action: #selector(didTapDetail), for: .touchUpInside)
        
        
    }
    
    
    @objc func didTapDetail(){
        guard let vm = viewModel else {
            return
        }
        print("did tap detail")
        delegate?.ListYorimichiLikesTableViewCellDidTapDetail(self, didTapDetailWith: vm)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        

        container.frame = CGRect(x: 6, y: 6, width: width-12, height: height-12)
        
        container.layer.cornerRadius = 8
        
        let postSize: CGFloat = 72
        postImageView.frame = CGRect(x: container.left + 20, y: (container.height - postSize)/2, width: postSize, height: postSize)
        postImageView.layer.cornerRadius = postSize/2
        postImageView.layer.borderWidth = 2
        postImageView.layer.borderColor = UIColor.white.cgColor
        

        
        let buttonSize: CGFloat = 50
        let yorimichiAddedImageSize: CGFloat = 32
        
        label.sizeToFit()
        label.frame = CGRect(x: postImageView.right+10, y: (container.height - label.height - info.height)/2, width: container.width-postImageView.width-buttonSize-120, height: label.height)
        
        info.frame = CGRect(x: postImageView.right+10, y: label.bottom+10, width: container.width-postImageView.width-buttonSize-60, height: 20)
        
        
        detailButton.frame = CGRect(x: container.right-buttonSize-10 , y: (container.height - buttonSize)/2, width: buttonSize, height: buttonSize)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        postImageView.image = nil
    }
    
    public func configure(with viewModel: LikesAnnotationViewModel){
        self.viewModel = viewModel
        

        
        if viewModel.post.isVideo{
            
            guard let url = URL(string: viewModel.post.postThumbnailUrlString) else {
                return
            }

            postImageView.sd_setImage(with: url, completed: nil)
            label.text = viewModel.title
            info.text = viewModel.subtitle
        }else{
            
            guard let url = URL(string: viewModel.post.postUrlString) else {
                return
            }
            
            postImageView.sd_setImage(with: url, completed: nil)
            label.text = viewModel.title
            info.text = viewModel.subtitle

        }
    }
}

