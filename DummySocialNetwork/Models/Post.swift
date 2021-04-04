//
//  Post.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 28/03/21.
//

import Foundation

struct MyPostsResponse:Codable {
    let posts:[Post]
}

struct Post:Codable {
    let _id:String
    let caption:String
    let userId:String
    let name:String
    let likes:[String]
    let contentUrl:String
    let profilePictureUrl:String?
    let createdDate:String
}

struct ImageRequestModel:Codable {
    let fileName:String
    let mimeType:String
    let imageData:Data
}

struct CreatePostRequest:Codable {
    let caption:String
    let fileName:String
    let mimeType:String
    let imageData:Data
}

struct LikeUnlikeResponse:Codable {
    let message:String
}

struct LikedUsersResponse:Codable {
    let users:[User]
}

struct CreatePostResponse:Codable {
    let message:String
    let post:Post
}
