//
//  PhotoEditInfoCollectionCaptionViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/09.
//

import UIKit

protocol PhotoEditInfoCollectionCaptionViewCellDelegate: AnyObject{
    func photoEditInfoCollectionCaptionViewCellDidEndEditing(text: String)
}

class PhotoEditInfoCollectionCaptionViewCell: UICollectionViewListCell {
    static let identifier = "PhotoEditInfoCollectionCaptionViewCell"
    
    weak var delegate: PhotoEditInfoCollectionCaptionViewCellDelegate?
    
    public let field: UITextView = {
        let textView = UITextView()
        
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.borderColor = UIColor.secondaryLabel.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.autocapitalizationType = .none

        textView.layer.masksToBounds = true
        textView.font = .systemFont(ofSize: 16)
        textView.returnKeyType = .done
        textView.autocorrectionType = .no
        //textView.borderStyle = .none
        textView.keyboardType = .default
        textView.backgroundColor = .systemBackground
        //textView.placeholder = "キャプションを追加してください。"
        textView.text = "キャプションを追加してください。"
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(field)
        
        
        field.delegate = self
        
        self.addBorder(width: 0.5, color: UIColor.secondarySystemBackground, position: .bottom)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        field.frame = CGRect(x: 20, y: 10, width: contentView.width-40, height: contentView.height-20)
    }
}

//extension PhotoEditInfoCollectionCaptionViewCell: UITextFieldDelegate{
////    func textFieldDidEndEditing(_ textField: UITextField) {
////        print("atleasthere=====")
////        delegate?.photoEditInfoCollectionCaptionViewCellDidEndEditing(text: textField.text ?? "")
////
////    }
////
////    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
////        print("shoud end editing")
////        field.resignFirstResponder()
////        return true
////    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        return true
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
//        field.resignFirstResponder()
//        delegate?.photoEditInfoCollectionCaptionViewCellDidEndEditing(text: textField.text ?? "")
//        return true
//    }
//}

extension PhotoEditInfoCollectionCaptionViewCell: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == "キャプションを追加してください。"){
            textView.text = ""
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            print(text)
            delegate?.photoEditInfoCollectionCaptionViewCellDidEndEditing(text: textView.text ?? "")
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        field.resignFirstResponder()
        delegate?.photoEditInfoCollectionCaptionViewCellDidEndEditing(text: textView.text ?? "")
        
    }
}
