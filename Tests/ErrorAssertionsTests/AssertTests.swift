//
//  AssertTests.swift
//  ErrorAssertionsTests
//
//  Created by Jeff Kelley on 7/1/19.
//

import XCTest

@testable import ErrorAssertions
import ErrorAssertionExpectations

final class AssertTests: XCTestCase {
    
    func testAssertionFailuresSendExpectedErrors() {
        var testcaseExecutionCount = 0
        
        expectAssertionFailure(expectedError: TestError.testErrorA) { 
            testcaseExecutionCount += 1
            ErrorAssertions.assert(false, error: TestError.testErrorA)
        }
        
        expectAssertionFailure(expectedError: TestError.testErrorB) { 
            testcaseExecutionCount += 1
            ErrorAssertions.assert(false, error: TestError.testErrorB)
        }
        
        expectAssertionFailure(expectedError: TestError.testErrorA) {
            testcaseExecutionCount += 1
            ErrorAssertions.assertionFailure(error: TestError.testErrorA)
        }
        
        expectAssertionFailure(expectedError: TestError.testErrorB) { 
            testcaseExecutionCount += 1
            ErrorAssertions.assertionFailure(error: TestError.testErrorB)
        }
        
        XCTAssertEqual(testcaseExecutionCount, 4)
    }
    
    func testDefaultErrorIsABlankAnonymousError() {
        var testcaseExecutionCount = 0

        expectAssertionFailure(expectedError: AnonymousError.blank) {
            testcaseExecutionCount += 1
            ErrorAssertions.assert(false)
        }
        
        expectAssertionFailure(expectedError: AnonymousError.blank) { 
            testcaseExecutionCount += 1
            ErrorAssertions.assertionFailure()
        }
        
        XCTAssertEqual(testcaseExecutionCount, 2)
    }
    
    func testDefaultErrorWithStringIsAnAnonymousError() {
        var testcaseExecutionCount = 0

        let expectedError = AnonymousError.withMessage("test")
        
        expectAssertionFailure(expectedError: expectedError) { 
            testcaseExecutionCount += 1
            ErrorAssertions.assert(false, "test")
        }
        
        expectAssertionFailure(expectedError: expectedError) { 
            testcaseExecutionCount += 1
            ErrorAssertions.assertionFailure("test")
        }

        XCTAssertEqual(testcaseExecutionCount, 2)
    }
    
    func testAssertionFailureWithoutCapturingError() {
        var testcaseExecutionCount = 0

        expectAssertionFailure {
            testcaseExecutionCount += 1
            ErrorAssertions.assert(false)
        }
        
        expectAssertionFailure {
            testcaseExecutionCount += 1
            ErrorAssertions.assertionFailure()
        }
        
        XCTAssertEqual(testcaseExecutionCount, 2)
    }
    
    func testAssertionFailureWithMessageWithoutCapturingError() {
        var testcaseExecutionCount = 0

        expectAssertionFailure(expectedMessage: "test") {
            testcaseExecutionCount += 1
            ErrorAssertions.assert(false, "test")
        }
        
        expectAssertionFailure(expectedMessage: "test") {
            testcaseExecutionCount += 1
            ErrorAssertions.assertionFailure("test")
        }

        XCTAssertEqual(testcaseExecutionCount, 2)
    }
    
    func testExpectingNoAssertionFailure() {
        var testcaseDidExecute = false
        
        expectNoAssertionFailure {
            testcaseDidExecute = true
        }
        
        XCTAssertTrue(testcaseDidExecute)
    }
    
    func testAssertionsDoNotContinueExecution() {
        let expectation = self.expectation(description:
            "The code after the assert should not execute"
        )
        
        expectation.isInverted = true
        
        expectAssertionFailure {
            ErrorAssertions.assert(false)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testAssertionFailuresDoNotContinueExecution() {
        let expectation = self.expectation(description:
            "The code after the assertion failure should not execute"
        )
        
        expectation.isInverted = true
        
        expectAssertionFailure {
            ErrorAssertions.assertionFailure()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testAssertionsDoContinueExecution() {
        let expectation = self.expectation(description:
            "The code after the assert executed"
        )
        
        expectNoAssertionFailure {
            ErrorAssertions.assert(true)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testAssertExpectationThreadDies() {
        var thread: Thread?
        
        expectAssertionFailure {
            thread = Thread.current
            ErrorAssertions.assert(false)
        }
        
        if let receivedThread = thread {
            XCTAssertTrue(receivedThread.isCancelled)
        }
        else {
            XCTFail("did not receive a thread")
        }
    }
    
    func testAssertionFailureExpectationThreadDies() {
        var thread: Thread?
        
        expectAssertionFailure {
            thread = Thread.current
            ErrorAssertions.assertionFailure()
        }
        
        if let receivedThread = thread {
            XCTAssertTrue(receivedThread.isCancelled)
        }
        else {
            XCTFail("did not receive a thread")
        }
    }
    
    func testNoAssertionFailureExpectationThreadDies() {
        var thread: Thread?
        
        expectNoAssertionFailure {
            thread = Thread.current
            ErrorAssertions.assert(true)
        }
        
        if let receivedThread = thread {
            XCTAssertTrue(receivedThread.isCancelled)
        }
        else {
            XCTFail("did not receive a thread")
        }
    }
    
    func testAssertionMethodsAreReplacedAfterTestFinishes() {
        expectAssertionFailure {
            ErrorAssertions.assert(false)
        }
        
        XCTAssertNil(AssertUtilities._assertClosure)
        XCTAssertNil(AssertUtilities._assertionFailureClosure)
        
        expectAssertionFailure {
            ErrorAssertions.assertionFailure()
        }

        XCTAssertNil(AssertUtilities._assertClosure)
        XCTAssertNil(AssertUtilities._assertionFailureClosure)

        expectNoAssertionFailure {
            ErrorAssertions.assert(true)
        }
        
        XCTAssertNil(AssertUtilities._assertClosure)
        XCTAssertNil(AssertUtilities._assertionFailureClosure)
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
        
        ("testAssertionsDoNotContinueExecution",
         testAssertionsDoNotContinueExecution),
        
        ("testAssertionFailuresDoNotContinueExecution",
         testAssertionFailuresDoNotContinueExecution),
        
        ("testAssertionsDoContinueExecution",
         testAssertionsDoContinueExecution),
        
        ("testAssertExpectationThreadDies", testAssertExpectationThreadDies),
        
        ("testAssertionFailureExpectationThreadDies",
         testAssertionFailureExpectationThreadDies),
        
        ("testNoAssertionFailureExpectationThreadDies",
         testNoAssertionFailureExpectationThreadDies),
        
        ("testAssertionMethodsAreReplacedAfterTestFinishes",
         testAssertionMethodsAreReplacedAfterTestFinishes),
        
    ]
    
}
