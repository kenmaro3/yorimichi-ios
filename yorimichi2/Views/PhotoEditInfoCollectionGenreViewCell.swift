//
//  PhotoEditInfoCollectionGenreViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/09.
//

import UIKit

protocol PhotoEditInfoCollectionGenreViewCellDelegate: AnyObject{
    func photoEditInfoCollectionGenreViewCellDidTapGenre()
}

class PhotoEditInfoCollectionGenreViewCell: UICollectionViewListCell {
   static let identifier = "PhotoEditInfoCollectionGenreViewCell"
    
    weak var delegate: PhotoEditInfoCollectionGenreViewCellDelegate?
    
    private var semiModalPresenter = SemiModalPresenter()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ジャンル情報"
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor.label
        return label
        
    }()
    
    private let genreLabel1: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor.label
        label.clipsToBounds = true
        return label
        
    }()
    
    
    private let infoButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "info.circle"), for: .normal)
        button.tintColor = .secondaryLabel
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoButton)
        contentView.addSubview(genreLabel1)
//        self.addBorder(width: 0.5, color: UIColor.secondarySystemBackground, position: .bottom)
        
        infoButton.addTarget(self, action: #selector(didTapInfo), for: .touchUpInside)
        
        addTap()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func didTapInfo(){
        print("singin info tapped")
        let viewController = GenreInfoModalViewController()
        semiModalPresenter.viewController = viewController
        parentViewController()?.present(viewController, animated: true)
        
    }
    
    private func addTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapLocation))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    @objc private func didTapLocation(){
        print("did tap location")
        delegate?.photoEditInfoCollectionGenreViewCellDidTapGenre()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 15, y: (contentView.height-titleLabel.height)/2, width: titleLabel.width, height: titleLabel.height)
        
        genreLabel1.sizeToFit()
        genreLabel1.frame = CGRect(x: titleLabel.right + 20, y: (contentView.height-genreLabel1.height)/2, width: genreLabel1.width, height: genreLabel1.height)
        
        
        let buttonSize: CGFloat = 30
        infoButton.frame = CGRect(x: contentView.right - buttonSize - 14, y: (contentView.height-buttonSize)/2, width: buttonSize, height: buttonSize)

        
    }
    
    public func configure(viewModel: PhotoEditInfoGenreViewModel){
        genreLabel1.text = viewModel.genre.getDisplayString
        //genreLabel2.text = viewModel.subTitle
        
    }
}
