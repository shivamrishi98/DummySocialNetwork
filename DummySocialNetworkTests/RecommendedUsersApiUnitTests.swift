//
//  RecommendedUsersApiUnitTests.swift
//  DummySocialNetworkTests
//
//  Created by Shivam Rishi on 08/04/21.
//

import XCTest
@testable import DummySocialNetwork

class RecommendedUsersApiUnitTests: XCTestCase {

    let sut = ApiManager.shared
    
    func test_RecommendedUsersApi_With_Users_Returns_Response() {
        
        let expectation = self.expectation(
            description: "Users_Returns_Response")
        
        
        sut.getRecommendedUsers { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let users):
                XCTAssertNotNil(users)
                XCTAssertNotEqual(users.count, 0)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        
        
        
        waitForExpectations(timeout: 5,
                            handler: nil)
    }
    
    func test_RecommendedUsersApi_With_NoUsers_Returns_Response() {
        
        let expectation = self.expectation(
            description: "NoUsers_Returns_Response")
        
        
        sut.getRecommendedUsers { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let users):
                XCTAssertNotNil(users)
                XCTAssertEqual(users.count, 0)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        
        
        
        waitForExpectations(timeout: 5,
                            handler: nil)
    }

}
