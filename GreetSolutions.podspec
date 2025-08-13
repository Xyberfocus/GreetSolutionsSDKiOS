
#
# Be sure to run `pod lib lint GreetSolutions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GreetSolutions'
  s.version          = '1.2.3'
  s.summary          = 'Library to recongnize people'

  s.platform = :ios, '12.0'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.description      = <<-DESC
  TODO: Install the library of Greet Solutions to get information about customers that enter your buildings. Using our code an our hardware, you can access information to your visitors.
  DESC
  
  s.homepage = 'https://github.com/Xyberfocus/GreetSolutionsSDKiOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'greetSolutions' => 'xyberfocus@gmail.com' }
  s.source = { :git => 'https://github.com/Xyberfocus/GreetSolutionsSDKiOS.git', :tag => s.version }
  s.ios.deployment_target = '12.0'
  s.swift_version = '5.3'
  
  s.source_files = 'GreetSolutions/Classes/**/*'
  
  s.static_framework = true
  # s.resource_bundles = {
  #   'GreetSolutions' => ['GreetSolutions/Assets/*.png']
  # }
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.source_files = 'GreetSolutions/Classes/**/*'
  s.exclude_files = 'GreetSolutions/Classes/NotificationGreetSolutions.swift', 'GreetSolutions/Classes/NotificationGreetSolution.swift', 'GreetSolutions/Classes/BluetoothRecognition.swift'

  s.frameworks = 'UIKit','NetworkExtension','CoreLocation','UserNotifications'
  # s.dependency 'EstimoteProximitySDK'
  # s.dependency 'OneSignal', '>= 3.0', '< 4.0'
  s.dependency 'PromiseKit', '~> 8.0'
 
  s.pod_target_xcconfig = {
    'IPHONEOS_DEPLOYMENT_TARGET' => '12.0',
    'SWIFT_VERSION' => '5.3',
    'ARCHS[sdk=iphonesimulator*]' => 'x86_64',
    'ARCHS[sdk=iphoneos*]' => 'arm64',
    'VALID_ARCHS' => 'arm64 x86_64',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'EXCLUDED_ARCHS[sdk=iphoneos*]' => 'armv7',
    'OTHER_SWIFT_FLAGS' => '-suppress-warnings'
  }
  
  s.user_target_xcconfig = {
    'IPHONEOS_DEPLOYMENT_TARGET' => '12.0'
  }
  
end
