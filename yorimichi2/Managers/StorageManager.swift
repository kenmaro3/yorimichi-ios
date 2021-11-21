//
//  StorageManager.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import Foundation
import FirebaseStorage

final class StorageManager{
    static let shared = StorageManager()
    
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    public func getVideoURL(with identifier: String, completion: (URL) -> Void){
        
    }
    
    public func uploadVideo(from url: URL, id: String, completion: @escaping (Bool) -> Void){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        storage.child("\(username)/videos/\(id).mov").putFile(from: url, metadata: nil, completion: {_, error in
            completion(error == nil)
        })
        
        
    }
    
    public func generateVideoName() -> String{
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...1000)
        let unixTimestamp = Date().timeIntervalSince1970
        return uuidString + "_\(number)_" + "\(unixTimestamp)"
    }
    
    
    public func uploadPost(
        data: Data?,
        id: String,
        completion: @escaping (URL?) -> Void
    )
    {
        guard let username = UserDefaults.standard.string(forKey: "username"),
              let data = data else{
                  return
              }
        
        let ref = storage.child("\(username)/posts/\(id).png")
        ref.putData(data, metadata: nil){ _, error in
            ref.downloadURL(completion: { url, _ in
                completion(url)
            })
        }
    }
    
    public func uploadThumbnail(
        data: Data?,
        id: String,
        completion: @escaping (URL?) -> Void
    )
    {
        guard let username = UserDefaults.standard.string(forKey: "username"),
              let data = data else{
                  return
              }
        
        let ref = storage.child("\(username)/videos/\(id).png")
        ref.putData(data, metadata: nil){ _, error in
            ref.downloadURL(completion: { url, _ in
                completion(url)
            })
        }
    }
    
    public func deletePost(post: Post, completion: @escaping(Bool) -> Void){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        let ref = storage.child("\(username)/posts/\(post.id).png")
        ref.delete(completion: { error in
            if let error = error {
               completion(false)
                return
            }
            else{
                completion(true)
                return
            }
            
        })
    }
    
    public func deleteVideoPost(post: Post, completion: @escaping(Bool) -> Void){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
       
        // Delete MOV
        var ref = storage.child("\(username)/videos/\(post.id).mov")
        ref.delete(completion: {[weak self] error in
            if let error = error {
               completion(false)
                return
            }
            else{
                guard let strongSelf = self else {
                    completion(false)
                    return
                }
                
                
                // Delete PNG (Thumbnail)
                ref = strongSelf.storage.child("\(username)/videos/\(post.id).png")
                ref.delete(completion: { error in
                    if let error = error {
                        completion(false)
                        return
                    }
                    else{
                        completion(true)
                        return
                    }
                    
                })
            }
        })
        
        
    }
    
    public func uploadYorimichiData(data: Data?, id: String, genre: String, completion: @escaping (URL?) -> Void){
        let ref = storage.child("yorimichiData/\(genre)/\(id).png")
        guard let data = data else{
            return
        }
        
        ref.putData(data, metadata: nil){ _, error in
            ref.downloadURL(completion: { url, _ in
                completion(url)
            })
        }
    }
    
    public func deleteYorimichiPost(post: Post, completion: @escaping(Bool) -> Void){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        let ref = storage.child("yorimichiData/\(post.genre)/\(post.id).png")
        ref.delete(completion: { error in
            if let error = error {
               completion(false)
                return
            }
            else{
                completion(true)
                return
            }
            
        })
    }
    
    public func downloadURL(for post: Post, completion: @escaping (URL?) -> Void){
        guard let ref = post.storageReference else {
            return
        }
        storage.child(ref).downloadURL(completion: {url, _ in
            completion(url)
        })
    }
    
    public func profilePictureURL(for username: String, completion: @escaping (URL?) -> Void){
        storage.child("\(username)/profile_picture.png").downloadURL(completion: { url, _ in
            completion(url)
        })
    }
    

    
    public func uploadProfilePicture(username: String, data: Data?, completion: @escaping (Bool) -> Void){
        guard let data = data else{
            return
        }
        
        storage.child("\(username)/profile_picture.png").putData(data, metadata: nil){ _, error in
            completion(error == nil)
        }
    }
    
    public func getDownLoadUrl(for post: Post, completion: @escaping(Result<URL, Error>) -> Void){
        storage.child(post.videoChildPath).downloadURL(completion: {url, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let url = url{
                completion(.success(url))
            }
        })
    }
    
    public func getDownLoadUrlFromYorimichiPost(for post: Post, completion: @escaping(Result<URL, Error>) -> Void){
        storage.child(post.videoChildPath).downloadURL(completion: {url, error in
            print("here=========")
            print(url)
            if let error = error {
                completion(.failure(error))
            }
            else if let url = url{
                completion(.success(url))
            }
        })
    }
    

}
