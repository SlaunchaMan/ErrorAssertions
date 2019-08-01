//
//  PreconditionExpectations.swift
//  ErrorAssertionExpectations
//
//  Created by Jeff Kelley on 7/1/19.
//

import XCTest

import ErrorAssertions

extension XCTestCase {
    
    /// Executes the `testcase` closure and expects it to produce a specific
    /// precondition failure.
    ///
    /// - Parameters:
    ///   - expectedError: The `Error` you expect `testcase` to pass to
    ///                    `precondition()`.
    ///   - timeout: How long to wait for `testcase` to produce its error.
    ///              defaults to 2 seconds.
    ///   - file: The test file. By default, this will be the file from which
    ///           you’re calling this method.
    ///   - line: The line number in `file` where this is called.
    ///   - testcase: The closure to run that produces the error.
    public func expectPreconditionFailure<T: Error>(
        expectedError: T,
        timeout: TimeInterval = 2,
        file: StaticString = #file,
        line: UInt = #line,
        testcase: @escaping () -> Void
    ) where T: Equatable {
        let expectation = self.expectation(
            description: "expectingPrecondition_\(file):\(line)")
        
        var preconditionError: T? = nil
        
        PreconditionUtilities.replacePrecondition { condition, error, _, _ in
            if !condition {
                preconditionError = error as? T
                expectation.fulfill()
                unreachable()
            }
        }
        
        PreconditionUtilities.replacePreconditionFailure {
            error, _, _ -> Never in
            preconditionError = error as? T
            expectation.fulfill()
            unreachable()
        }
        
        let thread = ClosureThread(testcase)
        thread.start()
        
        waitForExpectations(timeout: timeout) { _ in
            XCTAssertEqual(preconditionError,
                           expectedError,
                           file: file,
                           line: line)
            
            PreconditionUtilities.restorePrecondition()
            PreconditionUtilities.restorePreconditionFailure()
            
            thread.cancel()
        }
        
    }
    
    /// Executes the `testcase` closure and expects it to produce a specific
    /// precondition failure message.
    ///
    /// - Parameters:
    ///   - message: The `String` you expect `testcase` to pass to
    ///              `precondition()`.
    ///   - timeout: How long to wait for `testcase` to produce its error.
    ///              defaults to 2 seconds.
    ///   - file: The test file. By default, this will be the file from which
    ///           you’re calling this method.
    ///   - line: The line number in `file` where this is called.
    ///   - testcase: The closure to run that produces the error.
    public func expectPreconditionFailure(
        expectedMessage message: String,
        timeout: TimeInterval = 2,
        file: StaticString = #file,
        line: UInt = #line,
        testcase: @escaping () -> Void
    ) {
        expectPreconditionFailure(
            expectedError: AnonymousError(string: message),
            timeout: timeout,
            file: file,
            line: line,
            testcase: testcase)
    }
    
    /// Executes the `testcase` closure and expects it to produce a
    /// precondition failure.
    ///
    /// - Parameters:
    ///   - timeout: How long to wait for `testcase` to produce its error.
    ///              defaults to 2 seconds.
    ///   - file: The test file. By default, this will be the file from which
    ///           you’re calling this method.
    ///   - line: The line number in `file` where this is called.
    ///   - testcase: The closure to run that produces the error.
    public func expectPreconditionFailure(
        timeout: TimeInterval = 2,
        file: StaticString = #file,
        line: UInt = #line,
        testcase: @escaping () -> Void
    ) {
        let expectation = self.expectation(
            description: "expectingPrecondition_\(file):\(line)")
        
        PreconditionUtilities.replacePrecondition {
            condition, _, _, _ in
            if !condition {
                expectation.fulfill()
                unreachable()
            }
        }
        
        PreconditionUtilities.replacePreconditionFailure { _, _, _ -> Never in
            expectation.fulfill()
            unreachable()
        }
        
        let thread = ClosureThread(testcase)
        thread.start()
        
        waitForExpectations(timeout: timeout) { _ in
            PreconditionUtilities.restorePrecondition()
            PreconditionUtilities.restorePreconditionFailure()
            thread.cancel()
        }
    }
    
}
