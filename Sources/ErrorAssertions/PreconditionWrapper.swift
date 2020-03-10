//
//  PreconditionWrapper.swift
//  ErrorAssertions
//
//  Created by Jeff Kelley on 7/1/19.
//

import Foundation

/// Checks a necessary condition for making forward progress.
/// - Parameters:
///   - condition: The condition to test. `condition is not evaluated in
///                `-Ounchecked` builds.
///   - error: The error that represents the precondition failure when
///            `condition` evaluates to `false`.
///   - file: The file name to print with the description of `error` if the
///           precondition fails. The default is the file where 
///           `precondition(_:error:file:line:)` is called.
///   - line: The line number to print along with the description of `error` if
///           the precondition fails. The default is the line number where
///           `precondition(_:error:file:line:)` is called.
@inlinable
public func precondition(_ condition: @autoclosure () -> Bool,
                         error: Error,
                         file: StaticString = #file,
                         line: UInt = #line) {
    PreconditionUtilities.preconditionClosure(condition(), error, file, line)
}

/// Checks a necessary condition for making forward progress.
/// - Parameters:
///   - condition: The condition to test. `condition` is not evaluated in
///                `-Ounchecked` builds.
///   - message: A string to print if `condition` is evaluated to `false` in a
///              playground or `-Onone` build. The default is an empty string.
///   - file: The file name to print with `message` if the precondition fails.
///           The default is the file where `precondition(_:_:file:line:)` is
///           called.
///   - line: The line number to print along with `message` if the precondition
///           fails. The default is the line number where
///           `precondition(_:_:file:line:)` is called.
@inlinable
public func precondition(_ condition: @autoclosure () -> Bool,
                         _ message: @autoclosure () -> String = String(),
                         file: StaticString = #file,
                         line: UInt = #line) {
    precondition(condition(), 
                 error: AnonymousError(string: message()), 
                 file: file, 
                 line: line)
}

/// Indicates that a precondition was violated.
/// - Parameters:
///   - error: The error that represents the precondition failure.
///   - file: The file name to print with the description of `error`. The
///           default is the file where `preconditionFailure(error:file:line:)`
///           is called.
///   - line: The line number to print along with the description of `error`.
///           The default is the line number where
///           `preconditionFailure(error:file:line:)` is called.
@inlinable
public func preconditionFailure(error: Error,
                                file: StaticString = #file,
                                line: UInt = #line) -> Never {
    PreconditionUtilities.preconditionFailureClosure(error, file, line)
}

/// Indicates that a precondition was violated.
/// - Parameters:
///   - message: A string to print in a playground or `-Onone` build. The
///              default is an empty string.
///   - file: The file name to print with `message`. The default is the file
///           where `preconditionFailure(_:file:line:)` is called.
///   - line: The line number to print along with `message`. The default is the
///           line number where `preconditionFailure(_:file:line:)` is called.
@inlinable
public func preconditionFailure(_ message: @autoclosure () -> String = String(),
                                file: StaticString = #file,
                                line: UInt = #line) -> Never {
    preconditionFailure(error: AnonymousError(string: message()),
                        file: file,
                        line: line)
}

/// A utility type that replaces the internal implementation of precondition
/// functions.
public enum PreconditionUtilities {
    
    /// A closure that handles a precondition.
    public typealias PreconditionClosure =
        (Bool, Error, StaticString, UInt) -> ()
    
    /// A closure that handles a precondition failure. 
    public typealias PreconditionFailureClosure = 
        (Error, StaticString, UInt) -> Never
    
    internal static var _preconditionClosure: PreconditionClosure?
    
    @usableFromInline
    internal static var preconditionClosure: PreconditionClosure {
        return _preconditionClosure ?? defaultPreconditionClosure
    }
    
    internal static var _preconditionFailureClosure: PreconditionFailureClosure?
        
    @usableFromInline
    internal static var preconditionFailureClosure: PreconditionFailureClosure {
        return _preconditionFailureClosure ?? defaultPreconditionFailureClosure
    }
    
    private static let defaultPreconditionClosure = {
        (condition: Bool, error: Error, file: StaticString, line: UInt) in
        Swift.precondition(condition,
                           error.localizedDescription,
                           file: file, 
                           line: line)
    }
    
    private static let defaultPreconditionFailureClosure = {
        (error: Error, file: StaticString, line: UInt) in
        Swift.preconditionFailure(error.localizedDescription,
                                  file: file, 
                                  line: line)
    }
    
    /// Replaces the internal implementation of
    /// `precondition(_:error:file:line:)` with the given closure. Returns a
    /// `RestorationHandler` to execute that restores the original implentation.
    /// - Parameter closure: The closure to execute when
    ///                      `precondition(_:error:file:line:)` is called.
    static public func replacePrecondition(
        with closure: @escaping PreconditionClosure
    ) -> RestorationHandler {
        _preconditionClosure = closure
        return restorePrecondition
    }
    
    static private func restorePrecondition() {
        _preconditionClosure = nil
    }
    
    /// Replaces the internal implementation of
    /// `preconditionFailure(error:file:line:)` with the given closure. Returns
    /// a `RestorationHandler` to execute that restores the original
    /// implentation.
    /// - Parameter closure: The closure to execute when
    ///                      `preconditionFailure(error:file:line:)` is called.
    static public func replacePreconditionFailure(
        with closure: @escaping PreconditionFailureClosure
    ) -> RestorationHandler {
        _preconditionFailureClosure = closure
        return restorePreconditionFailure
    }
    
    static private func restorePreconditionFailure() {
        _preconditionFailureClosure = nil
    }
    
}
