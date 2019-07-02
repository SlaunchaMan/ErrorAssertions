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
    ///              defaults to 10 seconds.
    ///   - file: The test file. By default, this will be the file from which
    ///           you’re calling this method.
    ///   - line: The line number in `file` where this is called.
    ///   - queue: The dispatch queue on which to enqueue `testcase`.
    ///   - testcase: The closure to run that produces the error.
    public func expectPreconditionFailure<T: Error>(
        expectedError: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line,
        queue: @autoclosure () -> DispatchQueue = .global(),
        testcase: @escaping () -> Void)
        where T: Equatable {
            let expectation = self.expectation(
                description: "expectingPrecondition_\(file):\(line)")
            
            var preconditionError: T? = nil
            
            PreconditionUtilities.replacePrecondition {
                condition, error, _, _ in
                preconditionError = error as? T
                expectation.fulfill()
                if !condition { unreachable() }
            }
            
            queue().async(execute: testcase)
            
            waitForExpectations(timeout: timeout) { _ in
                XCTAssertEqual(preconditionError,
                               expectedError,
                               file: file,
                               line: line)
                
                PreconditionUtilities.restorePrecondition()
            }
    }
    
    /// Executes the `testcase` closure and expects it to produce a specific
    /// precondition failure message.
    ///
    /// - Parameters:
    ///   - message: The `String` you expect `testcase` to pass to
    ///              `precondition()`.
    ///   - timeout: How long to wait for `testcase` to produce its error.
    ///              defaults to 10 seconds.
    ///   - file: The test file. By default, this will be the file from which
    ///           you’re calling this method.
    ///   - line: The line number in `file` where this is called.
    ///   - queue: The dispatch queue on which to enqueue `testcase`.
    ///   - testcase: The closure to run that produces the error.
    public func expectPreconditionFailure(
        expectedMessage message: String,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line,
        queue: @autoclosure () -> DispatchQueue = .global(),
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
    ///              defaults to 10 seconds.
    ///   - file: The test file. By default, this will be the file from which
    ///           you’re calling this method.
    ///   - line: The line number in `file` where this is called.
    ///   - queue: The dispatch queue on which to enqueue `testcase`.
    ///   - testcase: The closure to run that produces the error.
    public func expectPreconditionFailure(
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line,
        queue: @autoclosure () -> DispatchQueue = .global(),
        testcase: @escaping () -> Void
        ) {
        let expectation = self.expectation(
            description: "expectingPrecondition_\(file):\(line)")
        
        PreconditionUtilities.replacePrecondition {
            condition, error, _, _ in
            expectation.fulfill()
            if !condition { unreachable() }
        }
        
        queue().async(execute: testcase)
        
        waitForExpectations(timeout: timeout) { _ in
            PreconditionUtilities.restorePrecondition()
        }
    }
    
}
