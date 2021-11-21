//
//  PostEditNameCollectionViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/26.
//

import UIKit
import MapboxSearch

protocol PostEditNameCollectionViewCellDelegate: AnyObject{
    func postEditNameCollectionViewCellEndEditing(_ cell: PostEditNameCollectionViewCell)
}

class PostEditNameCollectionViewCell: UICollectionViewCell{
    
    weak var delegate: PostEditNameCollectionViewCellDelegate?
    
    
    static let identifier = "PostEditNameCollectionViewCell"
    
    private let placeholder = "Add Name..."
    
    public let field: UITextField = {
        
        let field = TextField()

        field.layer.masksToBounds = true
        field.font = .systemFont(ofSize: 16)
        field.returnKeyType = .next
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        
        return field
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        
        
        field.placeholder = placeholder
        field.delegate = self
        contentView.addSubview(field)
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        field.frame = CGRect(x: 10, y: 0, width: contentView.width-20, height: contentView.height)
//        label.frame = CGRect(x: 10, y: field.bottom+30, width: contentView.width-20, height: 32)
        
    }
    
    func configure(with name: String){
        field.text = name
    }
}


extension PostEditNameCollectionViewCell: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.postEditNameCollectionViewCellEndEditing(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 任意の処理
        textField.resignFirstResponder()
        return true
    }
}

