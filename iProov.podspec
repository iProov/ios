Pod::Spec.new do |s|
  s.name             = 'iProov'
  s.version          = '10.0.0-beta'
  s.summary          = 'Flexible authentication for identity assurance'
  s.homepage         = 'https://www.iproov.com/'
  s.license          = { :type => 'commercial', :file => 'LICENSE.md' }
  s.author           = { 'iProov' => 'support@iproov.com' }
  s.source           = { :git => 'https://github.com/iProov/ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.3'

  s.ios.vendored_frameworks = 'iProov.xcframework'

  s.dependency 'Starscream', '~> 4.0'
  s.dependency 'SwiftProtobuf', '~> 1.0'
  
end
