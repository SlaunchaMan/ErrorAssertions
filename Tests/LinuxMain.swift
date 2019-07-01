import XCTest

import ErrorAssertions

var tests = [XCTestCaseEntry]()
tests += ErrorAssertionsTests.allTests()
XCTMain(tests)
