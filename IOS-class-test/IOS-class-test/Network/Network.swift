import Foundation
import UIKit

func getUserImage(url : String) async throws -> UIImage {
    guard let urlImage = URL(string: url) else { throw GitHubError.invalidURL }
    let data = try Data(contentsOf: urlImage)
    guard let image = UIImage(data: data) else { throw GitHubError.invalidData}
    return image
}

func getUser(login: String) async throws -> User {
    let endPoint = "https://api.github.com/users/\(login)"
    guard let url = URL(string: endPoint) else {
        throw GitHubError.invalidURL
    }
    
    let (data,response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw GitHubError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(User.self, from: data)
    } catch {
        throw GitHubError.invalidData
    }
}

func getRepos(endPointRepos : String) async throws -> [Repository] {
    guard let url = URL(string: endPointRepos) else {
        throw GitHubError.invalidURL
    }
    
    let (data,response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw GitHubError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([Repository].self, from: data)
    } catch {
        throw GitHubError.invalidData
    }
}

enum GitHubError : Error {
case invalidURL
case invalidResponse
case invalidData
}
