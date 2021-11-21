//
//  ListGenreTableViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/25.
//

import UIKit
import SDWebImage

class ListGenreTableViewCell: UITableViewCell {

    static let identifier = "ListGenreTableViewCell"
    
    private let genreImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .systemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
        
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        return label
        
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        contentView.addSubview(genreImageView)
        contentView.addSubview(genreLabel)
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        genreLabel.sizeToFit()
        let size: CGFloat = contentView.height/1.3
        genreImageView.frame = CGRect(x: 5, y: (contentView.height-size)/2, width: size, height: size)
        genreImageView.layer.cornerRadius = size/2
        
        genreLabel.frame = CGRect(x: genreImageView.right + 10, y: 0, width: genreLabel.width, height: contentView.height)
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        genreLabel.text = nil
//        genreImageView.image = nil
//    }
    
//    func configure(with viewModel: ListGenreTableViewCellViewModel){
//        genreLabel.text = viewModel.genreStr
//        //profilePictureImageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
////        StorageManager.shared.profilePictureURL(for: viewModel.username, completion: { [weak self] url in
////            DispatchQueue.main.async {
////                self?.profilePictureImageView.sd_setImage(with: url, completed: nil)
////            }
////        })
//
//
//
//    }
    

}
