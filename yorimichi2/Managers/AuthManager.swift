//
//  AuthManager.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import Foundation
import FirebaseAuth
import ProgressHUD

final class AuthManager{
    static let shared = AuthManager()
    
    private init(){}
    
    enum AuthError: Error{
        case newUserCreation
        case signInFailed
    }
    
    let auth = Auth.auth()
    
    public var isSignedIn: Bool {
        let tmp = auth.currentUser
        return auth.currentUser != nil
    }
    
    
    public func signUp(email: String,
                       username: String,
                       password: String,
                       profilePicture: Data?,
                       completion: @escaping (Result<User, Error>) -> Void)
    {
        ProgressHUD.show("Creating Account...")
       let newUser = User(username: username, email: email)
        auth.createUser(withEmail: email, password: password, completion: {result, error in
            guard result != nil, error == nil else{
                ProgressHUD.dismiss()
                completion(.failure(AuthError.newUserCreation))
                return
            }
            
            DatabaseManager.shared.createUser(newUser: newUser) { success in
                if success{
                    ProgressHUD.dismiss()
                    StorageManager.shared.uploadProfilePicture(username: newUser.username, data: profilePicture, completion: { uploadSuccess in
                        if uploadSuccess{
                            completion(.success(newUser))
                        }
                        else{
                            completion(.failure(AuthError.newUserCreation))
                        }
                    })
                }
                else{
                    ProgressHUD.dismiss()
                    completion(.failure(AuthError.newUserCreation))
                }
                
            }
            
            
        })
    }
    
    public func signIn(email:String,
                       password: String,
                       completion: @escaping (Result<User, Error>) -> Void
    ){
        DatabaseManager.shared.findUser(with: email){ [weak self] user in
            guard let user = user else{
                print("cannot find user0")
                completion(.failure(AuthError.signInFailed))
                return
            }
            
            
            ProgressHUD.show("Signing In...")
            self?.auth.signIn(withEmail: email, password: password){ result, error in
                guard result != nil, error == nil else{
                    ProgressHUD.dismiss()
                    completion(.failure(AuthError.signInFailed))
                    return
                }
                
                UserDefaults.standard.setValue(user.username, forKey: "username")
                UserDefaults.standard.setValue(user.email, forKey: "email")
                
                ProgressHUD.dismiss()
                completion(.success(user))
            }
            
        }
        
        

    }
    
    public func signOut(completion: @escaping(Bool) -> Void){
        ProgressHUD.show("Siging Out...")
        do{
            try auth.signOut()
            ProgressHUD.dismiss()
            completion(true)
        }
        catch{
            print(error)
            ProgressHUD.dismiss()
            completion(false)
        }
    }
    
}
