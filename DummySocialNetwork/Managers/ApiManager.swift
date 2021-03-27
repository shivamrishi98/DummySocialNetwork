//
//  ApiManager.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 27/03/21.
//

import UIKit

final class ApiManager {
    
    static let shared = ApiManager()
    
    private init() { }
    
    enum ApiError:Error {
        case failedToGetData
    }
    
    enum HTTPMethod:String {
        case GET
        case POST
        case DELETE
        case PUT
    }
    
    private func createRequest(with url:URL?,
                               type:HTTPMethod,
                               completion: @escaping (URLRequest) -> Void) {

        guard let token = AuthManager.shared.accessToken else {
            return
        }
        guard let apiUrl = url else {
            return
        }
        var request = URLRequest(url: apiUrl)
        request.setValue("\(token)",
                         forHTTPHeaderField: "access_token")
        request.httpMethod = type.rawValue
        request.timeoutInterval = 30
        completion(request)

    }
    
    // Get Current User Profile
    public func getUserProfile(completion: @escaping (Result<User,Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseUrl + "/users/profile"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(ApiError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(UserResponse.self, from: data)
                    completion(.success(result.user))
                } catch {
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    
}
