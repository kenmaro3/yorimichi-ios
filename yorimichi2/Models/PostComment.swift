import Foundation

struct PostComment: Codable{
    let text: String
    let user: User
    let date: Date
    
//    static func mockComment() -> [PostComment]{
//        //let user = User(username: "kenmaro", profilePictureURL: nil, identifier: UUID().uuidString)
//        let user = User(username: "kenmaro", email: "miha.ken.19@gmail.com")
//        let texts = [
//            "comment 1",
//            "comment 2",
//            "comment 3"
//        ]
//        
//        var comments = [PostComment]()
//        
//        for comment in texts{
//            comments.append(
//                PostComment(text: comment, user: user, date: Date())
//            )
//        }
//        
//        return comments
//    }
}
