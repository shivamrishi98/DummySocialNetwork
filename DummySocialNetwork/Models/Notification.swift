//
//  Notification.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 09/04/21.
//

import Foundation


enum NotificationType:String,Codable {
    case like = "like"
    case comment = "comment"
}

struct CreateNotificationRequest:Codable {
    let postId:String
    let type:NotificationType
}

struct CreateNotificationResponse:Codable {
    let message:String
    let notification:UserNotification
}

struct NotificationsResponse:Codable {
    let notifications:[UserNotification]
}

struct UserNotification:Codable {
    let postId:String
    let senderId:String
    let receiverId:String
    let message:String
    let contentUrl:String?
    let createdDate:String
}

struct DeleteNotificationRequest:Codable {
    let postId:String
}

struct DeleteNotificationResponse:Codable {
    let message:String
}
