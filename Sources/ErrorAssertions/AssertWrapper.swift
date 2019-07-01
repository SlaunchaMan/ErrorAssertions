//
//  AssertWrapper.swift
//  ErrorAssertions
//
//  Created by Jeff Kelley on 7/1/19.
//

public func assert(_ condition: @autoclosure () -> Bool,
                   error: Error,
                   file: StaticString = #file,
                   line: UInt = #line) {
    AssertUtilities.assertClosure(condition(), error, file, line)
}

public func assert(_ condition: @autoclosure () -> Bool,
                   _ message: @autoclosure () -> String = String(),
                   file: StaticString = #file,
                   line: UInt = #line) {
    assert(condition(), 
           error: AnonymousError(string: message()), 
           file: file, 
           line: line)
}

struct AssertUtilities {
    
    typealias AssertClosure = (Bool, Error, StaticString, UInt) -> ()
    
    fileprivate static var assertClosure = defaultAssertClosure
    
    private static let defaultAssertClosure = {
        (condition: Bool, error: Error, file: StaticString, line: UInt) in
        Swift.assert(condition, 
                     error.localizedDescription, 
                     file: file, 
                     line: line)
    }
    
    #if DEBUG
    internal static func replaceAssert(closure: @escaping AssertClosure) {
        assertClosure = closure
    }
    
    internal static func restoreAssert() {
        assertClosure = defaultAssertClosure
    }
    #endif
    
}

#if DEBUG && canImport(XCTest)
import XCTest

extension XCTestCase {
    
    /// Executes the `testcase` closure and expects it to produce a specific
    /// assertion failure.
    ///
    /// - Parameters:
    ///   - expectedError: The `Error` you expect `testcase` to pass to
    ///                    `assert()`.
    ///   - timeout: How long to wait for `testcase` to produce its error.
    ///              defaults to 2 seconds.
    ///   - file: The test file. By default, this will be the file from which
    ///           you’re calling this method.
    ///   - line: The line number in `file` where this is called.
    ///   - testcase: The closure to run that produces the error.
    public func expectAssertionFailure<T: Error>(
        expectedError: T,
        timeout: TimeInterval = 2,
        file: StaticString = #file,
        line: UInt = #line,
        testcase: @escaping () -> Void
        ) where T: Equatable {
        let expectation = self.expectation(description: "expectingAssert")
        var assertionError: T? = nil
        
        AssertUtilities.replaceAssert { condition, error, _, _ in
            assertionError = error as? T
            expectation.fulfill()
        }
        
        testcase()
        
        waitForExpectations(timeout: timeout) { _ in
            XCTAssertEqual(assertionError,
                           expectedError,
                           file: file,
                           line: line)
            
            AssertUtilities.restoreAssert()
        }
    }
    
    /// Executes the `testcase` closure and expects it to produce a specific
    /// assertion failure message.
    ///
    /// - Parameters:
    ///   - message: The `String` you expect `testcase` to pass to
    ///              `assert()`.
    ///   - timeout: How long to wait for `testcase` to produce its error.
    ///              defaults to 2 seconds.
    ///   - file: The test file. By default, this will be the file from which
    ///           you’re calling this method.
    ///   - line: The line number in `file` where this is called.
    ///   - testcase: The closure to run that produces the error.
    public func expectAssertionFailure(expectedMessage message: String,
                                       timeout: TimeInterval = 2,
                                       file: StaticString = #file,
                                       line: UInt = #line,
                                       testcase: @escaping () -> Void) {
        expectAssertionFailure(
            expectedError: AnonymousError(string: message),
            timeout: timeout,
            file: file,
            line: line,
            testcase: testcase)
    }
    
    /// Executes the `testcase` closure and expects it to produce an assertion
    /// failure.
    ///
    /// - Parameters:
    ///   - timeout: How long to wait for `testcase` to produce its error.
    ///              defaults to 2 seconds.
    ///   - file: The test file. By default, this will be the file from which
    ///           you’re calling this method.
    ///   - line: The line number in `file` where this is called.
    ///   - testcase: The closure to run that produces the error.
    public func expectAssertionFailure(timeout: TimeInterval = 2,
                                       file: StaticString = #file,
                                       line: UInt = #line,
                                       testcase: @escaping () -> Void) {
        let expectation = self
            .expectation(description: "expectingAssertion")
        
        AssertUtilities.replaceAssert {
            condition, error, _, _ in
            expectation.fulfill()
        }
        
        testcase()
        
        waitForExpectations(timeout: timeout) { _ in
            AssertUtilities.restoreAssert()
        }
    }
    
}

#endif
