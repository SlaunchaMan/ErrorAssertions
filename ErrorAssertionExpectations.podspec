Pod::Spec.new do |spec|
  spec.name         = "ErrorAssertionExpectations"
  spec.version      = "0.4.0"
  spec.summary      = "Testble Swift assertion functions"

  spec.description  = <<-DESC
ErrorAssertionsExpectations lets you write unit tests that cover cases you can’t
cover with XCTest alone, such as using the Assert, Precondition, and FatalError
APIs in Swift. By wrapping these calls, we can create test expectations and
accurately test our error states.
                   DESC

  spec.homepage     = "https://github.com/SlaunchaMan/ErrorAssertions"
  spec.license      = "MIT"
  spec.author             = { "Jeff Kelley" => "SlaunchaMan@gmail.com" }
  spec.social_media_url   = "https://twitter.com/SlaunchaMan"
  spec.ios.deployment_target = "8.0"
  spec.macos.deployment_target = "10.10"
  spec.tvos.deployment_target = "9.0"
  spec.swift_versions = ['4', '4.2', '5']

  spec.source       = { :git => "https://github.com/SlaunchaMan/ErrorAssertions.git",
                        :tag => "#{spec.version}" }

  spec.dependency 'ErrorAssertions'
  spec.source_files = 'Sources/ErrorAssertionExpectations/**/*.swift'
  spec.frameworks = 'Foundation', 'XCTest'

end

