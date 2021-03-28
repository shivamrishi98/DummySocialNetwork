//
//  User.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 27/03/21.
//

import Foundation

struct UserResponse:Codable {
    let user:User
}

struct User:Codable {
    let _id:String
    let name:String
    let email:String
    let createdDate:String
}

struct UpdateUserProfileRequest:Codable {
    let name:String
    let email:String
}
