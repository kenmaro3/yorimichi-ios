//
//  CommentBarView.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/23.
//

import UIKit

protocol CommentBarViewDelegate: AnyObject{
    func commentBarViewDidTapComment(_ commentBarView: CommentBarView, withText text: String)
//    func commentBarViewDidTapGenreButton(_ sender: UIButton)
}

class CommentBarView: UIView{
    
    weak var delegate: CommentBarViewDelegate?
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("投稿", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    private let genreButton: UIButton = {
        let button = UIButton()
        button.setTitle("テスト", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.masksToBounds = true
        return button
    }()
    
    public let field: UITextView = {
        let field = UITextView()
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 8
        
        field.backgroundColor = .white
        field.tintColor = .black
        field.textColor = .black
        //field.clearButtonMode = .whileEditing
        field.returnKeyType = .done
        field.text = "この場所のメニュー情報を追加しましょう。"
        //field.attributedPlaceholder = NSAttributedString(string: "この場所のメニュー情報を投稿しましょう。", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        return field
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(button)
        addSubview(field)
        //addSubview(genreButton)
        
        button.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
//        genreButton.addTarget(self, action: #selector(didTapGenreButton), for: .touchUpInside)
        backgroundColor = .white
        field.delegate = self
        
    }
    
//    @objc func didTapGenreButton(_ sender: UIButton){
//        delegate?.commentBarViewDidTapGenreButton(sender)
//    }
    
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
//        genreButton.sizeToFit()
        button.frame = CGRect(x: width-button.width-4-2, y: (height-button.height)/2, width: button.width, height: button.height)
        field.frame = CGRect(x: 6, y: (height-50)/2, width: width-button.width - 18, height: 50)
                genreButton.sizeToFit()
        
//        genreButton.frame = CGRect(x: 2, y: (height-button.height)/2 - field.height - 6, width: genreButton.width, height: genreButton.height)
//        genreButton.layer.cornerRadius = 4
//        genreButton.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 7.0, bottom: 5.0, right: 7.0)

    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        field.resignFirstResponder()
        didTapComment()
        return true
    }
    

}

extension CommentBarView: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let defaultStrings = [
            "この場所のメニュー情報を追加しましょう。",
            "この場所の価格情報を追加しましょう。",
            "この場所の営業時間情報を追加しましょう。",

        ]
        
        if (defaultStrings.contains(textView.text)){
            textView.text = ""
            
        }
    }
    
}
