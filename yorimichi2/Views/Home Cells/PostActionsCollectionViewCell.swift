//
//  PostActionsCollectionViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import UIKit

protocol PostActionsCollectionViewCellDelegate: AnyObject{
    func postActionsCollectionViewCellDidTapLike(_ cell: PostActionsCollectionViewCell, isLiked: Bool, index: Int)
    func postActionsCollectionViewCellDidTapComment(_ cell: PostActionsCollectionViewCell, index: Int)
    func postActionsCollectionViewCellDidTapShare(_ cell: PostActionsCollectionViewCell, index: Int)
    //func postActionsCollectionViewCellDidTapYorimichi(_ cell: PostActionsCollectionViewCell, index: Int)
    func postActionsCollectionViewCellDidTapYorimichi()
}

final class PostActionsCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostActionsCollectionViewCell"
    
    private var index: Int = 0
    
    weak var delegate: PostActionsCollectionViewCellDelegate?
    
    private var isLiked: Bool = false
    

    private let likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "suit.heart", withConfiguration:  UIImage.SymbolConfiguration(pointSize: 40))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "text.bubble", withConfiguration:  UIImage.SymbolConfiguration(pointSize: 40))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "square.and.arrow.up", withConfiguration:  UIImage.SymbolConfiguration(pointSize: 40))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let yorimichiButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        //let image = UIImage(systemName: "point.topleft.down.curvedto.point.filled.bottomright.up", withConfiguration:  UIImage.SymbolConfiguration(pointSize: 40))
        let image = UIImage(named: "logo")
        button.clipsToBounds = true
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(shareButton)
        contentView.addSubview(yorimichiButton)

        
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        yorimichiButton.addTarget(self, action: #selector(didTapYorimichi), for: .touchUpInside)
        
        // Actions
    }
    
    @objc private func didTapYorimichi(){
        //delegate?.postActionsCollectionViewCellDidTapYorimichi(self, index: index)
        delegate?.postActionsCollectionViewCellDidTapYorimichi()
    }
    
    @objc private func didTapLike(){
        if self.isLiked{
            let image = UIImage(systemName: "suit.heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .label
        }else{
            let image = UIImage(systemName: "suit.heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .systemRed
        }
        delegate?.postActionsCollectionViewCellDidTapLike(self, isLiked: !isLiked, index: index)
        self.isLiked = !isLiked
        NotificationCenter.default.post(name: .didLikeByAction, object: nil)
    }
    
    @objc private func didTapComment(){
        delegate?.postActionsCollectionViewCellDidTapComment(self, index: index)
    }
    
    @objc private func didTapShare(){
        delegate?.postActionsCollectionViewCellDidTapShare(self, index: index)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = contentView.height/1.4
        likeButton.frame = CGRect(x: 8, y: (contentView.height - size)/2, width: size, height: size)
        commentButton.frame = CGRect(x: likeButton.right + 14, y: (contentView.height - size)/2, width: size, height: size)
        shareButton.frame = CGRect(x: commentButton.right + 14, y: (contentView.height - size)/2, width: size, height: size)
        yorimichiButton.frame = CGRect(x: shareButton.right + 14, y: (contentView.height - size)/2, width: size, height: size)
        yorimichiButton.layer.cornerRadius = size/2
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with viewModel: PostActionsCollectionViewCellViewModel, index: Int){
        self.index = index
        isLiked = viewModel.isLiked
        if viewModel.isLiked{
            let image = UIImage(systemName: "suit.heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .systemRed
        }
        else{
            let image = UIImage(systemName: "suit.heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .label
            
        }
    }
}
