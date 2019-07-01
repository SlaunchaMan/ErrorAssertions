import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AssertTests.allTests),
        testCase(FatalErrorTests.allTests),
        testCase(PreconditionTests.allTests),
    ]
}
#endif
