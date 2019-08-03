//
//  PreconditionWrapper.swift
//  ErrorAssertions
//
//  Created by Jeff Kelley on 7/1/19.
//

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
                                line: UInt = #line) {
    PreconditionUtilities.preconditionFailureClosure(error, file, line)
}

@inlinable
public func preconditionFailure(_ message: @autoclosure () -> String = String(),
                                file: StaticString = #file,
                                line: UInt = #line) {
    preconditionFailure(error: AnonymousError(string: message()),
                        file: file,
                        line: line)
}

public struct PreconditionUtilities {
    
    public typealias PreconditionClosure =
        (Bool, Error, StaticString, UInt) -> ()
    
    public typealias PreconditionFailureClosure = 
        (Error, StaticString, UInt) -> Never
    
    @usableFromInline
    internal static var preconditionClosure = defaultPreconditionClosure
    
    @usableFromInline
    internal static var preconditionFailureClosure =
    defaultPreconditionFailureClosure
    
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
    
    #if DEBUG
    static public func replacePrecondition(
        closure: @escaping PreconditionClosure
    ) -> RestorationHandler {
        preconditionClosure = closure
        return restorePrecondition
    }
    
    static private func restorePrecondition() {
        preconditionClosure = defaultPreconditionClosure
    }
    
    static public func replacePreconditionFailure(
        closure: @escaping PreconditionFailureClosure
    ) -> RestorationHandler {
        preconditionFailureClosure = closure
        return restorePreconditionFailure
    }
    
    static private func restorePreconditionFailure() {
        preconditionFailureClosure = PreconditionUtilities
            .defaultPreconditionFailureClosure
    }
    #endif
    
}
