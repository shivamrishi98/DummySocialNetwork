//
//  Auth.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 27/03/21.
//

import Foundation

struct LoginRequest {
    let email:String
    let password:String
}

struct RegisterRequest {
    let name:String
    let email:String
    let password:String
}

struct LoginResponse:Codable {
    let message:String
    let access_token:String
    let userId:String
}

struct SignUpResponse:Codable {
    let message:String
    let access_token:String
    let user:User
}

struct ChangePasswordRequest:Codable {
    let oldpassword:String
    let newpassword:String
}

struct ChangePasswordResponse:Codable {
    let message:String
}
