//
//  AssertTests.swift
//  ErrorAssertionsTests
//
//  Created by Jeff Kelley on 7/1/19.
//

import XCTest

@testable import ErrorAssertions

final class AssertTests: XCTestCase {
    
    func testAssertionFailuresSendExpectedErrors() {
        expectAssertionFailure(expectedError: TestError.testErrorA) { 
            assert(false, error: TestError.testErrorA)
        }
        
        expectAssertionFailure(expectedError: TestError.testErrorB) { 
            assert(false, error: TestError.testErrorB)
        }
    }
    
    func testDefaultErrorIsABlankAnonymousError() {
        expectAssertionFailure(expectedError: AnonymousError.blank) { 
            ErrorAssertions.assert(false)
        }
    }
    
    func testDefaultErrorWithStringIsAnAnonymousError() {
        let expectedError = AnonymousError.withMessage("test")
        
        expectAssertionFailure(expectedError: expectedError) { 
            ErrorAssertions.assert(false, "test")
        }
    }
    
    func testAssertionFailureWithoutCapturingError() {
        expectAssertionFailure {
            ErrorAssertions.assert(false)
        }
    }
    
    func testAssertionFailureWithMessageWithoutCapturingError() {
        expectAssertionFailure(expectedMessage: "test") {
            ErrorAssertions.assert(false, "test")
        }
    }
    
    static var allTests = [
        ("testAssertionFailuresSendExpectedErrors",
         testAssertionFailuresSendExpectedErrors),
        
        ("testDefaultErrorIsABlankAnonymousError",
         testDefaultErrorIsABlankAnonymousError),
        
        ("testDefaultErrorWithStringIsAnAnonymousError",
         testDefaultErrorWithStringIsAnAnonymousError),
        
        ("testAssertionFailureWithoutCapturingError",
         testAssertionFailureWithoutCapturingError),
        
        ("testAssertionFailureWithMessageWithoutCapturingError",
         testAssertionFailureWithMessageWithoutCapturingError),
    ]
    
}
