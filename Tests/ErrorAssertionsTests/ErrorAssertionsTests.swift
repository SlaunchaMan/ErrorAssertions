import XCTest
@testable import ErrorAssertions

enum TestError: Error, Equatable {
    case testErrorA
    case testErrorB
}

final class ErrorAssertionsTests: XCTestCase {
    func testAssert() {
        expectAssertionFailure(expectedError: TestError.testErrorA) { 
            assert(false, error: TestError.testErrorA)
        }
        
        expectAssertionFailure(expectedError: TestError.testErrorB) { 
            assert(false, error: TestError.testErrorB)
        }
        
        expectAssertionFailure(expectedError: AnonymousError.blank) { 
            ErrorAssertions.assert(false)
        }
        
        expectAssertionFailure(
        expectedError: AnonymousError.withMessage("test")) { 
            ErrorAssertions.assert(false, "test")
        }
        
        expectAssertionFailure {
            ErrorAssertions.assert(false)
        }
        
        expectAssertionFailure(expectedMessage: "test") {
            ErrorAssertions.assert(false, "test")
        }
    }
    
    func testPrecondition() {
        expectPreconditionFailure(expectedError: TestError.testErrorA) { 
            precondition(false, error: TestError.testErrorA)
        }
        
        expectPreconditionFailure(expectedError: TestError.testErrorB) { 
            precondition(false, error: TestError.testErrorB)
        }
        
        expectPreconditionFailure(expectedError: AnonymousError.blank) { 
            ErrorAssertions.precondition(false)
        }
        
        expectPreconditionFailure(
        expectedError: AnonymousError.withMessage("test")) { 
            ErrorAssertions.precondition(false, "test")
        }
        
        expectPreconditionFailure {
            ErrorAssertions.precondition(false)
        }
        
        expectPreconditionFailure(expectedMessage: "test") { 
            ErrorAssertions.precondition(false, "test")
        }
    }
    
    func testFatalError() {
        expectFatalError(expectedError: TestError.testErrorA) { 
            fatalError(TestError.testErrorA)
        }
        
        expectFatalError(expectedError: TestError.testErrorB) { 
            fatalError(TestError.testErrorB)
        }
        
        expectFatalError(expectedError: AnonymousError.blank) { 
            ErrorAssertions.fatalError()
        }
        
        expectFatalError(expectedError: AnonymousError.withMessage("test")) { 
            ErrorAssertions.fatalError("test")
        }

        expectFatalError {
            ErrorAssertions.fatalError()
        }
        
        expectFatalError(expectedMessage: "test") {
            ErrorAssertions.fatalError("test")
        }
    }

    static var allTests = [
        ("testAssert", testAssert),
        ("testPrecondition", testPrecondition),
        ("testFatalError", testFatalError),
    ]
}
