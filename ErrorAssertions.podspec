Pod::Spec.new do |spec|
  spec.name         = "ErrorAssertions"
  spec.version      = "0.3.0"
  spec.summary      = "Versions of Swift assertion functions using  Error types"

  spec.description  = <<-DESC
This package provides versions of Swift assertion methods—fatalError(),
assert(), assertionFailure(), precondition(), and preconditionFailure()—that use
Swift’s Error type instead of a simple String.
                   DESC

  spec.homepage     = "https://github.com/SlaunchaMan/ErrorAssertions"
  spec.license      = "MIT"
  spec.author             = { "Jeff Kelley" => "SlaunchaMan@gmail.com" }
  spec.social_media_url   = "https://twitter.com/SlaunchaMan"
  spec.ios.deployment_target = "8.0"
  spec.macos.deployment_target = "10.10"
  spec.watchos.deployment_target = "2.0"
  spec.tvos.deployment_target = "9.0"
  spec.swift_versions = ['4', '4.2', '5']

  spec.source       = { :git => "https://github.com/SlaunchaMan/ErrorAssertions.git",
                        :tag => "#{spec.version}" }

  spec.source_files = 'Sources/ErrorAssertions/**/*.swift'
  spec.frameworks = 'Foundation'

  spec.test_spec 'ErrorAssertionsTests' do |ts|
    ts.ios.deployment_target = "8.0"
    ts.macos.deployment_target = "10.10"
    ts.tvos.deployment_target = "9.0"

    ts.dependency 'ErrorAssertionExpectations'
    ts.source_files = 'Tests/ErrorAssertionsTests/**/*.swift'
    ts.frameworks = 'Foundation', 'XCTest'
  end
end
