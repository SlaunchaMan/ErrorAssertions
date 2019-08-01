//
//  FatalErrorWrapper.swift
//  ErrorAssertions
//
//  Created by Jeff Kelley on 7/1/19.
//

#if DEBUG
public func fatalError(_ error: Error,
                       file: StaticString = #file,
                       line: UInt = #line) -> Never {
    FatalErrorUtilities.fatalErrorClosure(error, file, line)
}

public func fatalError(_ message: @autoclosure () -> String = String(),
                       file: StaticString = #file,
                       line: UInt = #line) -> Never {
    fatalError(AnonymousError(string: message()),
               file: file,
               line: line)
}

public struct FatalErrorUtilities {
    
    public typealias FatalErrorClosure = (Error, StaticString, UInt) -> Never
    
    fileprivate static var fatalErrorClosure = defaultFatalErrorClosure
    
    private static let defaultFatalErrorClosure = {
        (error: Error, file: StaticString, line: UInt) -> Never in
        Swift.fatalError(error.localizedDescription,
                         file: file,
                         line: line)
    }
    
    static public func replaceFatalError(
        closure: @escaping FatalErrorClosure
        ) {
        fatalErrorClosure = closure
    }
    
    static public func restoreFatalError() {
        fatalErrorClosure = defaultFatalErrorClosure
    }
    
}
#endif
