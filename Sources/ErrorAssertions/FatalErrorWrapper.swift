//
//  FatalErrorWrapper.swift
//  ErrorAssertions
//
//  Created by Jeff Kelley on 7/1/19.
//

import Foundation

/// Unconditionally reports a given error and stops execution.
/// - Parameters:
///   - error: The error to report.
///   - file: The file name to print with the description of `error`. The
///           default is the file where `fatalError(_:file:line:)` is called.
///   - line: The line number to print with the description of `error`. The
///           default is the line number where `fatalError(_:file:line:)` is
///           called.
@inlinable
public func fatalError(_ error: Error,
                       file: StaticString = #file,
                       line: UInt = #line) -> Never {
    FatalErrorUtilities.fatalErrorClosure(error, file, line)
}

/// Unconditionally prints a given message and stops execution.
/// - Parameters:
///   - message: The string to print. The default is an empty string.
///   - file: The file name to print with `message`. The default is the file
///           where `fatalError(_:file:line:)` is called.
///   - line: The line number to print along with `message`. The default is the
///           line number where `fatalError(_:file:line:)` is called.
@inlinable
public func fatalError(_ message: @autoclosure () -> String = String(),
                       file: StaticString = #file,
                       line: UInt = #line) -> Never {
    fatalError(AnonymousError(string: message()),
               file: file,
               line: line)
}

/// A utility type that replaces the internal implementation of `fatalError()`.
public enum FatalErrorUtilities {
    
    /// A closure that handles a fatal error.
    public typealias FatalErrorClosure = (Error, StaticString, UInt) -> Never
    
    internal static var _fatalErrorClosure: FatalErrorClosure?
        
    @usableFromInline internal static var fatalErrorClosure: FatalErrorClosure {
        return _fatalErrorClosure ?? defaultFatalErrorClosure
    }
    
    private static let defaultFatalErrorClosure = {
        (error: Error, file: StaticString, line: UInt) -> Never in
        Swift.fatalError(error.localizedDescription,
                         file: file,
                         line: line)
    }
    
    /// Replaces the internal implementation of `fatalError(_:file:line:)` with
    /// the given closure. Returns a `RestorationHandler` to execute that
    /// restores the original implentation.
    /// - Parameter closure: The closure to execute when
    ///                      `fatalError(_:file:line:)` is called.
    static public func replaceFatalError(
        with closure: @escaping FatalErrorClosure
    ) -> RestorationHandler {
        _fatalErrorClosure = closure
        return restoreFatalError
    }
    
    static private func restoreFatalError() {
        _fatalErrorClosure = nil
    }
    
}
