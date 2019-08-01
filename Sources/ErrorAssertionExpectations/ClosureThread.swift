//
//  ClosureThread.swift
//  ErrorAssertionExpectations
//
//  Created by Jeff Kelley on 8/1/19.
//

import Foundation

class ClosureThread: Thread {
    
    let closure: () -> Void
    
    init(_ closure: @escaping () -> Void) {
        self.closure = closure
        super.init()
    }
    
    override func main() {
        closure()
    }
    
}
