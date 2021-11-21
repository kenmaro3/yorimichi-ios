//
//  CommentBarView.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/23.
//

import UIKit

protocol CommentBarViewDelegate: AnyObject{
    func commentBarViewDidTapComment(_ commentBarView: CommentBarView, withText text: String)
}

class CommentBarView: UIView , UITextFieldDelegate{
    
    weak var delegate: CommentBarViewDelegate?
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("投稿", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    public let field: TextField = {
        let field = TextField()
        //field.placeholder = "コメントを投稿しましょう。"
        
        field.backgroundColor = .white
        field.tintColor = .black
        field.textColor = .black
        field.clearButtonMode = .whileEditing
        field.returnKeyType = .done
        field.attributedPlaceholder = NSAttributedString(string: "コメントを投稿しましょう。", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        return field
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(button)
        addSubview(field)
        button.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        backgroundColor = .white
        field.delegate = self
        
    }
    
    @objc func didTapComment(){
        guard let text = field.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        
        delegate?.commentBarViewDidTapComment(self, withText: text)
        field.resignFirstResponder()
        field.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.sizeToFit()
        button.frame = CGRect(x: width-button.width-4-2, y: (height-button.height)/2, width: button.width, height: button.height)
        field.frame = CGRect(x: 2, y: (height-50)/2, width: width-button.width-12, height: 50)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        field.resignFirstResponder()
        didTapComment()
        return true
    }
    

}
