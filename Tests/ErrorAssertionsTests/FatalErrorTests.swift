//
//  FatalErrorTests.swift
//  ErrorAssertionsTests
//
//  Created by Jeff Kelley on 7/1/19.
//

import XCTest

@testable import ErrorAssertions

#if !COCOAPODS
import ErrorAssertionExpectations
#endif

final class FatalErrorTests: XCTestCase {
    
    func testFatalErrorsSendExpectedErrors() {
        var testcaseExecutionCount = 0
        
        expectFatalError(expectedError: TestError.testErrorA) {
            testcaseExecutionCount += 1
            ErrorAssertions.fatalError(TestError.testErrorA)
        }
        
        expectFatalError(expectedError: TestError.testErrorB) {
            testcaseExecutionCount += 1
            ErrorAssertions.fatalError(TestError.testErrorB)
        }
        
        XCTAssertEqual(testcaseExecutionCount, 2)
    }
    
    func testDefaultErrorIsABlankAnonymousError() {
        var testcaseDidExecute = false
        
        expectFatalError(expectedError: AnonymousError.blank) {
            testcaseDidExecute = true
            ErrorAssertions.fatalError()
        }
        
        XCTAssertTrue(testcaseDidExecute)
    }
    
    func testDefaultErrorWithStringIsAnAnonymousError() {
        var testcaseDidExecute = false
        let expectedError = AnonymousError.withMessage("test")
        
        expectFatalError(expectedError: expectedError) { 
            testcaseDidExecute = true
            ErrorAssertions.fatalError("test")
        }

        XCTAssertTrue(testcaseDidExecute)
    }
    
    func testFatalErrorWithoutCapturingError() {
        var testcaseDidExecute = false

        expectFatalError {
            testcaseDidExecute = true
            ErrorAssertions.fatalError()
        }

        XCTAssertTrue(testcaseDidExecute)
    }
    
    func testFatalErrorWithMessageWithoutCapturingError() {
        var testcaseDidExecute = false

        expectFatalError(expectedMessage: "test") {
            testcaseDidExecute = true
            ErrorAssertions.fatalError("test")
        }

        XCTAssertTrue(testcaseDidExecute)
    }
    
    func testExpectingNoFatalError() {
        var testcaseDidExecute = false

        expectNoFatalError {
            testcaseDidExecute = true
        }

        XCTAssertTrue(testcaseDidExecute)
    }
    
    func testFatalErrorsDoNotContinueExecution() {
        let expectation = self.expectation(
            description: "The code after the fatal error should not execute"
        )
        
        expectation.isInverted = true
        
        expectFatalError {
            defer { expectation.fulfill() }
            ErrorAssertions.fatalError()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testFatalErrorExpectationThreadDies() {
        var thread: Thread?
        
        expectFatalError {
            thread = Thread.current
            ErrorAssertions.fatalError()
        }
        
        if let receivedThread = thread {
            XCTAssertTrue(receivedThread.isCancelled)
        }
        else {
            XCTFail("did not receive a thread")
        }
    }
    
    func testNoFatalErrorExpectationThreadDies() {
        var thread: Thread?
        
        expectNoFatalError {
            thread = Thread.current
        }
        
        if let receivedThread = thread {
            XCTAssertTrue(receivedThread.isCancelled)
        }
        else {
            XCTFail("did not receive a thread")
        }
    }
    
    func testFatalErrorMethodsAreReplacedAfterTestFinishes() {
        expectFatalError {
            ErrorAssertions.fatalError()
        }
        
        XCTAssertNil(FatalErrorUtilities._fatalErrorClosure)
        
        expectNoFatalError {
            
        }

        XCTAssertNil(FatalErrorUtilities._fatalErrorClosure)
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
         testFatalErrorsDoNotContinueExecution),
        
        ("testFatalErrorExpectationThreadDies",
         testFatalErrorExpectationThreadDies),
        
        ("testNoFatalErrorExpectationThreadDies",
         testNoFatalErrorExpectationThreadDies),
        
        ("testFatalErrorMethodsAreReplacedAfterTestFinishes",
         testFatalErrorMethodsAreReplacedAfterTestFinishes)
    ]
    
}
