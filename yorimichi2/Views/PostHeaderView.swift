//
//  PostHeaderView.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/07.
//

import UIKit

protocol PostHeaderViewDelegate: AnyObject{
    func postHeaderViewDidTapUsername(_ view: PostHeaderView)
    func postHeaderViewDidTapMore(_ view: PostHeaderView)
}

class PostHeaderView: UIView {
    weak var delegate: PostHeaderViewDelegate?
    
    
    private var index: Int = 0

    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()

    private let moreButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "ellipsis",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)

        return button
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .systemBackground
        addSubview(imageView)
        addSubview(usernameLabel)
        addSubview(moreButton)

        moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapUsername))
        usernameLabel.isUserInteractionEnabled = true
        usernameLabel.addGestureRecognizer(tap)
    }

    @objc func didTapMoreButton(){
        print("tapped more")
        delegate?.postHeaderViewDidTapMore(self)
    }

    @objc func didTapUsername(){
        print("tapped username")
        delegate?.postHeaderViewDidTapUsername(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let imagePadding: CGFloat = 4
        let imageSize: CGFloat = height - (imagePadding * 2)
        imageView.frame = CGRect(x: 2, y: 2, width: imageSize, height: imageSize)
        imageView.layer.cornerRadius = imageSize/2

        usernameLabel.sizeToFit()
        usernameLabel.frame = CGRect(x: imageView.right+10, y: (height-usernameLabel.height)/2, width: usernameLabel.width, height: usernameLabel.height)


        moreButton.frame = CGRect(x: width-60,
                                  y: (height-50)/2,
                                  width: 50,
                                  height: 50)

    }


    func configure(with viewModel: PostHeaderViewModel){
        print("viewmodels++++++")
        print(viewModel)
        usernameLabel.text = viewModel.username
        usernameLabel.sizeToFit()
        usernameLabel.frame = CGRect(x: imageView.right+10, y: (height-usernameLabel.height)/2, width: usernameLabel.width, height: usernameLabel.height)
        imageView.sd_setImage(with: viewModel.profilePictureURL, completed: nil)

    }


}
