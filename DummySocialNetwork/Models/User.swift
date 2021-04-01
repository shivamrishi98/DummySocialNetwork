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
    let posts:[String]
    let followers:[String]
    let following:[String]
    let profilePictureUrl:String?
    let createdDate:String
}

struct UpdateUserProfileRequest:Codable {
    let name:String
    let email:String
    let profilePictureUrl:String
    
}

struct SearchUsersResult:Codable {
    let users:[User]
}
struct ProfilePictureRequest {
    let fileName:String
    let mimeType:String
    let imageData:Data
}

struct UploadProfilePictureResponse:Codable {
    let message:String
    let imageUrl:String?
}

struct FollowUnfollowResponse:Codable {
    let message:String
}
