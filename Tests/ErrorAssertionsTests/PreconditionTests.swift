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

        expectPreconditionFailure(expectedError: TestError.testErrorA) { 
            preconditionFailure(error: TestError.testErrorA)
        }
        
        expectPreconditionFailure(expectedError: TestError.testErrorB) { 
            preconditionFailure(error: TestError.testErrorB)
        }
    }
    
    func testDefaultErrorIsABlankAnonymousError() {
        expectPreconditionFailure(expectedError: AnonymousError.blank) { 
            precondition(false)
        }

        expectPreconditionFailure(expectedError: AnonymousError.blank) { 
            preconditionFailure()
        }
    }
    
    func testDefaultErrorWithStringIsAnAnonymousError() {
        let expectedError = AnonymousError.withMessage("test")
        
        expectPreconditionFailure(expectedError: expectedError) { 
            precondition(false, "test")
        }

        expectPreconditionFailure(expectedError: expectedError) { 
            preconditionFailure("test")
        }
    }
    
    func testPreconditionFailureWithoutCapturingError() {
        expectPreconditionFailure {
            precondition(false)
        }

        expectPreconditionFailure {
            preconditionFailure()
        }
    }
    
    func testPreconditionFailureWithMessageWithoutCapturingError() {
        expectPreconditionFailure(expectedMessage: "test") {
            precondition(false, "test")
        }

        expectPreconditionFailure(expectedMessage: "test") {
            preconditionFailure("test")
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
