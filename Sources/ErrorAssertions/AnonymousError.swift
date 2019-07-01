//
//  AnonymousError.swift
//  ErrorAssertions
//
//  Created by Jeff Kelley on 7/1/19.
//

import Foundation

enum AnonymousError: Error, Equatable, LocalizedError {
    case blank
    case withMessage(String)
    
    init(string: String) {
        self = string.isEmpty ? .blank : .withMessage(string)
    }
    
    var errorDescription: String? {
        switch self {
        case .blank: return nil
        case .withMessage(let message): return message
        }
    }
}
