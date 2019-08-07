//
//  PreconditionExpectations.swift
//  ErrorAssertionExpectations
//
//  Created by Jeff Kelley on 7/1/19.
//

import XCTest

import ErrorAssertions

extension XCTestCase {
    
    private func replacePrecondition(_ handler: @escaping (Error) -> Void) -> RestorationHandler {
        var restorationHandlers: [() -> Void] = []
        
        restorationHandlers.append(
            PreconditionUtilities.replacePrecondition { condition, error, _, _ in
                if !condition {
                    handler(error)
                    unreachable()
                }
            }
        )
        
        restorationHandlers.append(
            PreconditionUtilities.replacePreconditionFailure { error, _, _ in
                handler(error)
                unreachable()
            }
        )
        
        return {
            restorationHandlers.forEach { $0() }
        }
    }
    
    private func wrapWithAssertions(_ testcase: @escaping () -> Void,
                                    timeout: TimeInterval,
                                    handler: ((Error) -> Void)? = nil) {
        let expectation = self.expectation(
            description: "Expecting a precondition failure to occur."
        )
        
        let restoration = replacePrecondition { error in
            handler?(error)
            expectation.fulfill()
        }
        
        defer { restoration() }
        
        let thread = ClosureThread(testcase)
        thread.start()
        
        wait(for: [expectation], timeout: timeout)
        
        thread.cancel()
    }
    
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
        let equalityExpectation = expectation(
            description: "The error was equal to the expected value"
        )
        
        wrapWithAssertions(testcase, timeout: timeout) { error in
            if let error = error as? T, error == expectedError {
                equalityExpectation.fulfill()
            }
        }
        
        wait(for: [equalityExpectation], timeout: timeout)
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
        wrapWithAssertions(testcase, timeout: timeout)
    }
    
    /// Executes the `testcase` closure and expects it finish without producing
    /// a precondition failure.
    ///
    /// - Parameters:
    ///   - timeout: How long to wait for `testcase` to finish. Defaults to 2
    ///              seconds.
    ///   - file: The test file. By default, this will be the file from which
    ///           you’re calling this method.
    ///   - line: The line number in `file` where this is called.
    ///   - testcase: The closure to run.
    public func expectNoPreconditionFailure(
        timeout: TimeInterval = 2,
        file: StaticString = #file,
        line: UInt = #line,
        testcase: @escaping () -> Void
    ) {
        let expectation = self.expectation(
            description: "Expecting no precondition failure to occur"
        )
        
        let restoration = replacePrecondition { _ in
            XCTFail("Received a precondition failure when expecting none",
                    file: file,
                    line: line)
            
            expectation.fulfill()
        }
        
        defer { restoration() }
        
        let thread = ClosureThread {
            testcase()
            expectation.fulfill()
        }
        
        thread.start()
        
        wait(for: [expectation], timeout: timeout)
        
        thread.cancel()
    }
    
}
