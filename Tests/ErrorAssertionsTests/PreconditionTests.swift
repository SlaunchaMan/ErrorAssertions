//
//  PreconditionTests.swift
//  ErrorAssertionsTests
//
//  Created by Jeff Kelley on 7/1/19.
//

import XCTest

@testable import ErrorAssertions

#if !COCOAPODS
import ErrorAssertionExpectations
#endif

final class PreconditionTests: XCTestCase {
    
    func testPreconditionFailuresSendExpectedErrors() {
        var testcaseExecutionCount = 0

        expectPreconditionFailure(expectedError: TestError.testErrorA) {
            testcaseExecutionCount += 1
            ErrorAssertions.precondition(false, error: TestError.testErrorA)
        }
        
        expectPreconditionFailure(expectedError: TestError.testErrorB) { 
            testcaseExecutionCount += 1
            ErrorAssertions.precondition(false, error: TestError.testErrorB)
        }

        expectPreconditionFailure(expectedError: TestError.testErrorA) { 
            testcaseExecutionCount += 1
            ErrorAssertions.preconditionFailure(error: TestError.testErrorA)
        }
        
        expectPreconditionFailure(expectedError: TestError.testErrorB) { 
            testcaseExecutionCount += 1
            ErrorAssertions.preconditionFailure(error: TestError.testErrorB)
        }
        
        XCTAssertEqual(testcaseExecutionCount, 4)
    }
    
    func testDefaultErrorIsABlankAnonymousError() {
        var testcaseExecutionCount = 0

        expectPreconditionFailure(expectedError: AnonymousError.blank) {
            testcaseExecutionCount += 1
            ErrorAssertions.precondition(false)
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
            ErrorAssertions.precondition(false, "test")
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
            ErrorAssertions.precondition(false)
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
            ErrorAssertions.precondition(false, "test")
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
    
    func testPreconditionsThatFailDoNotContinueExecution() {
        let expectation = self.expectation(description:
            "The code after the precondition should not execute"
        )
        
        expectation.isInverted = true
        
        expectPreconditionFailure {
            ErrorAssertions.precondition(false)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testPreconditionFailuresDoNotContinueExecution() {
        let expectation = self.expectation(description:
            "The code after the precondition failure should not execute"
        )
        
        expectation.isInverted = true
        
        expectPreconditionFailure {
            defer {
                // This will never actually execute, as `preconditionFailure()`
                // returns `Never`. But the code can’t go after that line, or
                // the compiler will (rightly) recognize that the code will
                // never execute. Putting it in a `defer` block seems to avoid
                // that inspection.
                expectation.fulfill()
            }
            ErrorAssertions.preconditionFailure()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testPreconditionsThatSucceedDoContinueExecution() {
        let expectation = self.expectation(description:
            "The code after the assert executed"
        )
        
        expectNoPreconditionFailure {
            ErrorAssertions.precondition(true)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testPreconditionExpectationThreadDies() {
        var thread: Thread?
        
        expectPreconditionFailure {
            thread = Thread.current
            ErrorAssertions.precondition(false)
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
    
    func testNoPreconditionFailureExpectationThreadDies() {
        var thread: Thread?
        
        expectNoPreconditionFailure {
            thread = Thread.current
            ErrorAssertions.precondition(true)
        }
        
        if let receivedThread = thread {
            XCTAssertTrue(receivedThread.isCancelled)
        }
        else {
            XCTFail("did not receive a thread")
        }
    }
    
    func testPreconditionMethodsAreReplacedAfterTestFinishes() {
        expectPreconditionFailure {
            ErrorAssertions.precondition(false)
        }
        
        XCTAssertNil(PreconditionUtilities._preconditionClosure)
        XCTAssertNil(PreconditionUtilities._preconditionFailureClosure)
        
        expectPreconditionFailure {
            ErrorAssertions.preconditionFailure()
        }

        XCTAssertNil(PreconditionUtilities._preconditionClosure)
        XCTAssertNil(PreconditionUtilities._preconditionFailureClosure)

        expectNoPreconditionFailure {
            ErrorAssertions.precondition(true)
        }
        
        XCTAssertNil(PreconditionUtilities._preconditionClosure)
        XCTAssertNil(PreconditionUtilities._preconditionFailureClosure)
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
        
        ("testPreconditionsThatFailDoNotContinueExecution",
         testPreconditionsThatFailDoNotContinueExecution),
        
        ("testPreconditionFailuresDoNotContinueExecution",
         testPreconditionFailuresDoNotContinueExecution),
        
        ("testPreconditionsThatSucceedDoContinueExecution",
         testPreconditionsThatSucceedDoContinueExecution),
        
        ("testPreconditionExpectationThreadDies",
         testPreconditionExpectationThreadDies),
        
        ("testPreconditionFailureExpectationThreadDies",
         testPreconditionFailureExpectationThreadDies),
        
        ("testNoPreconditionFailureExpectationThreadDies",
         testNoPreconditionFailureExpectationThreadDies),
        
        ("testPreconditionMethodsAreReplacedAfterTestFinishes",
         testPreconditionMethodsAreReplacedAfterTestFinishes)
    ]
    
}
