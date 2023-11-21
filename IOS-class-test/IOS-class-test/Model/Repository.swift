import Foundation

struct Repository : Codable {
    let name : String
    let description : String?
    let language : String?
    let updatedAt : String?
    let stargazersCount : Int
    let watchersCount : Int?
    let forksCount : Int?
    let owner : Owner
}

struct Owner : Codable {
    let login : String?
    let avatarUrl : String?
}
