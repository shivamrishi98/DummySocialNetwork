//
//  Generic.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 07/04/21.
//

import Foundation

struct BaseResponse<T:Codable>: Codable{
    let error: GenericError?
    let data: T?
}

struct GenericError:Codable,Error {
    let message:String
}
