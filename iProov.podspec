Pod::Spec.new do |s|
  s.name             = 'iProov'
  s.version          = '7.2.1'
  s.summary          = 'Right person. Real person. Right now.'
  s.homepage         = 'https://www.iproov.com/'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'iProov' => 'support@iproov.com' }
  s.source           = { :git => 'https://github.com/iProov/ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.1'

  s.ios.vendored_frameworks = 'iProov.framework'
  
  s.pod_target_xcconfig = {
    'OTHER_SWIFT_FLAGS' => '-DGLES' # Required for GPUImage2
  }
  
  s.dependency 'KeychainAccess', '~> 4.1.0'
  s.dependency 'Socket.IO-Client-Swift', '~> 15.2.0'
  s.dependency 'SwiftyJSON', '~> 4.0.0'

  
end
