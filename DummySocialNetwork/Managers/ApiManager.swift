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
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        request.httpMethod = type.rawValue
        request.timeoutInterval = 30
        completion(request)

    }
    
    private func createMultipartFormRequest(
        with url:URL?,
        type:HTTPMethod = .POST,
        requestModel:ProfilePictureRequest,
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
        
        let boundary = "---------------------------\(UUID().uuidString)---------------------------"
        
        //Main Boundary
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var requestData = Data()
        
        let lineBreak = "\r\n"
      
        //Attachment
        requestData.appendString(string: "--\(boundary + lineBreak)")
        requestData.appendString(string: "Content-Disposition: form-data; name=\"file\"; filename=\"\(requestModel.fileName)\"\(lineBreak);")
        requestData.appendString(string: "Content-Type: \(requestModel.mimeType)\(lineBreak + lineBreak)")
        requestData.append(requestModel.imageData)
        requestData.appendString(string: "\(lineBreak + lineBreak)")
        
        //End of Main Boundary
        requestData.append("--\(boundary)--\(lineBreak)" .data(using: .utf8)!)
        
        //Content-Length
        request.addValue("\(requestData.count)", forHTTPHeaderField: "Content-Length")
        
        request.httpBody = requestData
        
        completion(request)
        
    }
    
    
    
    // MARK: - User
    
    // Get Current User Profile
    public func getUserProfile(completion: @escaping (Result<User,Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseUrl + "/users/myprofile"),
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
    
    // Get User Profile from userId
    public func getUserProfile(with userId:String,completion: @escaping (Result<User,Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseUrl + "/users/profile?userId=\(userId)"),
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
    
    // Search users with name
    public func searchUsers(with query:String,
                            completion: @escaping ((Result<[User],Error>)->Void)){
        createRequest(with: URL(string: Constants.baseUrl + "/users/search?name=\(query)"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(ApiError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SearchUsersResult.self,
                                                          from: data)
                    completion(.success(result.users))
                } catch {
                    completion(.failure(error))
                }
                
                
            }
            task.resume()
        }
    }
    
    // Update User Profile
    public func updateUserProfile(request requestData:UpdateUserProfileRequest,completion: @escaping (Bool) -> Void) {
        createRequest(with: URL(string: Constants.baseUrl + "/users/profile"),
                      type: .PUT) { baseRequest in
            var request = baseRequest
            let json:[String:String] = [
                "name":requestData.name,
                "email":requestData.email
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json,
                                                           options: .fragmentsAllowed)
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let _ = data, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
                
            }
            
            task.resume()
            
        }
    }
    
    public func uploadProfilePicture(request requestModel:ProfilePictureRequest,completion: @escaping (Result<UploadProfilePictureResponse,Error>)->Void) {
        createMultipartFormRequest(with: URL(string: Constants.baseUrl + "/users/uploadProfileImage"),
                                   requestModel: requestModel) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(ApiError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(UploadProfilePictureResponse.self,
                                                        from: data)
                    completion(.success(result))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Posts
    
    // Get My Posts
    public func getMyPosts(completion:@escaping ((Result<[Post],Error>)->Void)) {
        createRequest(with: URL(string: Constants.baseUrl + "/posts/my"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(ApiError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(MyPostsResponse.self, from: data)
                    completion(.success(result.posts))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    // Create Post
    public func createPost(request requestData:CreatePostRequest,completion: @escaping (Bool)-> Void) {
        createRequest(with: URL(string: Constants.baseUrl + "/posts/create"),
                      type: .POST) { baseRequest in
            var request = baseRequest
            let json:[String:String] = [
                "content":requestData.content
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json,
                                                           options: .fragmentsAllowed)
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let _ = data, error == nil else {
                    completion(false)
                    return
                }
                
                completion(true)
                
            }
            
            task.resume()
        }
    }
    
    // Delete post by id
    public func deletePost(with id:String,completion:@escaping (Bool)->Void) {
        createRequest(with: URL(string: Constants.baseUrl + "/posts/delete?postId=\(id)"),
                      type: .DELETE) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let _ = data, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
            task.resume()
        }
    }
    
}

