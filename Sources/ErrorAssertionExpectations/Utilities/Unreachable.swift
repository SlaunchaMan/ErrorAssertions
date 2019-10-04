//
//  Unreachable.swift
//  ErrorAssertionExpectations
//
//  Created by Jeff Kelley on 7/1/19.
//

import Foundation

internal func unreachable() -> Never {
    repeat {
        RunLoop.current.run()
    } while (true)
}
