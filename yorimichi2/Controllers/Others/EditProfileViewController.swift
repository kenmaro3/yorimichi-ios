//
//  EditProfileViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/21.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    public var completion: (() -> Void)?
    
    // Field
    private let nameField: TextField = {
        let field = TextField()
        field.placeholder = "Name..."
        return field
    }()
    
    private let bioTextView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        textView.backgroundColor = .secondarySystemBackground
        return textView
    }()
    
    private let twitterIdField: TextField = {
        let field = TextField()
        field.placeholder = "Twitter ID..."
        return field
    }()
    
    private let instagramIdField: TextField = {
        let field = TextField()
        field.placeholder = "Instagram ID..."
        return field
    }()
    
    private let twitterIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "twitter"))
        return imageView
    }()
    
    private let instagramIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "instagram"))
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "プロフィールの編集"
        
        view.addSubview(nameField)
        view.addSubview(bioTextView)
        view.addSubview(twitterIdField)
        view.addSubview(instagramIdField)
        view.addSubview(twitterIcon)
        view.addSubview(instagramIcon)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(didTapSave)
        )
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        DatabaseManager.shared.getUserInfo(username: username, completion: { [weak self] info in
            DispatchQueue.main.async {
                if let info = info {
                    self?.nameField.text = info.name
                    self?.bioTextView.text = info.bio
                    self?.twitterIdField.text = info.twitterId
                    self?.instagramIdField.text = info.instagramId
                }
            }
        })
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = .systemBackground
        
        nameField.frame = CGRect(
            x: 20,
            y: view.safeAreaInsets.top+10,
            width: view.width-40,
            height: 50
        )
        bioTextView.frame = CGRect(
            x: 20,
            y: nameField.bottom + 10,
            width: view.width-40,
            height: 120
        )
        let iconSize: CGFloat = 20
        twitterIcon.frame = CGRect(x: 20, y: bioTextView.bottom+10, width: iconSize, height: iconSize)
        twitterIdField.frame = CGRect(
            x: twitterIcon.right+20,
            y: bioTextView.bottom + 10,
            width: view.width-40 - iconSize - 20,
            height: 50
        )
        instagramIcon.frame = CGRect(x: 20, y: twitterIdField.bottom+10, width: iconSize, height: iconSize)
        instagramIdField.frame = CGRect(
            x: instagramIcon.right+20,
            y: twitterIdField.bottom + 10,
            width: view.width-40 - iconSize - 20,
            height: 50
        )
        twitterIcon.center.y = twitterIdField.center.y
        instagramIcon.center.y = instagramIdField.center.y
        
    }
    
    @objc private func didTapClose(){
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc private func didTapSave(){
        let name = nameField.text ?? ""
        let bio = bioTextView.text ?? ""
        let newInfo = UserInfo(name: name, bio: bio, twitterId: twitterIdField.text, instagramId: instagramIdField.text)
        DatabaseManager.shared.setUserInfo(userInfo: newInfo, completion: {[weak self] success in
            DispatchQueue.main.async {
                if success{
                    self?.completion?()
                    self?.didTapClose()
                }
            }
        })
        
    }
    
    
    

}
