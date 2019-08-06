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
    
    func testAssertionsDoNotContinueExecution() {
        let expectation = self.expectation(description:
            "The code after the assert should not execute"
        )
        
        expectation.isInverted = true
        
        expectAssertionFailure {
            assert(false)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testAssertionFailuresDoNotContinueExecution() {
        let expectation = self.expectation(description:
            "The code after the assert should not execute"
        )
        
        expectation.isInverted = true
        
        expectAssertionFailure {
            assertionFailure()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testAssertionsDoContinueExecution() {
        let expectation = self.expectation(description:
            "The code after the assert executed"
        )
        
        expectNoAssertionFailure {
            assert(true)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testAssertExpectationThreadDies() {
        var thread: Thread?
        
        expectAssertionFailure {
            thread = Thread.current
            assert(false)
        }
        
        do {
            let receivedThread = try XCTUnwrap(thread)
            XCTAssertTrue(receivedThread.isCancelled)
        }
        catch {
            XCTFail("did not receive a thread")
        }
    }
    
    func testAssertionFailureExpectationThreadDies() {
        var thread: Thread?
        
        expectAssertionFailure {
            thread = Thread.current
            assertionFailure()
        }
        
        do {
            let receivedThread = try XCTUnwrap(thread)
            XCTAssertTrue(receivedThread.isCancelled)
        }
        catch {
            XCTFail("did not receive a thread")
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
        
        ("testAssertionsDoNotContinueExecution",
         testAssertionsDoNotContinueExecution),
        
        ("testAssertionFailuresDoNotContinueExecution",
         testAssertionFailuresDoNotContinueExecution),
        
        ("testAssertionsDoContinueExecution",
         testAssertionsDoContinueExecution),
        
        ("testAssertExpectationThreadDies", testAssertExpectationThreadDies),
        
        ("testAssertionFailureExpectationThreadDies",
         testAssertionFailureExpectationThreadDies),
        
    ]
    
}
