//
//  ChangePasswordApiUnitTests.swift
//  DummySocialNetworkTests
//
//  Created by Shivam Rishi on 07/04/21.
//

import XCTest
@testable import DummySocialNetwork

class ChangePasswordApiUnitTests: XCTestCase {

    let sut = AuthManager.shared
    
    func test_ChangePasswordApi_With_ValidRequest_Returns_True() {

        let request = ChangePasswordRequest(oldpassword: "trainingtime",
                                            newpassword: "partytime")

        let expectation = self.expectation(
            description:"ValidRequest_Returns_ChangePasswordResponse")


        sut.changePassword(request: request) { success in
             XCTAssertNotNil(success)
             XCTAssertTrue(success)
             expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

    }
    
    func test_ChangePasswordApi_With_WrongOldPassword_Returns_False() {

        let request = ChangePasswordRequest(oldpassword: "abcdefgh",
                                            newpassword: "trainingtime")

        let expectation = self.expectation(
            description:"WrongOldPassword_Returns_False")


        sut.changePassword(request: request) { result in
             XCTAssertNotNil(result)
             XCTAssertFalse(result)
             expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

    }
    
    func test_ChangePasswordApi_With_BothSamePassword_Returns_False() {

        let request = ChangePasswordRequest(oldpassword: "abcdefgh",
                                            newpassword: "abcdefgh")

        let expectation = self.expectation(
            description:"BothSamePassword_Returns_False")


        sut.changePassword(request: request) { result in
             XCTAssertNotNil(result)
             XCTAssertFalse(result)
             expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

    }
    
    func test_ChangePasswordApi_With_OldPasswordLessThanSixChars_Returns_False() {

        let request = ChangePasswordRequest(oldpassword: "abcd",
                                            newpassword: "abcdefgh")

        let expectation = self.expectation(
            description:"OldPasswordLessThanSixChars_Returns_False")


        sut.changePassword(request: request) { result in
             XCTAssertNotNil(result)
             XCTAssertFalse(result)
             expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

    }
    
    func test_ChangePasswordApi_With_NewPasswordLessThanSixChars_Returns_False() {

        let request = ChangePasswordRequest(oldpassword: "abcdefgh",
                                            newpassword: "abcde")

        let expectation = self.expectation(
            description:"NewPasswordLessThanSixChars_Returns_False")


        sut.changePassword(request: request) { result in
             XCTAssertNotNil(result)
             XCTAssertFalse(result)
             expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

    }
    
    func test_ChangePasswordApi_With_EmptyOldPassword_Returns_False() {

        let request = ChangePasswordRequest(oldpassword: "",
                                            newpassword: "abcdefgh")

        let expectation = self.expectation(
            description:"EmptyOldPassword_Returns_False")


        sut.changePassword(request: request) { result in
             XCTAssertNotNil(result)
             XCTAssertFalse(result)
             expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

    }
    
    func test_ChangePasswordApi_With_EmptyNewPassword_Returns_False() {

        let request = ChangePasswordRequest(oldpassword: "jhsjwdjbw",
                                            newpassword: "")

        let expectation = self.expectation(
            description:"EmptyNewPassword_Returns_False")


        sut.changePassword(request: request) { result in
             XCTAssertNotNil(result)
             XCTAssertFalse(result)
             expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

    }
    
    func test_ChangePasswordApi_With_EmptyStrings_Returns_False() {

        let request = ChangePasswordRequest(oldpassword: "",
                                            newpassword: "")

        let expectation = self.expectation(
            description:"EmptyStrings_Returns_False")


        sut.changePassword(request: request) { result in
             XCTAssertNotNil(result)
             XCTAssertFalse(result)
             expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

    }

}
