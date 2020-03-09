//
//  PreconditionWrapper.swift
//  ErrorAssertions
//
//  Created by Jeff Kelley on 7/1/19.
//

import Foundation

@inlinable
public func precondition(_ condition: @autoclosure () -> Bool,
                         error: Error,
                         file: StaticString = #file,
                         line: UInt = #line) {
    PreconditionUtilities.preconditionClosure(condition(), error, file, line)
}

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

@inlinable
public func preconditionFailure(error: Error,
                                file: StaticString = #file,
                                line: UInt = #line) -> Never {
    PreconditionUtilities.preconditionFailureClosure(error, file, line)
}

@inlinable
public func preconditionFailure(_ message: @autoclosure () -> String = String(),
                                file: StaticString = #file,
                                line: UInt = #line) -> Never {
    preconditionFailure(error: AnonymousError(string: message()),
                        file: file,
                        line: line)
}

public enum PreconditionUtilities {
    
    public typealias PreconditionClosure =
        (Bool, Error, StaticString, UInt) -> ()
    
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
    
    static public func replacePrecondition(
        with closure: @escaping PreconditionClosure
    ) -> RestorationHandler {
        _preconditionClosure = closure
        return restorePrecondition
    }
    
    static private func restorePrecondition() {
        _preconditionClosure = nil
    }
    
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
