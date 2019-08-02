//
//  AnonymousError.swift
//  ErrorAssertions
//
//  Created by Jeff Kelley on 7/1/19.
//

import Foundation

public enum AnonymousError: Error {
    
    case blank
    case withMessage(String)
    
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
