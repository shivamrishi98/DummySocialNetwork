//
//  DummySocialNetworkTests.swift
//  DummySocialNetworkTests
//
//  Created by Shivam Rishi on 07/04/21.
//

import XCTest
@testable import DummySocialNetwork

class LoginApiUnitTests: XCTestCase {

    let sut = AuthManager.shared
    
    func test_LoginApi_With_ValidRequest_Returns_LoginResponse() {
        
        let request = LoginRequest(email: "shivam@gmail.com",
                                   password: "partytime")
        let expectation = self.expectation(
            description:"ValidRequest_Returns_LoginResponse")
        
        
        sut.signIn(request: request) { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
                XCTAssertEqual(response.message, "Log In Successfully")
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func test_LoginApi_With_NoRegisteredEmail_Returns_Error() {
        
        let request = LoginRequest(email: "shi@gmail.com",
                                   password: "partytime")
        let expectation = self.expectation(
            description:"NoRegisteredEmail_Returns_Error")
        
        
        sut.signIn(request: request) { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                XCTAssertNil(response)
            case .failure(let error):
                let e = error as! GenericError
                XCTAssertNotNil(e)
                XCTAssertEqual(e.message, "User does not exist")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func test_LoginApi_With_InvalidPassword_Returns_Error() {
        
        let request = LoginRequest(email: "shivam@gmail.com",
                                   password: "partyttt")
        let expectation = self.expectation(
            description:"InvalidPassword_Returns_Error")
        
        
        sut.signIn(request: request) { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                XCTAssertNil(response)
            case .failure(let error):
                let e = error as! GenericError
                XCTAssertNotNil(e)
                XCTAssertEqual(e.message, "Invalid Password")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func test_LoginApi_With_InvalidEmail_Returns_Error() {
        
        let request = LoginRequest(email: "shi@gmail",
                                   password: "partytime")
        let expectation = self.expectation(
            description:"InvalidEmail_Returns_Error")
        
        
        sut.signIn(request: request) { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                XCTAssertNil(response)
            case .failure(let error):
                let e = error as! GenericError
                XCTAssertNotNil(e)
                XCTAssertEqual(e.message, "\"email\" must be a valid email")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func test_LoginApi_With_PasswordLessThanSixChars_Returns_Error() {
        
        let request = LoginRequest(email: "shivam@gmail.com",
                                   password: "part")
        let expectation = self.expectation(
            description:"PasswordLessThanSixChars_Returns_Error")
        
        
        sut.signIn(request: request) { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                XCTAssertNil(response)
            case .failure(let error):
                let e = error as! GenericError
                XCTAssertNotNil(e)
                XCTAssertEqual(e.message, "\"password\" length must be at least 6 characters long")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func test_LoginApi_With_EmptyString_Returns_Error() {
        
        let request = LoginRequest(email: "",
                                   password: "")
        let expectation = self.expectation(
            description:"EmptyString_Returns_Error")
        
        
        sut.signIn(request: request) { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                XCTAssertNil(response)
            case .failure(let error):
                let e = error as! GenericError
                XCTAssertNotNil(e)
                XCTAssertEqual(e.message, "\"email\" is not allowed to be empty")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func test_LoginApi_With_EmptyEmail_Returns_Error() {
        
        let request = LoginRequest(email: "",
                                   password: "partytime")
        let expectation = self.expectation(
            description:"EmptyEmail_Returns_Error")
        
        
        sut.signIn(request: request) { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                XCTAssertNil(response)
            case .failure(let error):
                let e = error as! GenericError
                XCTAssertNotNil(e)
                XCTAssertEqual(e.message, "\"email\" is not allowed to be empty")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func test_LoginApi_With_EmptyPassword_Returns_Error() {
        
        let request = LoginRequest(email: "shivam@gmail.com",
                                   password: "")
        let expectation = self.expectation(
            description:"EmptyPassword_Returns_Error")
        
        
        sut.signIn(request: request) { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                XCTAssertNil(response)
            case .failure(let error):
                let e = error as! GenericError
                XCTAssertNotNil(e)
                XCTAssertEqual(e.message, "\"password\" is not allowed to be empty")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }

}
