//
//  PreconditionTests.swift
//  ErrorAssertionsTests
//
//  Created by Jeff Kelley on 7/1/19.
//

import XCTest

@testable import ErrorAssertions

final class PreconditionTests: XCTestCase {
    
    func testPreconditionFailuresSendExpectedErrors() {
        expectPreconditionFailure(expectedError: TestError.testErrorA) { 
            precondition(false, error: TestError.testErrorA)
        }
        
        expectPreconditionFailure(expectedError: TestError.testErrorB) { 
            precondition(false, error: TestError.testErrorB)
        }
    }
    
    func testDefaultErrorIsABlankAnonymousError() {
        expectPreconditionFailure(expectedError: AnonymousError.blank) { 
            ErrorAssertions.precondition(false)
        }
    }
    
    func testDefaultErrorWithStringIsAnAnonymousError() {
        let expectedError = AnonymousError.withMessage("test")
        
        expectPreconditionFailure(expectedError: expectedError) { 
            ErrorAssertions.precondition(false, "test")
        }
    }
    
    func testPreconditionFailureWithoutCapturingError() {
        expectPreconditionFailure {
            ErrorAssertions.precondition(false)
        }
    }
    
    func testPreconditionFailureWithMessageWithoutCapturingError() {
        expectPreconditionFailure(expectedMessage: "test") {
            ErrorAssertions.precondition(false, "test")
        }
    }
    
    static var allTests = [
        ("testPreconditionFailuresSendExpectedErrors",
         testPreconditionFailuresSendExpectedErrors),
        
        ("testDefaultErrorIsABlankAnonymousError",
         testDefaultErrorIsABlankAnonymousError),
        
        ("testDefaultErrorWithStringIsAnAnonymousError",
         testDefaultErrorWithStringIsAnAnonymousError),
        
        ("testPreconditionFailureWithoutCapturingError",
         testPreconditionFailureWithoutCapturingError),
        
        ("testPreconditionFailureWithMessageWithoutCapturingError",
         testPreconditionFailureWithMessageWithoutCapturingError),
    ]
    
}
