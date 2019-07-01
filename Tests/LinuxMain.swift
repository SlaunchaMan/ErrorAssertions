import XCTest

import ErrorAssertions

var tests = [XCTestCaseEntry]()
tests += AssertTests.allTests()
tests += FatalErrorTests.allTests()
tests += PreconditionTests.allTests()
XCTMain(tests)
