# ErrorAssertions

[![tests](https://github.com/SlaunchaMan/ErrorAssertions/workflows/tests/badge.svg)](https://github.com/SlaunchaMan/ErrorAssertions/actions?query=workflow%3Atests)
[![Documentation](https://SlaunchaMan.github.io/ErrorAssertions/badge.svg)](https://SlaunchaMan.github.io/ErrorAssertions)
[![Version](https://img.shields.io/cocoapods/v/ErrorAssertions.svg?style=flat)](https://cocoapods.org/pods/ErrorAssertions)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-orange.svg)](https://swift.org/package-manager)

Wrappers for Swift assertions that take `Error` instances instead of `String`s, 
and a suite of test functions to test these assertions.

## Getting Started

To use ErrorAssertions, simply import it at the top of your Swift source file:

```swift
import ErrorAssertions
```

Just by doing this, since the Swift compiler will prefer imported modules to the
main Swift module, you’ll get the ErrorAssertion versions of functions like
`fatalError(_:file:line:)`.

### Using `Error` Types

To use an `Error` instead of a `String` when calling an assertion method, use
the error version:

```swift
import ErrorAssertions

doSomething(completionHandler: { error in
    if let error = error {
        fatalError(error)
    }
})
```

You can use `Error` types with `fatalError()`, `assert()`, `assertionFailure()`,
`precondition()`, and `preconditionFailure()`.

## Testing Assertions

In your tests, import the `ErrorAssertionExpectations` module to test assertions
made in your app (as long as you’ve imported `ErrorAssertions`). In your test
cases, use the expectation methods:

```swift
func testThatAnErrorHappens() {
    expectFatalError {
        doAThingThatProducesAFatalError()
    }
}
```

There are also versions that take an `Error` or `String` and validate that the
produced error is the one you’re expecting:

```swift
func testThatASpecificErrorHappens() {
    expectFatalError(expectedError: URLError.badURL) {
        loadURL("thisisnotaurl")
    }
}
```

## Installation

### Swift Package Manager

Swift Package Manager is the preferred way to install ErrorAssertions. Add the
repository as a dependency:

```swift
dependencies: [
    .package(url: "https://github.com/SlaunchaMan/ErrorAssertions.git",
             from: "0.2.0")
]
```

In your targets, add `ErrorAssertions` as a dependency of your main target and,
if you’re using the test support, add `ErrorAssertionExpectations` to the test
target:

```swift
targets: [
    .target(name: "App", dependencies: ["ErrorAssertions")]
    .testTarget(name: "AppTests", dependencies: ["ErrorAssertionExpectations"])
]
```

### CocoaPods

To use ErrorAssertions with CocoaPods, use the main pod as a dependency in your
app and the ErrorAssertionExpectations pod in your tests:

```ruby
target 'App' do
    pod 'ErrorAssertions'
end

target 'AppTests' do
    pod 'ErrorAssertionExpectatoins'
end
```
