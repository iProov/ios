Pod::Spec.new do |s|
  s.name             = 'iProov'
  s.version          = '6.2.1'
  s.summary          = 'It\'s never been so simple to authenticate securely'
  s.homepage         = 'https://www.iproov.com/'
  s.license          = { :type => 'MIT', :file => 'licenses/3rdparty.md' }
  s.author           = { 'Jonathan Ellis' => 'jonathan.ellis@iproov.com' }
  s.source           = { :git => 'https://github.com/iProov/ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.swift_version = '4.1.2'
  s.source_files = 'iProov/Classes/**/*'
  s.resources = ['iProov/Assets/**/*']

  s.ios.vendored_frameworks = 'iProov.framework'
  s.dependency 'KeychainAccess', '~> 3.1.0'
  s.dependency 'GPUImage', '~> 0.1'
  s.dependency 'MBProgressHUD', '~> 1.0'
  s.dependency 'Alamofire', '~> 4.3'
  s.dependency 'AlamofireImage', '~> 3.2'
  s.dependency 'Socket.IO-Client-Swift', '~> 9'
end
