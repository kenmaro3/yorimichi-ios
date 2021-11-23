//
//  SignUpViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import SafariServices
import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    // SubView
    
    private let profilePictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .lightGray
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 45
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let usernameField: UITextField = {
        let field = TextField()
        field.placeholder = "ユーザーネーム"
        field.returnKeyType = .continue
        field.autocorrectionType = .no
        return field
    }()
    
    private let emailField: UITextField = {
        let field = TextField()
        field.placeholder = "メールアドレス"
        field.keyboardType = .emailAddress
        field.returnKeyType = .continue
        field.autocorrectionType = .no
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = TextField()
        field.placeholder = "パスワード"
        field.isSecureTextEntry = true
        field.keyboardType = .default
        field.returnKeyType = .next
        field.autocorrectionType = .no
        return field
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("登録する", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private let termsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("サービス利用規約", for: .normal)
        return button
    }()
    
    private let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("プライバシーポリシー", for: .normal)
        return button
    }()
    
    public var completion: (() -> Void)?
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "アカウントの作成"
        view.backgroundColor = .secondarySystemBackground
        
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        addSubViews()
        addButtonActions()
        addImageGesture()
    }
    
    private func addSubViews(){
        view.addSubview(profilePictureImageView)
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
    }
    
    private func addImageGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        profilePictureImageView.isUserInteractionEnabled = true
        profilePictureImageView.addGestureRecognizer(tap)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let imageSize: CGFloat = 90
        profilePictureImageView.frame = CGRect(x: (view.width-imageSize)/2, y: view.safeAreaInsets.top+15, width: imageSize, height: imageSize)
        
        usernameField.frame = CGRect(x: 25, y: profilePictureImageView.bottom+20, width: view.width-50, height: 50)
        emailField.frame = CGRect(x: 25, y: usernameField.bottom + 10, width: view.width-50, height: 50)
        passwordField.frame = CGRect(x: 25, y: emailField.bottom+10, width: view.width-50, height: 50 )
        
        signUpButton.frame = CGRect(x: 35, y: passwordField.bottom+20, width: view.width-70, height: 50)
        termsButton.frame = CGRect(x: 35, y: signUpButton.bottom+50, width: view.width-70, height: 40)
        privacyButton.frame = CGRect(x: 35, y: termsButton.bottom+10, width: view.width-70, height: 40)
    }
    
    private func addButtonActions(){
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTerm), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacy), for: .touchUpInside)
    }
    
    
    // MARK: - Actions
    
    @objc private func didTapImage(){
        let sheet = UIAlertController(title: "プロフィール写真", message: "プロフィール写真を登録して、プロフィールを充実させましょう。", preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "写真を撮る", style: .default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.allowsEditing = true
                picker.delegate = self
                self?.present(picker, animated: true)
            }
        }))
        
        sheet.addAction(UIAlertAction(title: "写真を選ぶ", style: .default, handler: {[weak self] _ in
            DispatchQueue.main.async{
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.allowsEditing = true
                picker.delegate = self
                self?.present(picker, animated: true)
                
            }
        }))
        
        present(sheet, animated: true)
    }
    
    @objc private func didTapSignUp(){
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let username = usernameField.text,
              let email = emailField.text,
              let password  = passwordField.text,
              !username.trimmingCharacters(in: .whitespaces).isEmpty,
              username.trimmingCharacters(in: .alphanumerics).isEmpty,
              username.count >= 2,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else{
                  presentError()
                  return
              }
        
        DatabaseManager.shared.isUsernameExist(username: username, completion: {[weak self] res in
            if res{
                let alert = UIAlertController(title: "ユーザーネームが無効です。", message: "ユーザーネームがすでに存在しています。他のユーザーネームをお選びください。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
                self?.present(alert, animated: true)
            }
            else{
                let data = self?.profilePictureImageView.image?.pngData()
                
                // Sign up with Auth Manager
                AuthManager.shared.signUp(email: email, username: username, password: password, profilePicture: data, completion: {[weak self] result in
                    switch result{
                    case .success(let user):
                        HapticManager.shared.vibrate(for: .success)
                        UserDefaults.standard.setValue(user.username, forKey: "username")
                        UserDefaults.standard.setValue(user.email, forKey: "email")
                        self?.navigationController?.popToRootViewController(animated: true)
                        self?.completion?()
                    case .failure(let error):
                        HapticManager.shared.vibrate(for: .error)
                        print("\n\nSignUp Error: \(error)")
                    }
                })
            }
            
        })
        
    }
    
    private func presentError(){
        let alert = UIAlertController(title: "無効な入力データ", message: "必須入力フィールドを全て入力し、パスワードは６文字以上であることを確認してください。", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func didTapTerm(){
        guard let url = URL(string: "https://yorimichi-project.webflow.io/image-license-info") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc private func didTapPrivacy(){
        guard let url = URL(string: "https://yorimichi-privacy-policy.webflow.io/") else{
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    
    // MARK: - Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField{
            emailField.becomeFirstResponder()
        }
        else if textField == emailField{
            passwordField.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
            didTapSignUp()
        }
        
        return true
    }
    
    
    // MARK: - Delegate Image Picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        
        profilePictureImageView.image = image
    }


}
