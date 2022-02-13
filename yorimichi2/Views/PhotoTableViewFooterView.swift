//
//  PhotoTableViewFooterView.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2022/01/23.
//

import UIKit

protocol PhotoTableViewFooterViewDelegate: AnyObject{
    func photoTableViewFooterViewDidSelect(index: Int)
}

class PhotoTableViewFooterView: UITableViewHeaderFooterView {
    static let identifier = "PhotoTableViewFooterView"
    
    weak var delegate: PhotoTableViewFooterViewDelegate?
    
    public let title = UILabel()
    public var index = 0
    
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
        
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureContents()
        setupTapped()
    }
    
    private func setupTapped(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        tap.numberOfTapsRequired = 1
        
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    @objc private func didTap(_ gesture: UITapGestureRecognizer){
        print("tapped yoooooo")
        delegate?.photoTableViewFooterViewDidSelect(index: self.index)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        container.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(container)
        container.addSubview(title)
        
//        container.frame = CGRect(x: 6, y: 3, width: contentView.width-12, height: contentView.height-6)
//
//        container.layer.cornerRadius = 8
        
        print("here")
        
        print(contentView.bounds)
        print(container.bounds)
        
        
        container.layer.cornerRadius = 20
        
        //container.bounds = CGRect(x: 0, y: 0, width: 100, height: 50)
        
//        title.frame = CGRect(x: container.width/2, y: 10, width: 100, height: 20)

        // Center the image vertically and place it near the leading
        // edge of the view. Constrain its width and height to 50 points.
        let anchorSize: CGFloat = 30;
        NSLayoutConstraint.activate([
            // Center the label vertically, and use it to fill the remaining
            // space in the header view.
            container.heightAnchor.constraint(equalToConstant: 50),
            //container.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: anchorSize),
            //container.leadingAnchor.constraint(equalToConstant: anchorSize),
            //container.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: CGFloat(anchorSize)),
            //container.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: anchorSize*(-1.0)),
            //container.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: CGFloat(anchorSize)),
            container.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            title.heightAnchor.constraint(equalToConstant: 15),
            title.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: anchorSize + 20),
            //title.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            //title.leadingAnchor.constraint(equalToConstant: anchorSize),
            //title.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            title.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: (anchorSize + 10)*(-1.0)),
            //title.trailingAnchor.constraint(equalToConstant: anchorSize),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        //container.bounds = CGRect(x: 50, y: 0, width: container.width-50, height: container.height)
    }
}
