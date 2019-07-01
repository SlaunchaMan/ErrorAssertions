//
//  FatalErrorWrapper.swift
//  ErrorAssertions
//
//  Created by Jeff Kelley on 7/1/19.
//

public func fatalError(_ error: Error,
                       file: StaticString = #file,
                       line: UInt = #line) -> Never {
    FatalErrorUtilities.fatalErrorClosure(error, file, line)
}

public func fatalError(_ message: @autoclosure () -> String = String(),
                       file: StaticString = #file,
                       line: UInt = #line) -> Never {
    fatalError(AnonymousError(string: message()),
               file: file,
               line: line)
}

struct FatalErrorUtilities {
    
    typealias FatalErrorClosure = (Error, StaticString, UInt) -> Never
    
    fileprivate static var fatalErrorClosure = defaultFatalErrorClosure
    
    private static let defaultFatalErrorClosure = {
        (error: Error, file: StaticString, line: UInt) -> Never in
        Swift.fatalError(error.localizedDescription,
                         file: file,
                         line: line)
    }
    
    #if DEBUG
    internal static func replaceFatalError(
        closure: @escaping FatalErrorClosure
        ) {
        fatalErrorClosure = closure
    }
    
    internal static func restoreFatalError() {
        fatalErrorClosure = defaultFatalErrorClosure
    }
    #endif
    
}

#if DEBUG && canImport(XCTest)
import XCTest

extension XCTestCase {
    
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
    ///   - queue: The dispatch queue on which to enqueue `testcase`.
    ///   - testcase: The closure to run that produces the error.
    public func expectFatalError<T: Error>(
        expectedError: T,
        timeout: TimeInterval = 2,
        file: StaticString = #file,
        line: UInt = #line,
        queue: @autoclosure () -> DispatchQueue = .global(),
        testcase: @escaping () -> Void)
        where T: Equatable {
            let expectation = self
                .expectation(description: "expectingFatalError")
            
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
    ///              defaults to 2 seconds.
    ///   - file: The test file. By default, this will be the file from which
    ///           you’re calling this method.
    ///   - line: The line number in `file` where this is called.
    ///   - queue: The dispatch queue on which to enqueue `testcase`.
    ///   - testcase: The closure to run that produces the error.
    public func expectFatalError(
        expectedMessage message: String,
        timeout: TimeInterval = 2,
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
    ///              defaults to 2 seconds.
    ///   - file: The test file. By default, this will be the file from which
    ///           you’re calling this method.
    ///   - line: The line number in `file` where this is called.
    ///   - queue: The dispatch queue on which to enqueue `testcase`.
    ///   - testcase: The closure to run that produces the error.
    public func expectFatalError(
        timeout: TimeInterval = 2,
        file: StaticString = #file,
        line: UInt = #line,
        queue: @autoclosure () -> DispatchQueue = .global(),
        testcase: @escaping () -> Void) {
        let expectation = self
            .expectation(description: "expectingPrecondition")
        
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

#endif
