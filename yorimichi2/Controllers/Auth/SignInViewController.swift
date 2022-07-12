//
//  SignInViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import SafariServices
import UIKit
import ProgressHUD

class SignInViewController: UIViewController, UITextFieldDelegate{
    
    private var semiModalPresenter = SemiModalPresenter()
    
    // SubView
    private let headerView = SignInHeaderView()
    
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
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("上記ユーザでログイン", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private let signInAsGhostButton: UIButton = {
        let button = UIButton()
        button.setTitle("ゴーストモードでログイン", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("アカウントを作成する", for: .normal)
        return button
    }()
    
    private let termsButton: UIButton = {
        let button = UIButton()
        button.setTitle("サービス利用規約", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    private let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("プライバシーポリシー", for: .normal)
        return button
    }()
    
    private let infoSignInButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "info.circle"), for: .normal)
        button.tintColor = .label
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let infoGhostButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "info.circle"), for: .normal)
        button.tintColor = .label
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "サインイン"
        view.backgroundColor = .secondarySystemBackground
        
        emailField.delegate = self
        passwordField.delegate = self
        addSubViews()
        addButtonActions()

    }
    
    private func addSubViews(){
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(signInAsGhostButton)
        view.addSubview(infoSignInButton)
        view.addSubview(infoGhostButton)
        view.addSubview(termsButton)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
        view.addSubview(createAccountButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: (view.height - view.safeAreaInsets.top)/3)
        
        emailField.frame = CGRect(x: 25, y: headerView.bottom+20, width: view.width-50, height: 50)
        passwordField.frame = CGRect(x: 25, y: emailField.bottom+10, width: view.width-50, height: 50)
        signInButton.frame = CGRect(x: 25, y: passwordField.bottom+20, width: view.width-70, height: 50)
        infoSignInButton.frame = CGRect(x: signInButton.right + 10, y: passwordField.bottom+20+14, width: 20, height: 20)
        signInAsGhostButton.frame = CGRect(x: 25, y: signInButton.bottom+30, width: view.width-70, height: 50)
        infoGhostButton.frame = CGRect(x: signInAsGhostButton.right + 10, y: signInButton.bottom+30+14, width: 20, height: 20)
        createAccountButton.frame = CGRect(x: 35, y: signInAsGhostButton.bottom+20, width: view.width-70, height: 50)
        termsButton.frame = CGRect(x: 35, y: createAccountButton.bottom+50, width: view.width-70, height: 40)
        privacyButton.frame = CGRect(x: 35, y: termsButton.bottom+10, width: view.width-70, height: 40)
    }
    
    private func addButtonActions(){
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        signInAsGhostButton.addTarget(self, action: #selector(didTapSignInAsGhost), for: .touchUpInside)
        infoSignInButton.addTarget(self, action: #selector(didTapSignInInfo), for: .touchUpInside)
        infoGhostButton.addTarget(self, action: #selector(didTapGhostInfo), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTerm), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacy), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func didTapSignInInfo(){
        print("singin info tapped")
        let viewController = SignInModeInfoModalViewController()
        semiModalPresenter.viewController = viewController
        present(viewController, animated: true)
        
    }
    
    @objc private func didTapGhostInfo(){
        print("ghost info tapped")
        let viewController = GhostModeInfoModalViewController()
        semiModalPresenter.viewController = viewController
        present(viewController, animated: true)
        
    }
    
    @objc private func didTapSignInAsGhost(){
        print("ghost login tapped")
        // Sign In with Auth
        let email = "ghost@gmail.com"
        let password = "yorimichiGhostMode"
        ProgressHUD.show("ゴーストモードを使用します...")
        AuthManager.shared.signIn(email: email, password: password, completion: {[weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success:
                    UserDefaults.standard.setValue(email, forKey: "email")
                    
                    DatabaseManager.shared.findUser(with: email, completion: { user in
                        print("\n\n\n===========================")
                        print("user: \(user)")
                        guard let user = user else {
                            print("\n\n\n===========================")
                            print("cannot find user from Database with this email: \(email)")
                            ProgressHUD.dismiss()
                            return
                        }
                        UserDefaults.standard.setValue(user.username, forKey: "username")
                        UserDefaults.standard.setValue(true, forKey: "isGhost")
                        ProgressHUD.dismiss()
                        
                        HapticManager.shared.vibrate(for: .success)
                        let vc = GhostTabBarViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true, completion: nil)
                    })
                    
                case .failure(let error):
                    HapticManager.shared.vibrate(for: .error)
                    let alert = UIAlertController(title: "ログインエラー", message: "メールアドレスとパスワードを再度ご確認ください。", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                    print("here signin failure detected.")
                    print(error)
                    ProgressHUD.dismiss()
                }
            }
            
        })
    }
    
    @objc private func didTapSignIn(){
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else{
                 presentError()
                  return
              }
        
        // Sign In with Auth
        ProgressHUD.show("サインインしています...")
        AuthManager.shared.signIn(email: email, password: password, completion: {[weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success:
                    UserDefaults.standard.setValue(email, forKey: "email")
                    
                    DatabaseManager.shared.findUser(with: email, completion: { user in
                        print("\n\n\n===========================")
                        print("user: \(user)")
                        guard let user = user else {
                            print("\n\n\n===========================")
                            print("cannot find user from Database with this email: \(email)")
                            ProgressHUD.dismiss()
                            return
                        }
                        UserDefaults.standard.setValue(user.username, forKey: "username")
                        UserDefaults.standard.setValue(false, forKey: "isGhost")
                        ProgressHUD.dismiss()
                        
                        HapticManager.shared.vibrate(for: .success)
                        let vc = TabBarViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true, completion: nil)
                    })
                    
                case .failure(let error):
                    HapticManager.shared.vibrate(for: .error)
                    let alert = UIAlertController(title: "ログインエラー", message: "メールアドレスとパスワードを再度ご確認ください。", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                    print("here signin failure detected.")
                    print(error)
                    ProgressHUD.dismiss()
                }
            }
            
        })
                
    }
    
    private func presentError(){
        let alert = UIAlertController(title: "入力データが無効です。", message: "必須の入力フィールドを入力し、パスワードが６文字以上であることを確認してください。", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "了解", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func didTapCreateAccount(){
        let vc = SignUpViewController()
        vc.completion = { [weak self] in
            DispatchQueue.main.async {
                let tabVC = TabBarViewController()
                tabVC.modalPresentationStyle = .fullScreen
                self?.present(tabVC, animated: true)
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == emailField{
            passwordField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
            didTapSignIn()
        }
        return true
    }
    
    
    
}
