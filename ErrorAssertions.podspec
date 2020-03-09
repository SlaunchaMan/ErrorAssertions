Pod::Spec.new do |spec|
  spec.name         = "ErrorAssertions"
  spec.version      = "0.2.0"
  spec.summary      = "A Swift utility to test error code."

  spec.description  = <<-DESC
ErrorAssertions lets you write unit tests that cover cases you can’t cover with
XCTest alone, such as using the Assert, Precondition, and FatalError APIs in
Swift. By wrapping these calls, we can create test expectations and accurately
test our error states.
                   DESC

  spec.homepage     = "https://github.com/SlaunchaMan/ErrorAssertions"
  spec.license      = "MIT"
  spec.author             = { "Jeff Kelley" => "SlaunchaMan@gmail.com" }
  spec.social_media_url   = "https://twitter.com/SlaunchaMan"
  spec.ios.deployment_target = "8.0"
  spec.macos.deployment_target = "10.10"
  spec.watchos.deployment_target = "2.0"
  spec.tvos.deployment_target = "9.0"
  spec.swift_versions = ['5.0', '5.1']

  spec.source       = { :git => "https://github.com/SlaunchaMan/ErrorAssertions.git",
                        :tag => "#{spec.version}" }

  spec.subspec 'Core' do |ss|
    ss.source_files = 'Sources/ErrorAssertions/**/*.swift'
    ss.frameworks = 'Foundation'
  end

  spec.subspec 'ErrorAssertionExpectations' do |ss|
    ss.ios.deployment_target = "8.0"
    ss.macos.deployment_target = "10.10"
    ss.tvos.deployment_target = "9.0"

    ss.dependency 'ErrorAssertions/Core'
    ss.source_files = 'Sources/ErrorAssertionExpectations/**/*.swift'
    ss.frameworks = 'Foundation', 'XCTest'
  end

  spec.default_subspec = 'Core'
  
#  spec.test_spec 'ErrorAssertionsTests' do |ts|
#    ts.ios.deployment_target = "8.0"
#    ts.macos.deployment_target = "10.10"
#    ts.tvos.deployment_target = "9.0"
#
#    ts.dependency 'ErrorAssertions/ErrorAssertionExpectations'
#    ts.source_files = 'Tests/ErrorAssertionsTests/**/*.swift'
#    ts.frameworks = 'Foundation', 'XCTest'
#  end
end
