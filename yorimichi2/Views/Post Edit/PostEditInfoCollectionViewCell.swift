//
//  PostEditInfoCollectionViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/26.
//

import UIKit

protocol PostEditInfoCollectionViewCellDelegate: AnyObject{
    func postEditInfoCollectionViewCellEndEditing(_ cell: PostEditInfoCollectionViewCell)
}

class PostEditInfoCollectionViewCell: UICollectionViewCell {
    weak var delegate: PostEditInfoCollectionViewCellDelegate?
    
    static let identifier = "PostEditInfoCollectionViewCell"
    
    private let placeholder = "Add Info..."
    
    public let field : UITextField = {
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
        
        field.delegate = self
        field.placeholder = placeholder
        
        contentView.addSubview(field)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        field.frame = CGRect(x: 10, y: 0, width: contentView.width-20, height: contentView.height)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView){
        if textView.text == "Add Info..."{
            textView.text = nil
        }
    }
    
    
}

extension PostEditInfoCollectionViewCell: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.postEditInfoCollectionViewCellEndEditing(self)

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 任意の処理
        textField.resignFirstResponder()
        return true
    }
    

}
