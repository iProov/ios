Pod::Spec.new do |s|
  s.name             = 'iProovAPIClient'
  s.version          = '1.2.0'
  s.summary          = 'iOS API Client for iProov REST API v2'
  s.homepage         = 'https://github.com/iProov/ios/tree/master/iProovAPIClient'
  s.license          = { :type => 'BSD-3', :file => 'LICENSE' }
  s.author           = { 'iProov' => 'support@iproov.com' }
  s.source           = { :podspec => 'https://raw.githubusercontent.com/iProov/ios/master/iProovAPIClient.podspec' }
  s.ios.deployment_target = '11.0'
  s.source_files = 'iProovAPIClient/iProovAPIClient/Classes/**/*'

  s.dependency 'Alamofire', '~> 5.0'
end
