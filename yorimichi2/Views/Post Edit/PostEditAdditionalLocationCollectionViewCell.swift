//
//  PostEditAdditionalLocationCollectionViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/26.
//

import UIKit

protocol PostEditAdditionalLocationCollectionViewCellDelegate: AnyObject{
    func postEditAdditionalLocationCollectionViewCellEndEditing(_ cell: PostEditAdditionalLocationCollectionViewCell)
}


class PostEditAdditionalLocationCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: PostEditAdditionalLocationCollectionViewCellDelegate?
    
    static let identifier = "PostEditAdditionalLocationCollectionViewCell"
    
    private let placeholder = "Add Additional Location Information..."
    
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
        
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView){
//        if textView.text == "Add Additional Location..."{
//            textView.text = nil
//        }
//    }
}

extension PostEditAdditionalLocationCollectionViewCell: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.postEditAdditionalLocationCollectionViewCellEndEditing(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 任意の処理
        textField.resignFirstResponder()
        return true
    }
    
}
