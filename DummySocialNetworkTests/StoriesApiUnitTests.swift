//
//  StoriesApiUnitTests.swift
//  DummySocialNetworkTests
//
//  Created by Shivam Rishi on 08/04/21.
//

import XCTest
@testable import DummySocialNetwork

class StoriesApiUnitTests: XCTestCase {

    let sut = ApiManager.shared
  
    let mockImage = UIImage(systemName: "photo")
    
    
    func test_CreateStory_In_StoriesApi_ValidRequest_Returns_Response() {
       
        let request = ProfilePictureRequest(fileName: "testing.jpg",
                                            mimeType: " jpg",
                                            imageData: mockImage!.pngData()!)
        
        let expectation = self.expectation(description: "ValidRequest_Returns_Response")
        
        sut.createStory(request: request) { result in
            XCTAssertNotNil(result)
            switch result {
            case true:
                XCTAssertTrue(result)
            case false:
                XCTAssertFalse(result)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
        
    

}
