//
//  PostViewModel.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 28/03/21.
//

import Foundation

struct PostViewModel {
    let caption:String
    let name:String
    let likes:[String]
    let contentUrl:URL?
    let profilePictureUrl:URL?
    let createdDate:String
}
