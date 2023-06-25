import Foundation
import UIKit

class NetworkService {
    static let shared = NetworkService()
    
    private init() { }
    
    private let baseURL = "https://jsonplaceholder.typicode.com"
    
    private func createRequest(url: String, method: String, body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: URL(string: baseURL + url)!)
        request.httpMethod = method
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    public func getPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        let request = createRequest(url: "/posts", method: "GET")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                completion(.success(posts))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    public func createPost(post: Post, completion: @escaping (Result<Post, Error>) -> Void) {
        let request = createRequest(url: "/posts", method: "POST", body: try? JSONEncoder().encode(post))
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            do {
                let post = try JSONDecoder().decode(Post.self, from: data)
                completion(.success(post))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    public func updatePost(post: Post, completion: @escaping (Result<Post, Error>) -> Void) {
        let request = createRequest(url: "/posts/\(post.id)", method: "PUT", body: try? JSONEncoder().encode(post))
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            do {
                let post = try JSONDecoder().decode(Post.self, from: data)
                completion(.success(post))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    public func deletePost(postId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let request = createRequest(url: "/posts/\(postId)", method: "DELETE")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(()))
        }.resume()
    }
    
    func downloadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(NSError(domain: "com.example.app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert data to image"])))
                return
            }
            completion(.success(image))
        }.resume()
    }
}
