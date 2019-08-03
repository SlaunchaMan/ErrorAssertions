//
//  FatalErrorTests.swift
//  ErrorAssertionsTests
//
//  Created by Jeff Kelley on 7/1/19.
//

import XCTest

@testable import ErrorAssertions

final class FatalErrorTests: XCTestCase {
    
    func testFatalErrorsSendExpectedErrors() {
        expectFatalError(expectedError: TestError.testErrorA) { 
            fatalError(TestError.testErrorA)
        }
        
        expectFatalError(expectedError: TestError.testErrorB) { 
            fatalError(TestError.testErrorB)
        }
    }
    
    func testDefaultErrorIsABlankAnonymousError() {
        expectFatalError(expectedError: AnonymousError.blank) { 
            fatalError()
        }
    }
    
    func testDefaultErrorWithStringIsAnAnonymousError() {
        let expectedError = AnonymousError.withMessage("test")
        
        expectFatalError(expectedError: expectedError) { 
            fatalError("test")
        }
    }
    
    func testFatalErrorWithoutCapturingError() {
        expectFatalError {
            fatalError()
        }
    }
    
    func testFatalErrorWithMessageWithoutCapturingError() {
        expectFatalError(expectedMessage: "test") {
            fatalError("test")
        }
    }
    
    func testExpectingNoFatalError() {
        expectNoFatalError {

        }
    }
    
    func testFatalErrorsDoNotContinueExecution() {
        let expectation = self.expectation(
            description: "The code after the fatal error should not execute"
        )
        
        expectation.isInverted = true
        
        expectFatalError {
            defer { expectation.fulfill() }
            fatalError()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    static var allTests = [
        ("testFatalErrorsSendExpectedErrors",
         testFatalErrorsSendExpectedErrors),
        
        ("testDefaultErrorIsABlankAnonymousError",
         testDefaultErrorIsABlankAnonymousError),
        
        ("testDefaultErrorWithStringIsAnAnonymousError",
         testDefaultErrorWithStringIsAnAnonymousError),
        
        ("testFatalErrorWithoutCapturingError",
         testFatalErrorWithoutCapturingError),
        
        ("testFatalErrorWithMessageWithoutCapturingError",
         testFatalErrorWithMessageWithoutCapturingError),
        
        ("testExpectingNoFatalError", testExpectingNoFatalError),
        
        ("testFatalErrorsDoNotContinueExecution",
         testFatalErrorsDoNotContinueExecution)
    ]
    
}
