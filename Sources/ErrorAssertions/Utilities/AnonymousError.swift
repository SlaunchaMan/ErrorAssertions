//
//  AnonymousError.swift
//  ErrorAssertions
//
//  Created by Jeff Kelley on 7/1/19.
//

import Foundation

public enum AnonymousError: Error, Equatable, LocalizedError {
    case blank
    case withMessage(String)
    
    public init(string: String) {
        self = string.isEmpty ? .blank : .withMessage(string)
    }
    
    public var errorDescription: String? {
        switch self {
        case .blank: return nil
        case .withMessage(let message): return message
        }
    }
}
