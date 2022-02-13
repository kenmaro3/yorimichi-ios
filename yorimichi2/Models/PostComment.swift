import Foundation

enum ShowingCommentSegment: Codable{
    case menu
    case price
    case time
}


struct PostComment: Codable{
    let text: String
    let user: User
    let date: Date
    let type: ShowingCommentSegment?
    
}
