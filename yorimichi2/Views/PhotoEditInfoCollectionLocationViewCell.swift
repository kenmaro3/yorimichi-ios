//
//  PhotoEditInfoCollectionLocationViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/09.
//

import UIKit

protocol PhotoEditInfoCollectionLocationViewCellDelegate: AnyObject{
    func photoEditInfoCollectionLocationViewCellDidTapLocation()
    func photoEditInfoCollectionLocationViewCellDidTapDirectLocation()
}

class PhotoEditInfoCollectionLocationViewCell: UICollectionViewListCell {
   static let identifier = "PhotoEditInfoCollectionLocationViewCell"
    
    weak var delegate: PhotoEditInfoCollectionLocationViewCellDelegate?
    
    private var semiModalPresenter = SemiModalPresenter()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "場所検索"
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor.label
        return label
        
    }()
    
    private let locationLabel1: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor.label
        label.clipsToBounds = true
        return label
        
    }()
    
    private let locationLabel2: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor.secondaryLabel
        label.clipsToBounds = true
        return label
        
    }()
    
//    private let button: UIButton = {
//        let button = UIButton()
//        button.tintColor = .secondaryLabel
//        let image = UIImage(systemName: "chevron.right", withConfiguration:  UIImage.SymbolConfiguration(pointSize: 18))
//        //button.backgroundColor = UIColor.systemGray.withAlphaComponent(0.5)
//        button.setImage(image, for: .normal)
//        button.layer.borderColor = UIColor.white.cgColor
//
//        return button
//    }()
    
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
//        contentView.addSubview(button)
        contentView.addSubview(locationLabel1)
        contentView.addSubview(locationLabel2)
        contentView.addSubview(infoButton)
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
        let viewController = LocationInfoModalViewController()
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
        if(titleLabel.text == "場所検索"){
            delegate?.photoEditInfoCollectionLocationViewCellDidTapLocation()
        }
        else if(titleLabel.text == "場所手動入力"){
            delegate?.photoEditInfoCollectionLocationViewCellDidTapDirectLocation()
            
        }
        else{
            fatalError("unknown viewModel title found, probably impl bug")
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 15, y: (contentView.height-titleLabel.height)/2, width: titleLabel.width, height: titleLabel.height)
        
        locationLabel1.sizeToFit()
        locationLabel1.frame = CGRect(x: titleLabel.right + 20, y: (contentView.height-locationLabel1.height)/3, width: locationLabel1.width, height: locationLabel1.height)
        
        
        let buttonSize: CGFloat = 30
        infoButton.frame = CGRect(x: contentView.right - buttonSize - 14, y: (contentView.height-buttonSize)/2, width: buttonSize, height: buttonSize)
        
        locationLabel2.sizeToFit()
        let locationLabel2Width = min(locationLabel2.width, contentView.width - titleLabel.width - buttonSize - 40)
        locationLabel2.frame = CGRect(x: titleLabel.right + 20, y: locationLabel1.bottom+5, width: locationLabel2Width, height: locationLabel2.height)

        
    }
    
    
    public func configure(viewModel: PhotoEditInfoLocationViewModel){
        titleLabel.text = viewModel.titleHeader
        locationLabel1.text = viewModel.title
        locationLabel2.text = viewModel.subTitle
        
    }
}
