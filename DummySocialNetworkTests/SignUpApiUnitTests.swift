//
//  SignUpApiUnitTests.swift
//  DummySocialNetworkTests
//
//  Created by Shivam Rishi on 07/04/21.
//

import XCTest
@testable import DummySocialNetwork

class SignUpApiUnitTests: XCTestCase {
    
    let sut = AuthManager.shared
    
    func test_SignUpApi_With_ValidRequest_Returns_SignUpResponse() {

        let request = RegisterRequest(name: "Unit testing",
                                      email: "Unitabc@gmail.com",
                                      password: "partytime")

        let expectation = self.expectation(
            description:"ValidRequest_Returns_SignUpResponse")


        sut.createAccount(request: request) { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
                XCTAssertEqual(response.message, "User Created")
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

    }
    
    func test_SignUpApi_With_NameLessThanSixChars_Returns_Error() {
        
        let request = RegisterRequest(name: "Unit",
                                      email: "abcd@gmail.com",
                                      password: "partytime")
        
        let expectation = self.expectation(
            description:"NameLessThanSixChars_Returns_Error")
        
        
        sut.createAccount(request: request) { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                XCTAssertNil(response)
            case .failure(let error):
                let e = error as! GenericError
                XCTAssertNotNil(e)
                XCTAssertEqual(e.message, "\"name\" length must be at least 6 characters long")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func test_SignUpApi_With_PasswordLessThanSixChars_Returns_Error() {
        
        let request = RegisterRequest(name: "Unit tesing",
                                      email: "abcd@gmail.com",
                                      password: "party")
        
        let expectation = self.expectation(
            description:"PasswordLessThanSixChars_Returns_Error")
        
        
        sut.createAccount(request: request) { result in
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
    
    func test_SignUpApi_With_EmailExists_Returns_Error() {
        
        let request = RegisterRequest(name: "Unit Testing",
                                      email: "unit@gmail.com",
                                      password: "partytime")
        
        let expectation = self.expectation(
            description:"EmailExists_Returns_Error")
        
        
        sut.createAccount(request: request) { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                XCTAssertNil(response)
            case .failure(let error):
                let e = error as! GenericError
                XCTAssertNotNil(e)
                XCTAssertEqual(e.message, "Email already exists")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func test_SignUpApi_With_InvalidEmail_Returns_Error() {
        
        let request = RegisterRequest(name: "Unit Testing",
                                      email: "unitgmail.com",
                                      password: "partytime")
        
        let expectation = self.expectation(
            description:"InvalidEmail_Returns_Error")
        
        
        sut.createAccount(request: request) { result in
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
    
    func test_SignUpApi_With_EmptyName_Returns_Error() {
        
        let request = RegisterRequest(name: "",
                                      email: "unitgmail.com",
                                      password: "partytime")
        
        let expectation = self.expectation(
            description:"EmptyName_Returns_Error")
        
        
        sut.createAccount(request: request) { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                XCTAssertNil(response)
            case .failure(let error):
                let e = error as! GenericError
                XCTAssertNotNil(e)
                XCTAssertEqual(e.message, "\"name\" is not allowed to be empty")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func test_SignUpApi_With_EmptyPassword_Returns_Error() {
        
        let request = RegisterRequest(name: "Unit testing",
                                      email: "unit@gmail.com",
                                      password: "")
        
        let expectation = self.expectation(
            description:"EmptyPassword_Returns_Error")
        
        
        sut.createAccount(request: request) { result in
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
    
    func test_SignUpApi_With_EmptyEmail_Returns_Error() {
        
        let request = RegisterRequest(name: "Unit testing",
                                      email: "",
                                      password: "partytime")
        
        let expectation = self.expectation(
            description:"EmptyEmail_Returns_Error")
        
        
        sut.createAccount(request: request) { result in
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
    
    func test_SignUpApi_With_EmptyStrings_Returns_Error() {
        
        let request = RegisterRequest(name: "",
                                      email: "",
                                      password: "")
        
        let expectation = self.expectation(
            description:"EmptyStrings_Returns_Error")
        
        
        sut.createAccount(request: request) { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                XCTAssertNil(response)
            case .failure(let error):
                let e = error as! GenericError
                XCTAssertNotNil(e)
                XCTAssertEqual(e.message, "\"name\" is not allowed to be empty")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    

}
