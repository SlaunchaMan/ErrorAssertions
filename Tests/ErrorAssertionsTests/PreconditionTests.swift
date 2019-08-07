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
        var testcaseExecutionCount = 0

        expectPreconditionFailure(expectedError: TestError.testErrorA) {
            testcaseExecutionCount += 1
            precondition(false, error: TestError.testErrorA)
        }
        
        expectPreconditionFailure(expectedError: TestError.testErrorB) { 
            testcaseExecutionCount += 1
            precondition(false, error: TestError.testErrorB)
        }

        expectPreconditionFailure(expectedError: TestError.testErrorA) { 
            testcaseExecutionCount += 1
            preconditionFailure(error: TestError.testErrorA)
        }
        
        expectPreconditionFailure(expectedError: TestError.testErrorB) { 
            testcaseExecutionCount += 1
            preconditionFailure(error: TestError.testErrorB)
        }
        
        XCTAssertEqual(testcaseExecutionCount, 4)
    }
    
    func testDefaultErrorIsABlankAnonymousError() {
        var testcaseExecutionCount = 0

        expectPreconditionFailure(expectedError: AnonymousError.blank) {
            testcaseExecutionCount += 1
            precondition(false)
        }

        expectPreconditionFailure(expectedError: AnonymousError.blank) { 
            testcaseExecutionCount += 1
            ErrorAssertions.preconditionFailure()
        }
        
        XCTAssertEqual(testcaseExecutionCount, 2)
    }
    
    func testDefaultErrorWithStringIsAnAnonymousError() {
        var testcaseExecutionCount = 0

        let expectedError = AnonymousError.withMessage("test")
        
        expectPreconditionFailure(expectedError: expectedError) { 
            testcaseExecutionCount += 1
            precondition(false, "test")
        }

        expectPreconditionFailure(expectedError: expectedError) { 
            testcaseExecutionCount += 1
            ErrorAssertions.preconditionFailure("test")
        }
        
        XCTAssertEqual(testcaseExecutionCount, 2)
    }
    
    func testPreconditionFailureWithoutCapturingError() {
        var testcaseExecutionCount = 0

        expectPreconditionFailure {
            testcaseExecutionCount += 1
            precondition(false)
        }

        expectPreconditionFailure {
            testcaseExecutionCount += 1
            ErrorAssertions.preconditionFailure()
        }
        
        XCTAssertEqual(testcaseExecutionCount, 2)
    }
    
    func testPreconditionFailureWithMessageWithoutCapturingError() {
        var testcaseExecutionCount = 0

        expectPreconditionFailure(expectedMessage: "test") {
            testcaseExecutionCount += 1
            precondition(false, "test")
        }

        expectPreconditionFailure(expectedMessage: "test") {
            testcaseExecutionCount += 1
            ErrorAssertions.preconditionFailure("test")
        }
        
        XCTAssertEqual(testcaseExecutionCount, 2)
    }
    
    func testExpectingNoPreconditionFailure() {
        var testcaseDidExecute = false
        
        expectNoPreconditionFailure {
            testcaseDidExecute = true
        }
        
        XCTAssertTrue(testcaseDidExecute)
    }
    
    func testPreconditionsDoNotContinueExecution() {
        let expectation = self.expectation(description:
            "The code after the precondition should not execute"
        )
        
        expectation.isInverted = true
        
        expectPreconditionFailure {
            precondition(false)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testPreconditionFailuresDoNotContinueExecution() {
        let expectation = self.expectation(description:
            "The code after the precondition should not execute"
        )
        
        expectation.isInverted = true
        
        expectPreconditionFailure {
            ErrorAssertions.preconditionFailure()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testPreconditionsDoContinueExecution() {
        let expectation = self.expectation(description:
            "The code after the assert executed"
        )
        
        expectNoPreconditionFailure {
            precondition(true)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testPreconditionExpectationThreadDies() {
        var thread: Thread?
        
        expectPreconditionFailure {
            thread = Thread.current
            precondition(false)
        }
        
        if let receivedThread = thread {
            XCTAssertTrue(receivedThread.isCancelled)
        }
        else {
            XCTFail("did not receive a thread")
        }
    }
    
    func testPreconditionFailureExpectationThreadDies() {
        var thread: Thread?
        
        expectPreconditionFailure {
            thread = Thread.current
            ErrorAssertions.preconditionFailure()
        }
        
        if let receivedThread = thread {
            XCTAssertTrue(receivedThread.isCancelled)
        }
        else {
            XCTFail("did not receive a thread")
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
        
        ("testExpectingNoPreconditionFailure",
         testExpectingNoPreconditionFailure),
        
        ("testPreconditionsDoNotContinueExecution",
         testPreconditionsDoNotContinueExecution),
        
        ("testPreconditionFailuresDoNotContinueExecution",
         testPreconditionFailuresDoNotContinueExecution),
        
        ("testPreconditionsDoContinueExecution",
         testPreconditionsDoContinueExecution),
        
        ("testPreconditionExpectationThreadDies",
         testPreconditionExpectationThreadDies),
        
        ("testPreconditionFailureExpectationThreadDies",
         testPreconditionFailureExpectationThreadDies),
    ]
    
}
