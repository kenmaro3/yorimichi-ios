//
//  PhotoEditInfoCollectionLocationDirectViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/12/20.
//

import UIKit

protocol PhotoEditInfoCollectionLocationDirectViewCellDelegate: AnyObject{
    func photoEditInfoCollectionLocationDirectViewCellDidEndEditing(text: String)
}

class PhotoEditInfoCollectionLocationDirectViewCell: UICollectionViewCell {
    static let identifier = "PhotoEditInfoCollectionLocationDirectViewCell"
    
    weak var delegate: PhotoEditInfoCollectionLocationDirectViewCellDelegate?
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "場所情報"
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor.label
        return label
        
    }()
    
    public let field: UITextField = {
        let textView = TextField()

        textView.layer.masksToBounds = true
        textView.font = .systemFont(ofSize: 16)
        textView.returnKeyType = .done
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.borderStyle = .none
        textView.keyboardType = .default
        textView.backgroundColor = .systemBackground
        textView.placeholder = "名称を入力してください。"
        
        return textView
    }()
    
    private let locationLabel2: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor.secondaryLabel
        label.clipsToBounds = true
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(titleLabel)
        contentView.addSubview(field)
        contentView.addSubview(locationLabel2)
        self.addBorder(width: 0.5, color: UIColor.secondarySystemBackground, position: .bottom)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 15, y: (contentView.height-titleLabel.height)/2, width: titleLabel.width, height: titleLabel.height)
        
        //locationLabel1.sizeToFit()
        field.frame = CGRect(x: titleLabel.right + 20, y: (contentView.height-50)/3, width: contentView.width-titleLabel.width - 40, height: 50)
        
        
        
        locationLabel2.sizeToFit()
        let locationLabel2Width = min(locationLabel2.width, contentView.width - titleLabel.width - 40)
        locationLabel2.frame = CGRect(x: titleLabel.right + 20, y: field.bottom+5, width: locationLabel2Width, height: locationLabel2.height)

        
    }
    
    public func configure(viewModel: PhotoEditInfoLocationViewModel){
        locationLabel2.text = "現在地"
        
    }
}

extension PhotoEditInfoCollectionLocationDirectViewCell: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        field.resignFirstResponder()
        delegate?.photoEditInfoCollectionLocationDirectViewCellDidEndEditing(text: textField.text ?? "")
        return true
    }
}

