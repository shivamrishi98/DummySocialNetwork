//
//  Notification.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 09/04/21.
//

import Foundation

struct CreateNotificationRequest:Codable {
    let postId:String
    let message:String
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
    let createdDate:String
}
