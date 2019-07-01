//
//  PreconditionWrapper.swift
//  ErrorAssertions
//
//  Created by Jeff Kelley on 7/1/19.
//

public func precondition(_ condition: @autoclosure () -> Bool,
                         error: Error,
                         file: StaticString = #file,
                         line: UInt = #line) {
    PreconditionUtilities.preconditionClosure(condition(), error, file, line)
}

public func precondition(_ condition: @autoclosure () -> Bool,
                         _ message: @autoclosure () -> String = String(),
                         file: StaticString = #file,
                         line: UInt = #line) {
    precondition(condition(), 
                 error: AnonymousError(string: message()), 
                 file: file, 
                 line: line)
}

struct PreconditionUtilities {
    
    typealias PreconditionClosure = (Bool, Error, StaticString, UInt) -> ()
    
    fileprivate static var preconditionClosure = defaultPreconditionClosure
    
    private static let defaultPreconditionClosure = {
        (condition: Bool, error: Error, file: StaticString, line: UInt) in
        Swift.precondition(condition,
                           error.localizedDescription,
                           file: file, 
                           line: line)
    }
    
    #if DEBUG
    internal static func replacePrecondition(
        closure: @escaping PreconditionClosure
        ) {
        preconditionClosure = closure
    }
    
    internal static func restorePrecondition() {
        preconditionClosure = defaultPreconditionClosure
    }
    #endif
    
}

#if DEBUG && canImport(XCTest)
import XCTest

extension XCTestCase {
    
    /// Executes the `testcase` closure and expects it to produce a
    /// preconditionion failure.
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
    func expectPreconditionFailure<T: Error>(expectedError: T,
                                             timeout: TimeInterval = 2,
                                             file: StaticString = #file,
                                             line: UInt = #line,
                                             testcase: @escaping () -> Void)
        where T: Equatable {
            let expectation = self
                .expectation(description: "expectingPrecondition")
            
            var preconditionError: T? = nil
            
            PreconditionUtilities.replacePrecondition {
                condition, error, _, _ in
                preconditionError = error as? T
                expectation.fulfill()
            }
            
            testcase()
            
            waitForExpectations(timeout: timeout) { _ in
                XCTAssertEqual(preconditionError,
                               expectedError,
                               file: file,
                               line: line)
                
                PreconditionUtilities.restorePrecondition()
            }
    }
    
}

#endif
