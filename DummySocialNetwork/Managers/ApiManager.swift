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
    
    private func createMultipartFormRequestForPost(
        with url:URL?,
        type:HTTPMethod = .POST,
        requestModel:CreatePostRequest,
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
      
        
        requestData.appendString(string: "--\(boundary + lineBreak)")
        requestData.append("Content-Disposition: form-data; name=caption\(lineBreak + lineBreak)" .data(using: .utf8)!)
        requestData.appendString(string:"\(requestModel.caption + lineBreak)")
        
        
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
            let json:[String:Any] = [
                "name":requestData.name,
                "email":requestData.email,
                "isPrivate":requestData.isPrivate
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
    
    // MARK: - Follow/Unfollow
    
    // Follow user with other user id
    public func followUser(with userId:String,completion: @escaping (Bool)-> Void) {
        createRequest(with: URL(string: Constants.baseUrl + "/users/follow?userId=\(userId)"),
                      type: .POST) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
               
                do {
                    let result = try JSONDecoder().decode(FollowUnfollowResponse.self,
                                                          from: data)
                    if result.message.contains("Success") {
                        completion(true)
                        return
                    }
                    completion(false)
                    
                } catch {
                    completion(false)
                }
                
            }
            task.resume()
        }
    }
    
    // Unfollow user with other user id
    public func unfollowUser(with userId:String,completion: @escaping (Bool)-> Void) {
        createRequest(with: URL(string: Constants.baseUrl + "/users/unfollow?userId=\(userId)"),
                      type: .POST) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
               
                do {
                    let result = try JSONDecoder().decode(FollowUnfollowResponse.self,
                                                          from: data)
                    if result.message.contains("Success") {
                        completion(true)
                        return
                    }
                    completion(false)
                    
                } catch {
                    completion(false)
                }
                
            }
            task.resume()
        }
    }
    
    // Get followers from userId
    public func getFollowers(with userId:String,
                             completion: @escaping ((Result<[User],Error>)->Void)) {
        createRequest(with: URL(string: Constants.baseUrl + "/users/getfollowers?userId=\(userId)"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _,error in
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
    
    // Get followings from userId
    public func getFollowings(with userId:String,
                             completion: @escaping ((Result<[User],Error>)->Void)) {
        createRequest(with: URL(string: Constants.baseUrl + "/users/getfollowing?userId=\(userId)"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _,error in
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
    public func createPost(request requestModel:CreatePostRequest,completion: @escaping (Bool)-> Void) {
        createMultipartFormRequestForPost(with: URL(string: Constants.baseUrl + "/posts/create"),
                                   requestModel: requestModel) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                do {
                    let _ = try JSONDecoder().decode(CreatePostResponse.self,
                                                        from: data)
                    completion(true)
                } catch {
                    print(error)
                    completion(false)
                }
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
    
    
    // MARK: - Like/Unlike
    
    // Like post with postId
    public func likePost(with postId:String,completion: @escaping (Bool)-> Void) {
        createRequest(with: URL(string: Constants.baseUrl + "/posts/like?postId=\(postId)"),
                      type: .POST) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
               
                do {
                    let result = try JSONDecoder().decode(LikeUnlikeResponse.self,
                                                          from: data)
                    if result.message.contains("Success") {
                        completion(true)
                        return
                    }
                    completion(false)
                    
                } catch {
                    completion(false)
                }
                
            }
            task.resume()
        }
    }
    
    // Unlike post with postId
    public func unlikePost(with postId:String,completion: @escaping (Bool)-> Void) {
        createRequest(with: URL(string: Constants.baseUrl + "/posts/unlike?postId=\(postId)"),
                      type: .POST) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
               
                do {
                    let result = try JSONDecoder().decode(LikeUnlikeResponse.self,
                                                          from: data)
                    if result.message.contains("Success") {
                        completion(true)
                        return
                    }
                    completion(false)
                    
                } catch {
                    completion(false)
                }
                
            }
            task.resume()
        }
    }
    
    // Get users who liked your post

    public func getLikedUsers(with postId:String,completion:@escaping ((Result<[User],Error>)->Void)) {
        createRequest(with: URL(string: Constants.baseUrl + "/posts/likedUsers?postId=\(postId)"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(ApiError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(LikedUsersResponse.self, from: data)
                    completion(.success(result.users))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Comments
    
    // Comment on post with postId
    public func commentOnPost(with postId:String,
                              request requestModel:CreateCommentRequest,
                              completion: @escaping (Bool)-> Void) {
        createRequest(with: URL(string: Constants.baseUrl + "/posts/comment?postId=\(postId)"),
                      type: .POST) { baseRequest in
            var request = baseRequest
            let json:[String:Any] = [
                "comment":requestModel.comment
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json,
                                                           options: .fragmentsAllowed)
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
               
                do {
                    let result = try JSONDecoder().decode(CommentResponse.self,
                                                          from: data)
                    if result.message.contains("Success") {
                        completion(true)
                        return
                    }
                    completion(false)
                    
                } catch {
                    completion(false)
                }
                
            }
            task.resume()
        }
    }
    
    
    // Delete comment with postId and commentId
    public func deleteComment(with postId:String,commentId:String,completion: @escaping (Bool)-> Void) {
        createRequest(
            with: URL(string: Constants.baseUrl + "/posts/deleteComment?postId=\(postId)&commentId=\(commentId)"),
            type: .POST) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
               
                do {
                    let result = try JSONDecoder().decode(CommentResponse.self,
                                                          from: data)
                    if result.message.contains("Success") {
                        completion(true)
                        return
                    }
                    completion(false)
                    
                } catch {
                    completion(false)
                }
                
            }
            task.resume()
        }
    }
    
    // Get comments of particular post
    public func getComments(with postId:String,completion:@escaping ((Result<[Comment],Error>)->Void)) {
        createRequest(with: URL(string: Constants.baseUrl + "/posts/comments?postId=\(postId)"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(ApiError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(CommentsResponse.self, from: data)
                    completion(.success(result.comments))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Home Feed
    
    public func getHomeFeed(completion:@escaping ((Result<[Post],Error>)->Void)) {
        createRequest(with: URL(string: Constants.baseUrl + "/home/"),
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
    
    // MARK: - Recommendations
    
    public func getRecommendedUsers(completion: @escaping (Result<[User],Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseUrl + "/recommendations/users"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(ApiError.failedToGetData))
                    return
                }
                
                do {
                    let results = try JSONDecoder().decode(SearchUsersResult.self,
                                                           from: data)
                    completion(.success(results.users))
                } catch {
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    // MARK: - Stories
    
    public func createStory(request requestModel:ProfilePictureRequest,completion: @escaping (Bool)->Void) {
        createMultipartFormRequest(with: URL(string: Constants.baseUrl + "/stories/create"),
                                   requestModel: requestModel) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                do {
                    let _ = try JSONDecoder().decode(CreateStoryResponse.self,
                                                        from: data)
                    completion(true)
                } catch {
                    completion(false)
                }
            }
            task.resume()
        }
    }
    
    public func getAllStories(completion: @escaping (Result<[Story],Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseUrl + "/stories/getstories"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(ApiError.failedToGetData))
                    return
                }
                
                do {
                    let results = try JSONDecoder().decode(StoriesResponse.self,
                                                           from: data)
                    completion(.success(results.stories))
                } catch {
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    
    
}

