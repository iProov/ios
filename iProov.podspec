Pod::Spec.new do |s|
  s.name             = 'iProov'
  s.version          = '8.2.0'
  s.summary          = 'Flexible authentication for identity assurance'
  s.homepage         = 'https://www.iproov.com/'
  s.license          = { :type => 'commercial', :file => 'LICENSE.md' }
  s.author           = { 'iProov' => 'support@iproov.com' }
  s.source           = { :git => 'https://github.com/iProov/ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.3'

  s.ios.vendored_frameworks = 'iProov.xcframework'
  
  s.pod_target_xcconfig = {
    'OTHER_SWIFT_FLAGS' => '-DGLES', # Required for GPUImage2
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }

  s.user_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }

  s.dependency 'Socket.IO-Client-Swift', '~> 15.2'

  
end
