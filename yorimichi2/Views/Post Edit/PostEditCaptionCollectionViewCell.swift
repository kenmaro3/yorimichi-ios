//
//  PostEditCaptionCollectionViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/26.
//

import UIKit

protocol PostEditCaptionCollectionViewCellDelegate: AnyObject{
    func postEditCaptionCollectionViewCellEndEditing(_ cell: PostEditCaptionCollectionViewCell)
}


class PostEditCaptionCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: PostEditCaptionCollectionViewCellDelegate?
    
    static let identifier = "PostEditCaptionCollectionViewCell"
    
    public let placeholder = "Add Caption..."
    
    public let field: UITextField = {
        let textView = TextField()

        textView.layer.masksToBounds = true
        textView.font = .systemFont(ofSize: 16)
        textView.returnKeyType = .next
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        
        return textView
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
    
}

extension PostEditCaptionCollectionViewCell: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.postEditCaptionCollectionViewCellEndEditing(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 任意の処理
        textField.resignFirstResponder()
        return true
    }
    
}
