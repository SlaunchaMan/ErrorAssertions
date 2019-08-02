//
//  AssertTests.swift
//  ErrorAssertionsTests
//
//  Created by Jeff Kelley on 7/1/19.
//

import XCTest

import ErrorAssertions
import ErrorAssertionExpectations

final class AssertTests: XCTestCase {
    
    func testAssertionFailuresSendExpectedErrors() {
        expectAssertionFailure(expectedError: TestError.testErrorA) { 
            assert(false, error: TestError.testErrorA)
        }
        
        expectAssertionFailure(expectedError: TestError.testErrorB) { 
            assert(false, error: TestError.testErrorB)
        }
        
        expectAssertionFailure(expectedError: TestError.testErrorA) {
            assertionFailure(error: TestError.testErrorA)
        }

        expectAssertionFailure(expectedError: TestError.testErrorB) { 
            assertionFailure(error: TestError.testErrorB)
        }
    }
    
    func testDefaultErrorIsABlankAnonymousError() {
        expectAssertionFailure(expectedError: AnonymousError.blank) { 
            assert(false)
        }

        expectAssertionFailure(expectedError: AnonymousError.blank) { 
            assertionFailure()
        }
    }
    
    func testDefaultErrorWithStringIsAnAnonymousError() {
        let expectedError = AnonymousError.withMessage("test")
        
        expectAssertionFailure(expectedError: expectedError) { 
            assert(false, "test")
        }

        expectAssertionFailure(expectedError: expectedError) { 
            assertionFailure("test")
        }
    }
    
    func testAssertionFailureWithoutCapturingError() {
        expectAssertionFailure {
            assert(false)
        }
        
        expectAssertionFailure {
            assertionFailure()
        }

    }
    
    func testAssertionFailureWithMessageWithoutCapturingError() {
        expectAssertionFailure(expectedMessage: "test") {
            assert(false, "test")
        }

        expectAssertionFailure(expectedMessage: "test") {
            assertionFailure("test")
        }
    }
    
    func testExpectingNoAssertionFailure() {
        expectNoAssertionFailure {
            
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
        
        ("testExpectingNoAssertionFailure", testExpectingNoAssertionFailure),
    ]
    
}
