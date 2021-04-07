//
//  HomeFeedApiUnitTests.swift
//  DummySocialNetworkTests
//
//  Created by Shivam Rishi on 07/04/21.
//

import XCTest
@testable import DummySocialNetwork

class HomeFeedApiUnitTests: XCTestCase {

    let sut = ApiManager.shared
    
    func test_HomeFeedApi_With_Posts_Returns_PostsResponse() {
        
        let expectation = self.expectation(
            description: "Posts_Returns_PostsResponse")
        
        sut.getHomeFeed { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let posts):
                XCTAssertNotEqual(posts.count, 0)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func test_HomeFeedApi_With_NoPosts_Returns_PostsResponse() {
        
        let expectation = self.expectation(
            description: "NoPosts_Returns_PostsResponse")
        
        sut.getHomeFeed { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let posts):
                XCTAssertEqual(posts.count, 0)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }

}
