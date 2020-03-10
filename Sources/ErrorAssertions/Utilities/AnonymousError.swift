//
//  AnonymousError.swift
//  ErrorAssertions
//
//  Created by Jeff Kelley on 7/1/19.
//

import Foundation

/// An error without context that optionally wraps a `String`.
public enum AnonymousError: Error {
    
    /// An anonymous error with no message.
    case blank
    
    /// An anonymous error with a message.
    case withMessage(String)
    
    /// Creates an anonymous error
    /// - Parameter string: The string that the error wraps. If the string is
    ///                     empty, creates a `blank` error.
    public init(string: String) {
        self = string.isEmpty ? .blank : .withMessage(string)
    }
    
}

extension AnonymousError: Equatable {}

extension AnonymousError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .blank: return nil
        case .withMessage(let message): return message
        }
    }
    
}
