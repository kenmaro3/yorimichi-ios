//
//  ListExploreResultTableViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/31.
//

import UIKit
import AVFoundation

// MARK: Yorimichi

protocol ListExploreResultYorimichiTableViewCellDelegate: AnyObject{
    func listExploreResultYorimichiTableViewCell(_ cell: ListExploreResultYorimichiTableViewCell, didTapPostWith viewModel: YorimichiAnnotationViewModel)
    func listExploreResultYorimichiTableViewCellDidTapDetail(_ cell: ListExploreResultYorimichiTableViewCell, didTapDetailWith viewModel: YorimichiAnnotationViewModel)
    func listExploreResultYorimichiTableViewCellDidTapYorimichiImageView(_ cell: ListExploreResultYorimichiTableViewCell, didTapWith viewModel: YorimichiAnnotationViewModel)
    
    
}

class ListExploreResultYorimichiTableViewCell: UITableViewCell {
    static let identifier = "ListExploreResultTableViewCell"
    
    weak var delegate: ListExploreResultYorimichiTableViewCellDelegate?
    
    private var viewModel: YorimichiAnnotationViewModel?
    
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
    
    private let yorimichiAddedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        imageView.isUserInteractionEnabled = true
        return imageView
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
        container.addSubview(yorimichiAddedImage)
        
        detailButton.addTarget(self, action: #selector(didTapDetail), for: .touchUpInside)
//        contentView.addSubview(postImageView)
//        contentView.addSubview(label)
        
        postImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPost))
        tap.numberOfTapsRequired = 2
        postImageView.addGestureRecognizer(tap)
        
        let yorimichiTap = UITapGestureRecognizer(target: self, action: #selector(didTapYorimichiImageView))
        yorimichiAddedImage.addGestureRecognizer(yorimichiTap)
    }
    
    @objc func didTapYorimichiImageView(){
        guard let vm = viewModel else {
            return
        }
        print("did tap yorimichi image view")
        yorimichiAddedImage.isHidden = true
        delegate?.listExploreResultYorimichiTableViewCellDidTapYorimichiImageView(self, didTapWith: vm)
    }
    
    @objc func didTapDetail(){
        guard let vm = viewModel else {
            return
        }
        print("did tap detail")
        delegate?.listExploreResultYorimichiTableViewCellDidTapDetail(self, didTapDetailWith: vm)
    }
    
    @objc private func didTapPost(){
        guard let vm = viewModel else {
            return
        }
        
        delegate?.listExploreResultYorimichiTableViewCellDidTapYorimichiImageView(self, didTapWith: vm)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        print("*****")
//        print(contentView.frame)
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//        print("*****")
//        print(contentView.frame)
        

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
        
        yorimichiAddedImage.frame = CGRect(x: label.right+20 , y: (container.height - yorimichiAddedImageSize)/2, width: yorimichiAddedImageSize, height: yorimichiAddedImageSize)
        yorimichiAddedImage.layer.cornerRadius = yorimichiAddedImageSize/2
        
        detailButton.frame = CGRect(x: container.right-buttonSize-10 , y: (container.height - buttonSize)/2, width: buttonSize, height: buttonSize)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        postImageView.image = nil
    }
    
    public func configure(with viewModel: YorimichiAnnotationViewModel){
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
    
    public func yorimichiOn(){
        yorimichiAddedImage.isHidden = false
    }
}

// MARK: - HP
protocol ListExploreResultHPTableViewCellDelegate: AnyObject{
    func listExploreResultHPTableViewCell(_ cell: ListExploreResultHPTableViewCell, didTapPostWith viewModel: HPAnnotationViewModel)
    func listExploreResultHPTableViewCellDidTapDetail(_ cell: ListExploreResultHPTableViewCell, didTapDetailWith viewModel: HPAnnotationViewModel)
}


class ListExploreResultHPTableViewCell: UITableViewCell {
    static let identifier = "ListExploreResultHPTableViewCell"
    
    public var jumpUrl: String = ""
    
    weak var delegate: ListExploreResultHPTableViewCellDelegate?
    
    private var viewModel: HPAnnotationViewModel?

    private let container: UIView = {
        let container = UIView()
        container.backgroundColor = .secondarySystemBackground
        return container
    }()

    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.clipsToBounds = true
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
    
    private let yorimichiAddedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        return imageView
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
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(container)
        container.addSubview(postImageView)
        container.addSubview(label)
        container.addSubview(detailButton)
        container.addSubview(info)
        container.addSubview(yorimichiAddedImage)
        
        detailButton.addTarget(self, action: #selector(didTapDetail), for: .touchUpInside)
        
//        contentView.addSubview(postImageView)
//        contentView.addSubview(label)
        
        postImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPost))
        tap.numberOfTapsRequired = 2
        postImageView.addGestureRecognizer(tap)
    }
    
    @objc func didTapDetail(){
        guard let vm = viewModel else {
            return
        }
        print("did tap detail")
        delegate?.listExploreResultHPTableViewCellDidTapDetail(self, didTapDetailWith: vm)
    }
    
    @objc private func didTapPost(){
        guard let vm = viewModel else {
            return
        }
        
        print("image tapped")
        
        delegate?.listExploreResultHPTableViewCell(self, didTapPostWith: vm)
        
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
        let yorimichiAddedImageSize: CGFloat = 64
        
        label.sizeToFit()
        label.frame = CGRect(x: postImageView.right+10, y: (container.height - label.height - info.height)/2, width: container.width-postImageView.width-buttonSize-60, height: label.height)
        
        info.frame = CGRect(x: postImageView.right+10, y: label.bottom+10, width: container.width-postImageView.width-buttonSize-60, height: 20)
    
        yorimichiAddedImage.frame = CGRect(x: label.right+20 , y: (container.height - buttonSize)/2, width: yorimichiAddedImageSize, height: yorimichiAddedImageSize)
        yorimichiAddedImage.layer.cornerRadius = yorimichiAddedImageSize/2
        
        detailButton.frame = CGRect(x: container.right-buttonSize-10 , y: (container.height - buttonSize)/2, width: buttonSize, height: buttonSize)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        postImageView.image = nil
    }
    
    public func configure(with viewModel: HPAnnotationViewModel){
        self.viewModel = viewModel
        
        jumpUrl = viewModel.jumpUrl
        
        guard let url = URL(string: viewModel.url) else {
            return
        }
        postImageView.sd_setImage(with: url, completed: nil)
        
        label.text = viewModel.title
        info.text = viewModel.subtitle
    }
    
    public func yorimichiOn(){
        yorimichiAddedImage.isHidden = false
    }
}
