//
//  FatalErrorExpectations.swift
//  ErrorAssertionExpectations
//
//  Created by Jeff Kelley on 7/1/19.
//

import XCTest

import ErrorAssertions

extension XCTestCase {
    
    private func replaceFatalError(_ handler: @escaping (Error) -> Void) -> RestorationHandler {
        return FatalErrorUtilities.replaceFatalError { error, _, _ in
            handler(error)
            unreachable()
        }
    }
    
    private func wrapWithAssertions(_ testcase: @escaping () -> Void,
                                    timeout: TimeInterval,
                                    handler: ((Error) -> Void)? = nil) {
        let expectation = self.expectation(
            description: "Expecting a fatal error to occur."
        )
        
        let restoration = replaceFatalError { error in
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
    /// fatal error.
    ///
    /// - Parameters:
    ///   - expectedError: The `Error` you expect `testcase` to pass to
    ///                    `fatalError()`.
    ///   - timeout: How long to wait for `testcase` to produce its error.
    ///              defaults to 2 seconds.
    ///   - file: The test file. By default, this will be the file from which
    ///           you’re calling this method.
    ///   - line: The line number in `file` where this is called.
    ///   - testcase: The closure to run that produces the error.
    public func expectFatalError<T: Error>(
        expectedError: T,
        timeout: TimeInterval = 2,
        file: StaticString = #file,
        line: UInt = #line,
        testcase: @escaping () -> Void
    ) where T: Equatable {
        wrapWithAssertions(testcase, timeout: timeout) { error in
            XCTAssertEqual(error as? T,
                           expectedError,
                           file: file,
                           line: line)
        }
    }
    
    /// Executes the `testcase` closure and expects it to produce a specific
    /// fatal error message.
    ///
    /// - Parameters:
    ///   - message: The `String` you expect `testcase` to pass to
    ///              `fatalError()`.
    ///   - timeout: How long to wait for `testcase` to produce its error.
    ///              defaults to 2 seconds.
    ///   - file: The test file. By default, this will be the file from which
    ///           you’re calling this method.
    ///   - line: The line number in `file` where this is called.
    ///   - testcase: The closure to run that produces the error.
    public func expectFatalError(
        expectedMessage message: String,
        timeout: TimeInterval = 2,
        file: StaticString = #file,
        line: UInt = #line,
        testcase: @escaping () -> Void
    ) {
        expectFatalError(expectedError: AnonymousError(string: message),
                         timeout: timeout,
                         file: file,
                         line: line,
                         testcase: testcase)
    }
    
    /// Executes the `testcase` closure and expects it to produce a fatal error.
    ///
    /// - Parameters:
    ///   - timeout: How long to wait for `testcase` to produce its error.
    ///              defaults to 2 seconds.
    ///   - file: The test file. By default, this will be the file from which
    ///           you’re calling this method.
    ///   - line: The line number in `file` where this is called.
    ///   - testcase: The closure to run that produces the error.
    public func expectFatalError(
        timeout: TimeInterval = 2,
        in context: StaticString = #function,
        file: StaticString = #file,
        line: UInt = #line,
        testcase: @escaping () -> Void
    ) {
        wrapWithAssertions(testcase, timeout: timeout)
    }
    
    /// Executes the `testcase` closure and expects it execute without producing
    /// a fatal error.
    ///
    /// - Parameters:
    ///   - timeout: How long to wait for `testcase` to finish. Defaults to 2
    ///              seconds.
    ///   - file: The test file. By default, this will be the file from which
    ///           you’re calling this method.
    ///   - line: The line number in `file` where this is called.
    ///   - testcase: The closure to run.
    public func expectNoFatalError(
        timeout: TimeInterval = 2,
        in context: StaticString = #function,
        file: StaticString = #file,
        line: UInt = #line,
        testcase: @escaping () -> Void
    ) {
        let expectation = self.expectation(
            description: "Expecting no fatal error to occur"
        )
        
        let restoration = replaceFatalError { _ in
            XCTFail("Received a fatal error when expecting none",
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
