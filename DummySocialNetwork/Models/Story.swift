//
//  Story.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 06/04/21.
//

import Foundation

struct CreateStoryRequest:Codable {
    let fileName:String
    let mimeType:String
    let imageData:Data
}

struct CreateStoryResponse:Codable {
    let message:String
}

struct StoriesResponse:Codable {
    let stories:[Story]
}

struct Story:Codable {
    let _id:String
    let contentUrl:String
    let createdBy:CreatedBy
    let createdDate:String
    let expires_at:String
}

struct CreatedBy:Codable {
    let userId:String
    let name:String
    let profilePictureUrl:String?
}

