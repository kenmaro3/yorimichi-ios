//
//  PostFooterView.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2022/02/02.
//

protocol PostFooterViewDeleagte: AnyObject{
    func postFooterViewDidTapped(post: Post)
}

import UIKit

class PostFooterView: UIView {
    weak var delegate: PostFooterViewDeleagte?
    
    private var post: Post?
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
        
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "地図上で見る"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(container)
        container.addSubview(label)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    @objc private func didTap(){
        print("tapped with \(self.post)")
        delegate?.postFooterViewDidTapped(post: self.post!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        container.frame = CGRect(x: 20, y: 10, width: self.width-40, height: self.height-20)
        container.layer.cornerRadius = 30
        
        label.sizeToFit()
        label.frame = CGRect(x: container.center.x - label.width/2 - 10, y: container.center.y - label.height/2 - 10, width: label.width, height: label.height)
    }
    
    public func configure(post: Post){
        self.post = post
    }
    
}
