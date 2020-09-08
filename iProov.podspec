Pod::Spec.new do |s|
  s.name             = 'iProov'
  s.version          = '7.6.0-beta3'
  s.summary          = 'Award-winning online biometric authentication'
  s.homepage         = 'https://www.iproov.com/'
  s.license          = { :type => 'commercial', :file => 'LICENSE.md' }
  s.author           = { 'iProov' => 'support@iproov.com' }
  s.source           = { :git => 'https://github.com/iProov/ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.2'

  s.ios.vendored_frameworks = 'iProov.xcframework'
  
  s.pod_target_xcconfig = {
    'OTHER_SWIFT_FLAGS' => '-DGLES' # Required for GPUImage2
  }
  
  s.dependency 'KeychainAccess', '~> 4.1'
  s.dependency 'Socket.IO-Client-Swift', '~> 15.2'
  s.dependency 'SwiftyJSON', '~> 5.0'

  
end
