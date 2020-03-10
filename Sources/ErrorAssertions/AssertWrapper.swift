//
//  AssertWrapper.swift
//  ErrorAssertions
//
//  Created by Jeff Kelley on 7/1/19.
//

import Foundation

/// Performs a traditional C-style assert with an `Error`.
/// - Parameters:
///   - condition: The condition to test. `condition` is only evaluated in
///                playgrounds and `-Onone` builds.
///   - error: The error that represents the assertion failure when `condition`
///            evaluates to `false`.
///   - file: The file name to print with the description of `error` if the
///           assertion fails. The default is the file where
///           `assert(_:error:file:line:)` is called.
///   - line: The line number to print along with the description of `error` if
///           the assertion fails. The default is the line number where
///           `assert(_:error:file:line:)` is called.
@inlinable
public func assert(_ condition: @autoclosure () -> Bool,
                   error: Error,
                   file: StaticString = #file,
                   line: UInt = #line) {
    AssertUtilities.assertClosure(condition(), error, file, line)
}

/// Performs a traditional C-style assert with an optional message.
/// - Parameters:
///   - condition: The condition to test. `condition` is only evaluated in
///                playgrounds and `-Onone` builds.
///   - message: A string to print if `condition` is evaluated to `false`. The
///              default is an empty string.
///   - file: The file name to print with `message` if the assertion fails. The
///           default is the file where `assert(_:_:file:line:)` is called.
///   - line: The line number to print along with message if the assertion
///           fails. The default is the line number where
///           `assert(_:_:file:line:)` is called.
@inlinable
public func assert(_ condition: @autoclosure () -> Bool,
                   _ message: @autoclosure () -> String = String(),
                   file: StaticString = #file,
                   line: UInt = #line) {
    assert(condition(), 
           error: AnonymousError(string: message()), 
           file: file, 
           line: line)
}

/// Indicates that an internal sanity check failed.
/// - Parameters:
///   - error: The error that represents the assertion failure.
///   - file: The file name to print with the description of `error`. The
///           default is the file where
///           `assertionFailure(error:file:line:)` is called.
///   - line: The line number to print along with the description of `error`.
///           The default is the line number where
///           `assertionFailure(error:file:line:)` is called.
@inlinable
public func assertionFailure(error: Error,
                             file: StaticString = #file,
                             line: UInt = #line) {
    AssertUtilities.assertionFailureClosure(error, file, line)
}

/// Indicates that an internal sanity check failed.
/// - Parameters:
///   - message: A string to print in a playground or `-Onone` build. The
///              default is an empty string.
///   - file: The file name to print with `message`. The default is the file
///           where `assertionFailure(_:file:line:)` is called.
///   - line: The line number to print along with `message`. The default is the
///           line number where `assertionFailure(_:file:line:)` is called.
@inlinable
public func assertionFailure(_ message: @autoclosure () -> String = String(),
                             file: StaticString = #file,
                             line: UInt = #line) {
    assertionFailure(error: AnonymousError(string: message()),
                     file: file,
                     line: line)
}

public enum AssertUtilities {
    
    public typealias AssertClosure = (Bool, Error, StaticString, UInt) -> ()
    
    public typealias AssertionFailureClosure =
        (Error, StaticString, UInt) -> ()
    
    internal static var _assertClosure: AssertClosure?
    
    @usableFromInline internal static var assertClosure: AssertClosure {
        return _assertClosure ?? defaultAssertClosure
    }
    
    internal static var _assertionFailureClosure: AssertionFailureClosure?
    
    @usableFromInline
    internal static var assertionFailureClosure: AssertionFailureClosure {
        return _assertionFailureClosure ?? defaultAssertionFailureClosure
    }
    
    private static let defaultAssertClosure = {
        (condition: Bool, error: Error, file: StaticString, line: UInt) in
        Swift.assert(condition, 
                     error.localizedDescription, 
                     file: file, 
                     line: line)
    }
    
    private static let defaultAssertionFailureClosure = {
        (error: Error, file: StaticString, line: UInt) in
        Swift.assertionFailure(error.localizedDescription,
                               file: file,
                               line: line)
    }
    
    static public func replaceAssert(
        with closure: @escaping AssertClosure
    ) -> RestorationHandler {
        _assertClosure = closure
        return restoreAssert
    }
    
    static private func restoreAssert() {
        _assertClosure = nil
    }
    
    static public func replaceAssertionFailure(
        with closure: @escaping AssertionFailureClosure
    ) -> RestorationHandler {
        _assertionFailureClosure = closure
        return restoreAssertionFailure
    }
    
    static private func restoreAssertionFailure() {
        _assertionFailureClosure = nil
    }
    
}
