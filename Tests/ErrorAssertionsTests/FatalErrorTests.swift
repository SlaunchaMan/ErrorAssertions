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
            ErrorAssertions.fatalError()
        }
    }
    
    func testDefaultErrorWithStringIsAnAnonymousError() {
        let expectedError = AnonymousError.withMessage("test")
        
        expectFatalError(expectedError: expectedError) { 
            ErrorAssertions.fatalError("test")
        }
    }
    
    func testFatalErrorWithoutCapturingError() {
        expectFatalError {
            ErrorAssertions.fatalError()
        }
    }
    
    func testFatalErrorWithMessageWithoutCapturingError() {
        expectFatalError(expectedMessage: "test") {
            ErrorAssertions.fatalError("test")
        }
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
    ]
    
}
