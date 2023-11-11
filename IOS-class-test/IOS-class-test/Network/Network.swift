import Foundation

func loadReposData() async -> [Repository]{
    do {
        return try await getRepos()
        
       } catch GitHubError.invalidData {
           print("Invalid Data!")
       } catch GitHubError.invalidResponse {
           print("Invalid Response!")
       } catch GitHubError.invalidURL {
           print("Invalid URL!")
       } catch {
           print("Unexpected Error!")
       }
}

func getRepos(userName: String) async throws -> [Repository] {
    let endPoint = "https://api.github.com/users/\(userName)/repos"
    //"https://api.github.com/users/VHPFchefe/repos"
    
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
        // Mark
        
        // I dont know hot to use this guys, but, i will need that
        
        //decoder.dataDecodingStrategy =
        //decoder.dateDecodingStrategy =
        
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
