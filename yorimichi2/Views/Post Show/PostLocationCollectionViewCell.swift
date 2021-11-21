//
//  PostLocationCollectionViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/26.
//

import UIKit
import CoreLocation

class PostLocationCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostLocationCollectionViewCell"
    private let geocoder = CLGeocoder()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.isUserInteractionEnabled = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(label)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = label.sizeThatFits(CGSize(width: contentView.bounds.size.width-12, height: contentView.bounds.size.height))
        label.frame = CGRect(x: 12, y: 3, width: size.width, height: size.height)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    
    func configure(with viewModel: PostLocationCollectionViewCellViewModel){
        label.text = "住所情報: 記載無し"
        GeocoderManager.shared.getAddressFromLocation(location: viewModel.location, completion: {[weak self] address in
            
            print("\n\n--------------------")
            print("adress is here")
            print(address)
            
            if let name = address.name{
                self?.label.text = "住所情報: \(name)"
            }
            else{
                self?.label.text = "住所情報: \(viewModel.location.toString)"
            }
        })
    }
}
