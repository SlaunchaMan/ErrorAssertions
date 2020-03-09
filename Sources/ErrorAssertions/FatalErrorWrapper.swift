//
//  FatalErrorWrapper.swift
//  ErrorAssertions
//
//  Created by Jeff Kelley on 7/1/19.
//

import Foundation

@inlinable
public func fatalError(_ error: Error,
                       file: StaticString = #file,
                       line: UInt = #line) -> Never {
    FatalErrorUtilities.fatalErrorClosure(error, file, line)
}

@inlinable
public func fatalError(_ message: @autoclosure () -> String = String(),
                       file: StaticString = #file,
                       line: UInt = #line) -> Never {
    fatalError(AnonymousError(string: message()),
               file: file,
               line: line)
}

public enum FatalErrorUtilities {
    
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
