//
//  AssertWrapper.swift
//  ErrorAssertions
//
//  Created by Jeff Kelley on 7/1/19.
//

@inlinable
public func assert(_ condition: @autoclosure () -> Bool,
                   error: Error,
                   file: StaticString = #file,
                   line: UInt = #line) {
    AssertUtilities.assertClosure(condition(), error, file, line)
}

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

@inlinable
public func assertionFailure(error: Error,
                             file: StaticString = #file,
                             line: UInt = #line) {
    AssertUtilities.assertionFailureClosure(error, file, line)
}

@inlinable
public func assertionFailure(_ message: @autoclosure () -> String = String(),
                             file: StaticString = #file,
                             line: UInt = #line) {
    assertionFailure(error: AnonymousError(string: message()),
                     file: file,
                     line: line)
}

public struct AssertUtilities {
    
    public typealias AssertClosure = (Bool, Error, StaticString, UInt) -> ()
    
    public typealias AssertionFailureClosure =
        (Error, StaticString, UInt) -> ()
    
    @usableFromInline internal static var _assertClosure: AssertClosure?
    
    @usableFromInline internal static var assertClosure: AssertClosure {
        return _assertClosure ?? defaultAssertClosure
    }
    
    @usableFromInline
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
