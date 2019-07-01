//
//  Unreachable.swift
//  ErrorAssertions
//
//  Created by Jeff Kelley on 7/1/19.
//

import Foundation

func unreachable() -> Never {
    repeat {
        RunLoop.current.run()
    } while (true)
}
