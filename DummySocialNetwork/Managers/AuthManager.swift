//
//  AuthManager.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 27/03/21.
//

import UIKit

final class AuthManager {
    
    static let shared = AuthManager()
    
    private init() { }
    
    
    var accessToken:String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    enum AuthError:Error {
        case failedToAuth
    }
    
    func cacheToken(token:String) {
        UserDefaults.standard.setValue(token, forKey: "access_token")
    }
    
    // Sign Up
    public func createAccount(request model:RegisterRequest,
                              completion: @escaping (Result<SignUpResponse,Error>) -> Void) {
        
        guard let apiUrl = URL(string: Constants.baseUrl + "/auth/signup") else {
            return
        }
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.timeoutInterval = 30
        let json:[String:String] = [
            "name":model.name,
            "email":model.email,
            "password":model.password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: json,
                                                       options: .fragmentsAllowed)
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(AuthError.failedToAuth))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(SignUpResponse.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
        
    }
    
    // Log In
    public func signIn(request model:LoginRequest,
                       completion: @escaping (Result<LoginResponse,Error>) -> Void) {
        guard let apiUrl = URL(string: Constants.baseUrl + "/auth/login") else {
            return
        }
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.timeoutInterval = 30
        let json:[String:String] = [
            "email":model.email,
            "password":model.password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: json,
                                                       options: .fragmentsAllowed)
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(AuthError.failedToAuth))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(LoginResponse.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    // Log Out
    public func signOut(completion:@escaping (Bool) -> Void) {
        UserDefaults.standard.setValue(nil, forKey: "access_token")
        completion(true)
    }
    
    
}


