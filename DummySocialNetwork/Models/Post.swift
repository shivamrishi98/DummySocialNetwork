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
    let content:String
    let userId:String
    let name:String
    let profilePictureUrl:String?
    let createdDate:String
}

struct CreatePostRequest:Codable {
    let content:String
}

