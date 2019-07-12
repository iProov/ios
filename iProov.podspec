Pod::Spec.new do |s|
  s.name             = 'iProov'
  s.version          = '7.0.0'
  s.summary          = 'It\'s never been so simple to authenticate securely'
  s.homepage         = 'https://www.iproov.com/'
  s.license          = { :type => 'MIT', :file => 'licenses/3rdparty.md' }
  s.author           = { 'iProov' => 'support@iproov.com' }
  s.source           = { :git => 'https://github.com/iProov/ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'

  s.ios.vendored_frameworks = 'iProov.framework'
  
  s.pod_target_xcconfig = {
    'OTHER_SWIFT_FLAGS' => '-DGLES' # Required for GPUImage2
  }
  
  s.dependency 'KeychainAccess', '~> 3.2.0'
  s.dependency 'Socket.IO-Client-Swift', '~> 15.1.0'
  s.dependency 'SwiftyJSON', '~> 4.0.0'
  
end
