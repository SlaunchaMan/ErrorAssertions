//
//  ClosureThread.swift
//  ErrorAssertionExpectations
//
//  Created by Jeff Kelley on 8/1/19.
//

import Foundation

internal final class ClosureThread: Thread {
    
    private let closure: () -> Void
    
    internal init(_ closure: @escaping () -> Void) {
        self.closure = closure
        super.init()
    }
    
    internal override func main() {
        closure()
    }
    
}
