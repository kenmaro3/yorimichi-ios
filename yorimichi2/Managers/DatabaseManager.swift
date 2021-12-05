//
//  DatabaseManager.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import Foundation
import FirebaseFirestore
import Mapbox

final class DatabaseManager{
    static let shared = DatabaseManager()
    
    private init(){}
    
    let database = Firestore.firestore()
    
    public func getMapStyle(completion: @escaping(String) -> MGLMapView){
        let ref = database.collection("customMaps").document("currentMap")
        
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let data = document.data() else {
                    completion("mapbox://styles/mapbox/streets-v11")
                    return
                }
                guard let styleUrl = data["styleUrl"] as? String else {
                    completion("mapbox://styles/mapbox/streets-v11")
                    return
                    
                }
                completion(styleUrl)
            } else {
                completion("mapbox://styles/mapbox/streets-v11")
                return
                
            }
        }
    }
    
    
    public func findUsers(with usernamePrefix: String, completion: @escaping([User]) -> Void){
        let ref = database.collection("users")
        ref.getDocuments{ snapshot, error in
//            guard let users = snapshot?.documents, error == nil else{
            guard let users = snapshot?.documents.compactMap({User(with: $0.data())}), error == nil else{
                completion([])
                return
            }
            
//            let userData = users.compactMap({ $0.data()})
//            let myUser = userData.compactMap({ User(with: $0)})
            
            let subset = users.filter({
                $0.username.lowercased().hasPrefix(usernamePrefix.lowercased())
            })
            
            completion(subset)
        }
        
    }
    
    public func findPlacesSubString(with prefix: String, completion: @escaping([String]) -> Void){
        let ref = database.collection("yorimichiPost").document("A000").collection("posts")
        ref.getDocuments{ snapshot, error in
//            guard let users = snapshot?.documents, error == nil else{
            guard let posts = snapshot?.documents.compactMap({Post(with: $0.data())}), error == nil else{
                completion([])
                return
            }
            
            
            let subset = posts.filter({
                $0.locationTitle.lowercased().contains(prefix.lowercased()) || $0.locationSubTitle.lowercased().contains(prefix.lowercased())
                //$0.locationTitle.lowercased().hasPrefix(prefix.lowercased())
            })
            
            let subsetString = subset.map{
                $0.locationTitle
            }
            let uniqueResult = subsetString.reduce([], { $0.contains($1) ? $0 : $0 + [$1] })
            completion(uniqueResult)

            
        }
        
    }
    
    public func findPlaces(with keyword: String, completion: @escaping([Post]) -> Void){
        let ref = database.collection("yorimichiPost").document("A000").collection("posts")
        let query = ref.whereField("locationTitle", isEqualTo: keyword)
        query.getDocuments{ snapshot, error in
            guard let posts = snapshot?.documents.compactMap({Post(with: $0.data())}), error == nil else{
                completion([])
                return
            }
            completion(posts)

            
        }
        
    }
    
    public func posts(for username: String, completion: @escaping (Result<[Post], Error>) -> Void){
        let ref = database.collection("users")
            .document(username)
            .collection("posts")
        ref.getDocuments{ snapshot, error in
            guard let posts = snapshot?.documents.compactMap({
                Post(with: $0.data())
            }).sorted(by: { first, second in
                return first.date > second.date
                
            }),
                  error == nil else{
                return
            }
            
            completion(.success(posts))
            
            
            
        }
        
    }
    
    
    public func postsRecent(for username: String, completion: @escaping (Result<[Post], Error>) -> Void){
        let ref = database.collection("users")
            .document(username)
            .collection("posts")
        ref.getDocuments{ snapshot, error in
            guard let posts = snapshot?.documents.compactMap({
                Post(with: $0.data())
            }).sorted(by: { first, second in
                return first.date > second.date
                
            }),
                  error == nil else{
                return
            }
            
            let now = Date()
            let modifiedDate = Calendar.current.date(byAdding: .day, value: -7, to: now)!
            
            let recentPosts = posts.filter{
                $0.date > modifiedDate
                
            }
            
            if recentPosts.count > 3{
                let limitedPosts = recentPosts[..<3]
                completion(.success(Array(limitedPosts)))
            }else{
                completion(.success(recentPosts))
            }
            
            
            
        }
        
    }
    
    public func videoPostsRecent(for username: String, completion: @escaping (Result<[Post], Error>) -> Void){
        let ref = database.collection("users")
            .document(username)
            .collection("videos")
        ref.getDocuments{ snapshot, error in
            guard let posts = snapshot?.documents.compactMap({
                Post(with: $0.data())
            }).sorted(by: { first, second in
                return first.date > second.date
                
            }),
                  error == nil else{
                return
            }
            

            let now = Date()
            let modifiedDate = Calendar.current.date(byAdding: .day, value: -7, to: now)!
            
            let recentPosts = posts.filter{
                $0.date > modifiedDate
                
            }
            
            if recentPosts.count > 3{
                let limitedPosts = recentPosts[..<3]
                completion(.success(Array(limitedPosts)))
            }else{
                completion(.success(recentPosts))
            }
            
            
            
        }
        
    }
    
    public func videoPosts(for username: String, completion: @escaping (Result<[Post], Error>) -> Void){
        let ref = database.collection("users")
            .document(username)
            .collection("videos")
        ref.getDocuments{ snapshot, error in
            guard let posts = snapshot?.documents.compactMap({
                Post(with: $0.data())
            }).sorted(by: { first, second in
                return first.date > second.date
                
            }),
                  error == nil else{
                return
            }
            
            completion(.success(posts))
            
            
            
        }
        
    }
    
    public func findUser(with email: String, completion: @escaping (User?) -> Void){
        let ref = database.collection("users")
        ref.getDocuments{ snapshot, error in
//            guard let users = snapshot?.documents, error == nil else{
            print(snapshot?.documents)
            guard let users = snapshot?.documents.compactMap({User(with: $0.data())}), error == nil else{
                completion(nil)
                return
            }
            
//            let userData = users.compactMap({ $0.data()})
//            let myUser = userData.compactMap({ User(with: $0)})
            
            let user = users.first(where: {$0.email == email})
            completion(user)
            
        }
    }
    
    public func findUser(username: String, completion: @escaping (User?) -> Void){
        let ref = database.collection("users")
        ref.getDocuments{ snapshot, error in
//            guard let users = snapshot?.documents, error == nil else{
            guard let users = snapshot?.documents.compactMap({User(with: $0.data())}), error == nil else{
                completion(nil)
                return
            }
            
            
            let user = users.first(where: {$0.username == username})
            completion(user)
            
        }
    }
    
    
    /// Get userName list of username not following
    public func getNotFollowing(username: String, completion: @escaping ([String]) -> Void){
        var res = [String]()
        self.following(for: username, completion: {[weak self] followings in
            var ref = self?.database.collection("users").limit(to: 20)
            if (followings.count > 0){
                ref = self?.database.collection("users").whereField("username", notIn: followings).limit(to: 20)
            }
            ref?.getDocuments{ snapshot, error in
                guard let users = snapshot?.documents.compactMap({User(with: $0.data())?.username}), error == nil else{
                    completion([])
                    return
                }
                completion(users)
            }
        })
    }
    
    /// Get userName list of username neither not following nor blocking nor myself
    public func getNotFollowingNotBlocking(username: String, completion: @escaping ([String]) -> Void){
        var res = [String]()
        var usersNotIn = [String]()
        self.following(for: username, completion: {[weak self] followings in
            self?.blocks(for: username, completion: { blocks in
                var ref = self?.database.collection("users").limit(to: 20)
                usersNotIn = usersNotIn + followings
                usersNotIn = usersNotIn + blocks
                if (usersNotIn.count > 0){
                    ref = self?.database.collection("users").whereField("username", notIn: usersNotIn).limit(to: 20)
                }
                ref?.getDocuments{ snapshot, error in
                    guard let users = snapshot?.documents.compactMap({User(with: $0.data())?.username}), error == nil else{
                        completion([])
                        return
                    }
                    
                    let usersWithoutMyself = users.filter{
                        $0 != username
                    }
                    completion(usersWithoutMyself)
                }
            })
        })
    }
    
    public func isUsernameExist(username: String, completion: @escaping (Bool) -> Void){
        let ref = database.collection("users")
        ref.getDocuments{ snapshot, error in
//            guard let users = snapshot?.documents, error == nil else{
            guard let usernames = snapshot?.documents.compactMap({User(with: $0.data())?.username}), error == nil else{
                completion(false)
                return
            }
            
            if usernames.contains(username){
                completion(true)
            }
            else{
                completion(false)
            }
            
        }
        
    }
    
    
    public func createVideoPost(post: Post, completion: @escaping (Bool) -> Void){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return
        }
        
        let reference = database.document("users/\(username)/videos/\(post.id)")
        guard let data = post.asDictionary() else{
            completion(false)
            return
        }
        reference.setData(data){ error in
            completion(error == nil)
            
        }
    }
    
    public func createPost(post: Post, completion: @escaping (Bool) -> Void){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return
        }
        
        let reference = database.document("users/\(username)/posts/\(post.id)")
        guard let data = post.asDictionary() else{
            completion(false)
            return
        }
        reference.setData(data){ error in
            completion(error == nil)
            
        }
    }
    
    public func deletePost(post: Post, completion: @escaping(Bool) -> Void){
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return
        }
        
        let reference = database.document("users/\(username)/posts/\(post.id)")
        reference.delete(completion: { error in
            if let error = error{
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
            completion(false)
            return
        }
        
        let reference = database.document("users/\(username)/videos/\(post.id)")
        reference.delete(completion: { error in
            if let error = error{
                completion(false)
                return
            }
            else{
                completion(true)
                return
                
            }
            
        })
    }
    
    public func deleteYorimichiPost(post: Post, completion: @escaping(Bool) -> Void){
        let reference = database.document("yorimichiPost/\(post.genre.code)/posts/\(post.id)")
        reference.delete(completion: {error in
            if let error = error{
                completion(false)
                return
            }
            else{
                completion(true)
                return
                
            }
            
        })
    }
    
    public func deleteYorimichiPostAtAll(post: Post, completion: @escaping(Bool) -> Void){
        let reference = database.document("yorimichiPost/A000/posts/\(post.id)")
        reference.delete(completion: {error in
            if let error = error{
                completion(false)
                return
            }
            else{
                completion(true)
                return
                
            }
            
        })
    }
    
    public func deleteYorimichiVideoPost(post: Post, completion: @escaping(Bool) -> Void){
        let reference = database.document("yorimichiPost/\(post.genre.code)/videos/\(post.id)")
        reference.delete(completion: {error in
            if let error = error{
                completion(false)
                return
            }
            else{
                completion(true)
                return
                
            }
            
        })
    }
    
    public func deleteYorimichiVideoPostAtAll(post: Post, completion: @escaping(Bool) -> Void){
        let reference = database.document("yorimichiPost/A000/videos/\(post.id)")
        reference.delete(completion: {error in
            if let error = error{
                completion(false)
                return
            }
            else{
                completion(true)
                return
                
            }
            
        })
    }
    
    public func createYorimichiPost(post: Post, completion: @escaping(Bool) -> Void){
        let reference = database.document("yorimichiPost/\(post.genre.code)/posts/\(post.id)")
        guard let data = post.asDictionary() else {
            completion(false)
            return
        }
        
        reference.setData(data){ error in
            completion(error == nil)
        }
    }
    
    public func createYorimichiPostAtAll(post: Post, completion: @escaping(Bool) -> Void){
        let reference = database.document("yorimichiPost/A000/posts/\(post.id)")
        guard let data = post.asDictionary() else {
            completion(false)
            return
        }
        
        reference.setData(data){ error in
            completion(error == nil)
        }
    }
    
    public func createYorimichiVideoPost(post: Post, completion: @escaping(Bool) -> Void){
        let reference = database.document("yorimichiPost/\(post.genre.code)/videos/\(post.id)")
        guard let data = post.asDictionary() else {
            completion(false)
            return
        }
        
        reference.setData(data){ error in
            completion(error == nil)
        }
    }
    
    public func createYorimichiVideoPostAtAll(post: Post, completion: @escaping(Bool) -> Void){
        let reference = database.document("yorimichiPost/A000/videos/\(post.id)")
        guard let data = post.asDictionary() else {
            completion(false)
            return
        }
        
        reference.setData(data){ error in
            completion(error == nil)
        }
    }
    
    public func createUser(newUser: User, completion: @escaping (Bool) -> Void){
        let reference = database.document("users/\(newUser.username)")
        
        guard let data = newUser.asDictionary() else {
            completion(false)
            return
        }
        reference.setData(data) {error in
            completion(error == nil)
        }
        
    }
    
    public func getAllUsersString(completion: @escaping ([String]) -> Void){
        let ref = database.collection("users")
        
        ref.getDocuments(completion: { snapshot, error in
            guard let usernames = snapshot?.documents.compactMap({ $0.documentID}), error == nil else{
                completion([])
                return
            }
            completion(usernames)
            
        })
    }
    
    
    public func explorePosts(completion: @escaping ([Post]) -> Void){
        let ref = database.collection("yorimichiPost").document("A000").collection("posts")
        ref.getDocuments{ snapshot, error in
//            guard let users = snapshot?.documents, error == nil else{
            guard var posts = snapshot?.documents.compactMap({Post(with: $0.data())}), error == nil else{
                completion([])
                return
            }
            
            //posts.shuffle()
            if posts.count > 16{
                let limitedPosts = posts[..<16]
                completion(Array(limitedPosts))
            }else{
                completion(posts)
            }
            
        }
    }
    
    public func exploreYorimichiPosts(genre: GenreInfo, refLocation: Location, completion: @escaping ([Post]) -> Void){
        let ref = database.collection("yorimichiPost").document(genre.code).collection("posts")
        let latUpperLimit = refLocation.lat + 0.01
        let latLowerLimit = refLocation.lat - 0.01
        
//        let lngUpperLimit = refLocation.lng + 0.01
//        let lngLowerLimit = refLocation.lng - 0.01
        
        let limitedRef = ref
            .whereField("location.lat", isLessThan: latUpperLimit)
            .whereField("location.lat", isGreaterThan: latLowerLimit)
//            .whereField("location.lng", isLessThan: lngUpperLimit)
//            .whereField("location.lng", isGreaterThan: lngLowerLimit)
        limitedRef.getDocuments{[weak self] snapshot, error in
            guard let places = snapshot?.documents.compactMap({Post(with: $0.data())}), error == nil else{
                completion([])
                return
                
            }
            print("here")
            print(places)
            self?.filterLng(places: places, refLocation: refLocation, completion: { places in
                print("after lng filter")
                print(places)
                completion(places)
                
            })
       }
    }
    
    public func exploreYorimichiVideoPosts(genre: GenreInfo, refLocation: Location, completion: @escaping ([Post]) -> Void){
        let ref = database.collection("yorimichiPost").document(genre.code).collection("videos")
        let latUpperLimit = refLocation.lat + 0.01
        let latLowerLimit = refLocation.lat - 0.01
        
//        let lngUpperLimit = refLocation.lng + 0.01
//        let lngLowerLimit = refLocation.lng - 0.01
        
        let limitedRef = ref
            .whereField("location.lat", isLessThan: latUpperLimit)
            .whereField("location.lat", isGreaterThan: latLowerLimit)
//            .whereField("location.lng", isLessThan: lngUpperLimit)
//            .whereField("location.lng", isGreaterThan: lngLowerLimit)
        limitedRef.getDocuments{[weak self] snapshot, error in
            guard let places = snapshot?.documents.compactMap({Post(with: $0.data())}), error == nil else{
                completion([])
                return
                
            }
            print("here")
            print(places)
            self?.filterLng(places: places, refLocation: refLocation, completion: { places in
                print("after lng filter")
                print(places)
                completion(places)
                
            })
       }
    }
    
    private func filterLng(places: [Post], refLocation: Location, completion: @escaping ([Post]) -> Void){
        let lngUpperLimit = refLocation.lng + 0.01
        let lngLowerLimit = refLocation.lng - 0.01
        
        var filteredPost: [Post] = []
        
        places.forEach{ place in
            if place.location.lng >= lngLowerLimit && place.location.lng <= lngUpperLimit {
                filteredPost.append(place)
            }
        }
        completion(filteredPost)
    }
            
////            guard let users = snapshot?.documents, error == nil else{
//            guard let users = snapshot?.documents.compactMap({User(with: $0.data())}), error == nil else{
//                completion([])
//                return
//            }
            
//            let group = DispatchGroup()
//            var aggregatePosts = [(post: Post, user: User)]()
//            users.forEach{ user in
//                let username = user.username
//                let postRef = self.database.collection("users/\(username)/posts")
//                group.enter()
//
//                postRef.getDocuments{ snapshot, error in
//                    defer{
//                        group.leave()
//                    }
//
//                    guard let posts = snapshot?.documents.compactMap({Post(with: $0.data())}), error == nil else{
//                        completion([])
//                        return
//                    }
//                    aggregatePosts.append(contentsOf: posts.compactMap({
//                        (post: $0, user: user)
//                    }))
//                }
//            }
//
//            group.notify(queue: .main){
//                completion(aggregatePosts)
//            }
//        }
//    }
    
    public func getNotifications(completion: @escaping ([IGNotification]) -> Void){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            completion([])
            return
        }
        let ref = database.collection("users").document(username).collection("notifications")
        ref.getDocuments{ snapshot, error in
            guard let notifications = snapshot?.documents.compactMap({
                IGNotification(with: $0.data())
            }),
                  error == nil else{
                      completion([])
                      return
                  }
            
            completion(notifications)
        }
    }
    
    public func insertNotification(identifier: String, data: [String: Any], for username: String){
        let ref = database
            .collection("users")
            .document(username)
            .collection("notifications")
            .document(identifier)
        
        ref.setData(data)
        
    }
    
//    public func getPostFromYorimichi(with post: Post, completion: @escaping(Post?) -> Void){
//
//        let ref = database.collection("users").document(post.user.username).collection("posts").document(post.id)
//        ref.getDocument(completion: {snapshot, error in
//            guard let data = snapshot?.data(),
//                  let post = Post(with: data),
//                  error == nil else{
//                      completion(nil)
//                      return
//                  }
//
//            completion(post)
//        })
//    }
    
//    public func getVideoPostFromYorimichi(with post: YorimichiPost, completion: @escaping(PostModel?) -> Void){
//
//        let ref = database.collection("users").document(post.user.username).collection("videos").document(post.id)
//        ref.getDocument(completion: {snapshot, error in
//            guard let data = snapshot?.data(),
//                  let post = PostModel(with: data),
//                  error == nil else{
//                      completion(nil)
//                      return
//                  }
//
//            completion(post)
//        })
//    }
    
    
    public func getPost(with identifier: String, from username: String, completion: @escaping(Post?) -> Void){
        let ref = database.collection("users").document(username).collection("posts").document(identifier)
        ref.getDocument(completion: {snapshot, error in
            guard let data = snapshot?.data(),
                  let post = Post(with: data),
                  error == nil else{
                      completion(nil)
                      return
            }
            
            completion(post)
        })
        
    }
    
    public func getVideoPost(with identifier: String, from username: String, completion: @escaping(Post?) -> Void){
        let ref = database.collection("users").document(username).collection("videos").document(identifier)
        ref.getDocument(completion: {snapshot, error in
            guard let data = snapshot?.data(),
                  let post = Post(with: data),
                  error == nil else{
                      completion(nil)
                      return
            }
            
            completion(post)
        })
        
    }
    
    public func getYorimichiPost(with identifier: String, from genre: GenreInfo, completion: @escaping(Post?) -> Void){
        let ref = database.collection("yorimichiPost").document(genre.code).collection("posts").document(identifier)
        ref.getDocument(completion: {snapshot, error in
            guard let data = snapshot?.data(),
                  let post = Post(with: data),
                  error == nil else{
                      completion(nil)
                      return
            }
            
            completion(post)
        })
        
    }
    
//    public func getPostsFromFollowers(){
//
//        var res: [Post] = []
//
//        let group = DispatchGroup()
//        guard let user = UserDefaults.standard.string(forKey: "username") else {
//            return
//        }
//        self.followers(for: user, completion: { followers in
//            followers.map{ follower in
//                self.posts(for: follower, completion: { results in
//                    switch results{
//                    case .success(let posts):
//                        res = res + posts
//                    case .failure(_):
//                        break
//                    }
//
//                }
//
//                )
//
//            }
//        })
//
//    }
    
    enum RelationshipState{
        case follow
        case unfollow
    }
    
    public func updateRelationship(state: RelationshipState, for targetUsername: String, completion: @escaping(Bool) -> Void){
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return
        }
        
        //let currentFollowers = database.collection("users").document(currentUsername).collection("followers")
        let currentFollowing = database.collection("users").document(currentUsername).collection("following")
        
        let targetUserFollowers = database.collection("users").document(targetUsername).collection("followers")
        //let targetUserFollowing = database.collection("users").document(targetUsername).collection("following")
                
        
        switch state{
        case .unfollow:
            // Remove follower from requester following list
            currentFollowing.document(targetUsername).delete()
            // Remove follower from targetUser follower list
            targetUserFollowers.document(currentUsername).delete()
            completion(true)
        case .follow:
            // Add follower to requester following list
            currentFollowing.document(targetUsername).setData(["valid": 1])
            // Add follower to targetUser follower list
            targetUserFollowers.document(currentUsername).setData(["valid": 1])
            completion(true)
        }
    }
    
    enum BlockState{
        case block
        case notBlock
    }
    
    /// Get users that username blocks
    public func blocks(for username: String, completion: @escaping ([String]) -> Void){
        let ref = database.collection("users").document(username).collection("blocks")
        ref.getDocuments(completion: { snapshot, error in
            guard let usernames = snapshot?.documents.compactMap({ $0.documentID }), error == nil else{
                completion([])
                return
            }
            completion(usernames)
        })
        
    }
    
    /// Update Block state of username against targetUser
    public func updateBlock(state: BlockState, for targetUsername: String, completion: @escaping(Bool) -> Void){
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return
        }
        
        let currentBlocks = database.collection("users").document(currentUsername).collection("blocks")
        
        
        switch state{
        case .notBlock:
            // Remove targetUserName from requester blocks list
            currentBlocks.document(targetUsername).delete()
            completion(true)
        case .block:
            // Add targetUserName to requester blocks list
            currentBlocks.document(targetUsername).setData(["valid": 1])
            completion(true)
        }
    }
    
    
    /// check if username is blocking targetUser or not
    public func isTargetUserBlocked(for username: String, with targetUser: String, completion: @escaping(Bool) -> Void){
        let ref = database.collection("users").document(username).collection("blocks").document(targetUser)
        ref.getDocument(completion: { snapshot, error in
            guard snapshot?.data() != nil, error == nil else{
                // username not blocking targetUser
                completion(false)
                return
            }
            // username blocking targetUser
            completion(true)
        })
        
    }
    
    
    /// get counts of post, followings, followers of username
    public func getUserCounts(username: String, complete: @escaping ((followers: Int, following: Int, posts: Int)) -> Void){
        let userRef = database.collection("users").document(username)
        var followers = 0
        var following = 0
        var photoPostCount = 0
        var videoPostCount = 0
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        group.enter()
        
        
        userRef.collection("posts").getDocuments(completion: {snapshot, error in
            defer{
                group.leave()
            }
            guard let count = snapshot?.documents.count, error == nil else{
                return
            }
            
            photoPostCount = count
            
        })
        
        userRef.collection("videos").getDocuments(completion: {snapshot, error in
            defer{
                group.leave()
            }
            guard let count = snapshot?.documents.count, error == nil else{
                return
            }
            
            videoPostCount = count
            
        })
        userRef.collection("followers").getDocuments(completion: {snapshot, error in
            defer{
                group.leave()
            }
            guard let count = snapshot?.documents.count, error == nil else{
                return
            }
            followers = count
            
        })
        userRef.collection("following").getDocuments(completion: {snapshot, error in
            defer{
                group.leave()
            }
            guard let count = snapshot?.documents.count, error == nil else{
                return
            }
            following = count
            
        })
        
        group.notify(queue: .global()){
            let result = (
                followers: followers,
                following: following,
                posts: photoPostCount + videoPostCount
            
            )
            
            complete(result)
        }
    }
    
    
    /// check username is following targetUsername or not
    public func isFollowing(targetUsername: String, completion: @escaping (Bool) -> Void){
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return
        }
        let ref = database.collection("users").document(targetUsername).collection("followers").document(currentUsername)
        ref.getDocument(completion: { snapshot, error in
            guard snapshot?.data() != nil, error == nil else{
                // Not following
                completion(false)
                return
            }
            // Following
            completion(true)
        })
        
        
    }
    
    
    /// Get userInformation about username and bios
    public func getUserInfo(username: String, completion: @escaping (UserInfo?) -> Void){
        let ref = database.collection("users").document(username).collection("information").document("basic")
        ref.getDocument(completion: { snapshot, error in
            guard let data = snapshot?.data(),
                  let userInfo = UserInfo(with: data),
                    error == nil else{
                completion(nil)
                return
            }
            
            completion(userInfo)
            
            
        })
    }
    
    
    
    /// Set userInformation about username and bios
    public func setUserInfo(userInfo: UserInfo, completion: @escaping (Bool) -> Void){
        guard let username = UserDefaults.standard.string(forKey: "username"),
              let data = userInfo.asDictionary()
        else {
            completion(false)
            return
        }
        let ref = database.collection("users").document(username).collection("information").document("basic")
        
        ref.setData(data){error in
            completion(error == nil)
            
        }
    }
    
    
    /// Get users that user followes username
    public func followers(for username: String, completion: @escaping ([String]) -> Void){
        let ref = database.collection("users").document(username).collection("followers")
        ref.getDocuments(completion: { snapshot, error in
            guard let usernames = snapshot?.documents.compactMap({ $0.documentID}), error == nil else{
                completion([])
                return
            }
            completion(usernames)
            
        })
        
    }
    
    /// Get users that username followes
    public func following(for username: String, completion: @escaping ([String]) -> Void){
        let ref = database.collection("users").document(username).collection("following")
        ref.getDocuments(completion: { snapshot, error in
            guard let usernames = snapshot?.documents.compactMap({ $0.documentID }), error == nil else{
                completion([])
                return
            }
            completion(usernames)
            
            
        })
        
    }
    
    /// Get users that username followes but not blocking
    public func followingNotBlocking(for username: String, completion: @escaping ([String]) -> Void){
        let ref = database.collection("users").document(username).collection("following")
        ref.getDocuments(completion: { snapshot, error in
            guard let usernames = snapshot?.documents.compactMap({ $0.documentID }), error == nil else{
                completion([])
                return
            }
            
            self.blocks(for: username, completion: { blocks in
                if (blocks.count == 0){
                    completion(usernames)
                    return
                }
                else{
//                    let filteredUsernames = usernames.filter{
//                        !blocks.contains($0)
//                    }
//                    completion(filteredUsernames)
//                    return
                    var res = [String]()
                    usernames.forEach{
                        if(!blocks.contains($0)){
                            res.append($0)
                        }
                        
                    }
                    completion(res)
                    return
                }
                
            })
            
            //completion(usernames)
            
            
        })
        
    }
    
    
    // MARK: - Comment
    public func getComments(postID: String,
                            owner: String,
                            completion: @escaping ([PostComment]) -> Void
    ){
        let ref = database.collection("users").document(owner).collection("posts").document(postID).collection("comments")
        ref.getDocuments(completion: {snapshot, error in
            guard let comments = snapshot?.documents.compactMap({
                PostComment(with: $0.data())
            }), error == nil else{
                completion([])
                return
            
            }
            
            completion(comments)
        })
    }
    
    public func getCommentsVideo(postID: String,
                            owner: String,
                            completion: @escaping ([PostComment]) -> Void
    ){
        let ref = database.collection("users").document(owner).collection("videos").document(postID).collection("comments")
        ref.getDocuments(completion: {snapshot, error in
            guard let comments = snapshot?.documents.compactMap({
                PostComment(with: $0.data())
            }), error == nil else{
                completion([])
                return
            
            }
            
            completion(comments)
        })
    }
    
    // MARK: - Comment
    public func getYorimichiComments(postID: String,
                            genre: GenreInfo,
                            completion: @escaping ([PostComment]) -> Void
    ){
        let ref = database.collection("yorimichiPost").document(genre.code).collection("posts").document(postID).collection("comments")
        ref.getDocuments(completion: {snapshot, error in
            guard let comments = snapshot?.documents.compactMap({
                PostComment(with: $0.data())
            }), error == nil else{
                completion([])
                return
                
            
            }
            
            completion(comments)
        })
    }
    
    
    public func createComments(postID: String,
                               owner: String,
                               comment: PostComment,
                               completion: @escaping (Bool) -> Void
    ){
        let newIdentifier = "\(postID)_\(comment.user.username)_\(Date().timeIntervalSince1970)_\(Int.random(in: 0...1000))"
        let ref = database.collection("users").document(owner).collection("posts").document(postID).collection("comments").document(newIdentifier)
        guard let data = comment.asDictionary() else {
            completion(false)
            return
        }
        ref.setData(data) {error in
            completion(error==nil)
        }
    }
    
    public func createCommentsVideo(postID: String,
                               owner: String,
                               comment: PostComment,
                               completion: @escaping (Bool) -> Void
    ){
        let newIdentifier = "\(postID)_\(comment.user.username)_\(Date().timeIntervalSince1970)_\(Int.random(in: 0...1000))"
        let ref = database.collection("users").document(owner).collection("videos").document(postID).collection("comments").document(newIdentifier)
        guard let data = comment.asDictionary() else {
            completion(false)
            return
        }
        ref.setData(data) {error in
            completion(error==nil)
        }
    }
    
    
    public func createYorimichiComments(postID: String,
                               genre: GenreInfo,
                               comment: PostComment,
                               completion: @escaping (Bool) -> Void
    ){
        let newIdentifier = "\(postID)_\(comment.user.username)_\(Date().timeIntervalSince1970)_\(Int.random(in: 0...1000))"
        let ref = database.collection("yorimichiPost").document(genre.code).collection("posts").document(postID).collection("comments").document(newIdentifier)
        guard let data = comment.asDictionary() else {
            completion(false)
            return
        }
        ref.setData(data) {error in
            completion(error==nil)
        }
    }
    
    
    // MARK: - Liking
    enum LikeState{
        case like, unlike
    }
    
    public func updateLike(state: LikeState, postID: String, owner: String, completion: @escaping (Bool) -> Void){
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return
        }
        let ref = database.collection("users").document(owner).collection("posts").document(postID)
        getPost(with: postID, from: owner){ post in
            guard var post = post else{
                completion(false)
                return
            }
            
            switch state{
            case .like:
                if !post.likers.contains(currentUsername){
                    post.likers.append(currentUsername)
                }
            case .unlike:
                post.likers.removeAll(where: { $0 == currentUsername })
            }
            guard let data = post.asDictionary() else {
                completion(false)
                return
            }
            
            print("========")
            print(data)
            ref.setData(data){ error in
                if error != nil{
                    print("failing")
                    completion(false)
                    return
                }
                else{
                    completion(true)
                }
            }
        }
    }
    
    public func updateLikeVideo(state: LikeState, postID: String, owner: String, completion: @escaping (Bool) -> Void){
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return
        }
        print("at least here=====")
        let ref = database.collection("users").document(owner).collection("videos").document(postID)
        getVideoPost(with: postID, from: owner){ post in
            guard var post = post else{
                completion(false)
                return
            }
            print("at least here222=====")
            
            switch state{
            case .like:
                print("like")
                if !post.likers.contains(currentUsername){
                    post.likers.append(currentUsername)
                }
            case .unlike:
                print("unlike")
                post.likers.removeAll(where: { $0 == currentUsername })
            }
            
            guard let data = post.asDictionary() else {
                completion(false)
                return
            }
            
            print(data)
            ref.setData(data){ error in
                if error != nil{
                    print("error1")
                    completion(false)
                    return
                }
                else{
                    completion(true)
                    return
                }
            }
        }
    }
    
    // MARK: - Yorimichi State
    enum YorimichiState{
        case yes, no
        
    }
    
    public func updateYorimichi(state: YorimichiState, postID: String, owner: String, completion: @escaping (Bool) -> Void){
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return
        }
        let ref = database.collection("users").document(owner).collection("posts").document(postID)
        getPost(with: postID, from: owner){ post in
            guard var post = post else{
                completion(false)
                return
            }
            
            switch state{
            case .yes:
                if !post.yorimichi.contains(currentUsername){
                    post.yorimichi.append(currentUsername)
                }
            case .no:
                post.yorimichi.removeAll(where: { $0 == currentUsername })
            }
            guard let data = post.asDictionary() else {
                completion(false)
                return
            }
            
            print("========")
            print(data)
            ref.setData(data){ error in
                if error != nil{
                    print("failing")
                    completion(false)
                    return
                }
                else{
                    completion(true)
                }
            }
        }
    }
    
    public func updateYorimichiVideo(state: YorimichiState, postID: String, owner: String, completion: @escaping (Bool) -> Void){
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return
        }
        print("at least here=====")
        let ref = database.collection("users").document(owner).collection("videos").document(postID)
        getVideoPost(with: postID, from: owner){ post in
            guard var post = post else{
                completion(false)
                return
            }
            print("at least here222=====")
            
            switch state{
            case .yes:
                print("yorimichi yes")
                if !post.yorimichi.contains(currentUsername){
                    post.yorimichi.append(currentUsername)
                }
            case .no:
                print("yorimichi no")
                post.yorimichi.removeAll(where: { $0 == currentUsername })
            }
            
            guard let data = post.asDictionary() else {
                completion(false)
                return
            }
            
            print(data)
            ref.setData(data){ error in
                if error != nil{
                    print("error1")
                    completion(false)
                    return
                }
                else{
                    completion(true)
                    return
                }
            }
        }
    }
    
//    public func updateYorimichiLike(state: LikeState, postID: String, genre: GenreInfo, completion: @escaping (Bool) -> Void){
//        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
//            completion(false)
//            return
//        }
//        let ref = database.collection("yorimichiPost").document(genre.code).collection("posts").document(postID)
//        getYorimichiPost(with: postID, from: genre){ post in
//            guard var post = post else{
//                completion(false)
//                return
//            }
//
//            switch state{
//            case .like:
//                if !post.likers.contains(currentUsername){
//                    post.likers.append(currentUsername)
//                }
//            case .unlike:
//                post.likers.removeAll(where: { $0 == currentUsername })
//            }
//            guard let data = post.asDictionary() else {
//                completion(false)
//                return
//            }
//            ref.setData(data){ error in
//                return
//            }
//        }
//    }
    
    // MARK: YorimichiLikes
    public func addYorimichiLikes(with post: Post, for username: String, completion: @escaping(Bool) -> Void){
//        guard let user = UserDefaults.standard.string(forKey: "username") else {
//            return
//        }
        
        let newIdentifier = "\(username)_\(Date().timeIntervalSince1970)_\(Int.random(in: 0...1000))"
        let ref = database.collection("users").document(username).collection("yorimichiLikes").document(newIdentifier)
        guard let data = post.asDictionary() else {
            completion(false)
            return
        }
        ref.setData(data) {error in
            completion(error==nil)
        }
    }
    

    
    public func removeYorimichiLikes(with post: Post, for username: String, completion: @escaping(Bool) -> Void){
//        guard let user = UserDefaults.standard.string(forKey: "username") else {
//            return
//        }
        
        let ref = database.collection("users").document(username).collection("yorimichiLikes")
        let matchRef = ref.whereField("id", isEqualTo: post.id)
        
        matchRef.getDocuments(completion: { snapshot, error in
            guard let targetId = snapshot?.documents.compactMap({ $0.documentID}), error == nil else{
                completion(false)
                return
            }
            
            guard let tmpId = targetId.first else {
                completion(false)
                return
            }
            let targetRef = ref.document(tmpId)
            targetRef.delete(){
                error in
                    if let error = error{
                        completion(false)
                        return
                    }
                    else{
                        completion(true)
                        return
                    }
            }
      
        })
        
    }
    
    
    
    
    public func checkIfLikesRegistered(with post: Post, completion: @escaping(Bool) -> Void){
        guard let user = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        let ref = database.collection("users").document(user).collection("yorimichiLikes")
        let matchRef = ref.whereField("id", isEqualTo: post.id)
        matchRef.getDocuments(completion: { snapshot, error in
            guard let documents = snapshot?.documents,
                  error == nil else{
                      print("fall1")
                      return
                  }
            print(documents)
            if(documents.count == 0){
                completion(false)
            }
            else{
                completion(true)
            }
        })
    }
    
    
    public func yorimichiLikes(for username: String, completion: @escaping ([Post]) -> Void){
        let ref = database.collection("users")
            .document(username)
            .collection("yorimichiLikes")
        ref.getDocuments{ snapshot, error in
            guard let posts = snapshot?.documents.compactMap({
                Post(with: $0.data())
            }).sorted(by: { first, second in
                return first.date > second.date
                
            }),
                  error == nil else{
                      completion([])
                      return
            }
            
            print("got posts")
            print(posts)
            completion(posts)
        }
    }

    
    
    // MARK: YorimichiCandidates
    
    public func addYorimichiCandidate(with post: Post, for username: String, completion: @escaping(Bool) -> Void){
//        guard let user = UserDefaults.standard.string(forKey: "username") else {
//            return
//        }
        
        let newIdentifier = "\(username)_\(Date().timeIntervalSince1970)_\(Int.random(in: 0...1000))"
        let ref = database.collection("users").document(username).collection("yorimichiCandidates").document(newIdentifier)
        guard let data = post.asDictionary() else {
            completion(false)
            return
        }
        ref.setData(data) {error in
            completion(error==nil)
        }
    }
    

    
    public func removeYorimichiCandidate(with post: Post, for username: String, completion: @escaping(Bool) -> Void){
//        guard let user = UserDefaults.standard.string(forKey: "username") else {
//            return
//        }
        
        let ref = database.collection("users").document(username).collection("yorimichiCandidates")
        let matchRef = ref.whereField("id", isEqualTo: post.id)
        
        matchRef.getDocuments(completion: { snapshot, error in
            guard let targetId = snapshot?.documents.compactMap({ $0.documentID}), error == nil else{
                completion(false)
                return
            }
            
            guard let tmpId = targetId.first else {
                completion(false)
                return
            }
            let targetRef = ref.document(tmpId)
            targetRef.delete(){
                error in
                    if let error = error{
                        completion(false)
                        return
                    }
                    else{
                        completion(true)
                        return
                    }
            }
      
        })
        
    }
    
    
    
    
    public func checkIfCandidateRegistered(with post: Post, completion: @escaping(Bool) -> Void){
        guard let user = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        let ref = database.collection("users").document(user).collection("yorimichiCandidates")
        let matchRef = ref.whereField("id", isEqualTo: post.id)
        matchRef.getDocuments(completion: { snapshot, error in
            guard let documents = snapshot?.documents,
                  error == nil else{
                      print("fall1")
                      return
                  }
            print(documents)
            if(documents.count == 0){
                completion(false)
            }
            else{
                completion(true)
            }
        })
    }
    
    
    public func candidates(for username: String, completion: @escaping ([Post]) -> Void){
        let ref = database.collection("users")
            .document(username)
            .collection("yorimichiCandidates")
        ref.getDocuments{ snapshot, error in
            guard let posts = snapshot?.documents.compactMap({
                Post(with: $0.data())
            }).sorted(by: { first, second in
                return first.date > second.date
                
            }),
                  error == nil else{
                      completion([])
                      return
            }
            
            print("got posts")
            print(posts)
            completion(posts)
        }
    }
    
    
    
    
}
