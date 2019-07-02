//
//  FatalErrorExpectations.swift
//  ErrorAssertionExpectations
//
//  Created by Jeff Kelley on 7/1/19.
//

import XCTest

import ErrorAssertions

extension XCTestCase {
    
    /// Executes the `testcase` closure and expects it to produce a specific
    /// fatal error.
    ///
    /// - Parameters:
    ///   - expectedError: The `Error` you expect `testcase` to pass to
    ///                    `fatalError()`.
    ///   - timeout: How long to wait for `testcase` to produce its error.
    ///              defaults to 10 seconds.
    ///   - file: The test file. By default, this will be the file from which
    ///           you’re calling this method.
    ///   - line: The line number in `file` where this is called.
    ///   - queue: The dispatch queue on which to enqueue `testcase`.
    ///   - testcase: The closure to run that produces the error.
    public func expectFatalError<T: Error>(
        expectedError: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line,
        queue: @autoclosure () -> DispatchQueue = .global(),
        testcase: @escaping () -> Void)
        where T: Equatable {
            let expectation = self
                .expectation(description: "expectingFatalError_\(file):\(line)")
            
            var assertionError: T? = nil
            
            FatalErrorUtilities.replaceFatalError { error, _, _ in
                assertionError = error as? T
                expectation.fulfill()
                unreachable()
            }
            
            queue().async(execute: testcase)
            
            waitForExpectations(timeout: timeout) { _ in
                XCTAssertEqual(assertionError, 
                               expectedError, 
                               file: file, 
                               line: line)
                FatalErrorUtilities.restoreFatalError()
            }
    }
    
    /// Executes the `testcase` closure and expects it to produce a specific
    /// fatal error message.
    ///
    /// - Parameters:
    ///   - message: The `String` you expect `testcase` to pass to
    ///              `fatalError()`.
    ///   - timeout: How long to wait for `testcase` to produce its error.
    ///              defaults to 10 seconds.
    ///   - file: The test file. By default, this will be the file from which
    ///           you’re calling this method.
    ///   - line: The line number in `file` where this is called.
    ///   - queue: The dispatch queue on which to enqueue `testcase`.
    ///   - testcase: The closure to run that produces the error.
    public func expectFatalError(
        expectedMessage message: String,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line,
        queue: @autoclosure () -> DispatchQueue = .global(),
        testcase: @escaping () -> Void) {
        expectFatalError(expectedError: AnonymousError(string: message),
                         timeout: timeout,
                         file: file,
                         line: line,
                         queue: queue(),
                         testcase: testcase)
    }
    
    /// Executes the `testcase` closure and expects it to produce a fatal error.
    ///
    /// - Parameters:
    ///   - timeout: How long to wait for `testcase` to produce its error.
    ///              defaults to 10 seconds.
    ///   - file: The test file. By default, this will be the file from which
    ///           you’re calling this method.
    ///   - line: The line number in `file` where this is called.
    ///   - queue: The dispatch queue on which to enqueue `testcase`.
    ///   - testcase: The closure to run that produces the error.
    public func expectFatalError(
        timeout: TimeInterval = 10,
        in context: StaticString = #function,
        file: StaticString = #file,
        line: UInt = #line,
        queue: @autoclosure () -> DispatchQueue = .global(),
        testcase: @escaping () -> Void) {
        let expectation = self
            .expectation(description: "expectingFatalError_\(file):\(line)")
        
        FatalErrorUtilities.replaceFatalError { error, _, _ in
            expectation.fulfill()
            unreachable()
        }
        
        queue().async(execute: testcase)
        
        waitForExpectations(timeout: timeout) { _ in
            FatalErrorUtilities.restoreFatalError()
        }
    }
    
}
