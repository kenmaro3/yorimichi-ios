//
//  PostEditLocationCollectionViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/26.
//

import UIKit

protocol PostEditLocationCollectionViewCellDelegate: AnyObject{
    func postEditLocationCollectionViewCellEndEditing(_ cell: PostEditLocationCollectionViewCell)
}

class PostEditLocationCollectionViewCell: UICollectionViewCell {
    weak var delegate: PostEditLocationCollectionViewCellDelegate?
    
    static let identifier = "PostEditLocationCollectionViewCell"
    
    private let placeholder = "Add Location..."
    
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
    
    public func configure(with location: Location){
        field.text = "\(location.lat), \(location.lng)"
    }
    

}


extension PostEditLocationCollectionViewCell: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.postEditLocationCollectionViewCellEndEditing(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 任意の処理
        textField.resignFirstResponder()
        return true
    }
}
