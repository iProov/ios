Pod::Spec.new do |s|
  s.name             = 'iProov'
  s.version          = '11.0.0-beta'
  s.summary          = 'Biometric Face Verification for Remote Identity Assurance'
  s.homepage         = 'https://www.iproov.com/'
  s.license          = { :type => 'commercial', :file => 'LICENSE.md' }
  s.author           = { 'iProov' => 'support@iproov.com' }
  s.source           = { :git => 'https://github.com/iProov/ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.5'

  s.ios.vendored_frameworks = 'iProov.xcframework'

  s.dependency 'Starscream', '~> 4.0'
  
end
