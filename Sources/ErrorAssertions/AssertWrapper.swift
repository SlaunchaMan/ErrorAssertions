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

public struct AssertUtilities {
    
    public typealias AssertClosure = (Bool, Error, StaticString, UInt) -> ()
    
    fileprivate static var assertClosure = defaultAssertClosure
    
    private static let defaultAssertClosure = {
        (condition: Bool, error: Error, file: StaticString, line: UInt) in
        Swift.assert(condition, 
                     error.localizedDescription, 
                     file: file, 
                     line: line)
    }
    
    #if DEBUG
    static public func replaceAssert(closure: @escaping AssertClosure) {
        assertClosure = closure
    }
    
    static public func restoreAssert() {
        assertClosure = AssertUtilities.defaultAssertClosure
    }
    #endif
    
}
