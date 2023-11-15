import Foundation

struct User : Codable {
    let login: String
    let id: Int
    let nodeId: String
    let avatarUrl: String
    let url: String
    let htmlUrl: String
    let reposUrl: String
    let name: String
    let company: String?
    let blog: String? // Problem here ?
    let location: String?
    let email: String?
    let bio: String?
    let publicRepos: Int
    let publicGists: Int
    let followers: Int
    let following: Int
}
