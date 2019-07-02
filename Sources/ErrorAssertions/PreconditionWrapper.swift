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

public struct PreconditionUtilities {
    
    public typealias PreconditionClosure = (Bool, Error, StaticString, UInt) -> ()
    
    fileprivate static var preconditionClosure = defaultPreconditionClosure
    
    private static let defaultPreconditionClosure = {
        (condition: Bool, error: Error, file: StaticString, line: UInt) in
        Swift.precondition(condition,
                           error.localizedDescription,
                           file: file, 
                           line: line)
    }
    
    #if DEBUG
    static public func replacePrecondition(
        closure: @escaping PreconditionClosure
        ) {
        preconditionClosure = closure
    }
    
    static public func restorePrecondition() {
        preconditionClosure = defaultPreconditionClosure
    }
    #endif
    
}
