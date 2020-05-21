#
# Be sure to run `pod lib lint GreetSolutions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'GreetSolutions'
    s.version          = '1.1.4'
    s.summary          = 'Library to recongnize people'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = <<-DESC
    TODO: Install the library of Greet Solutions to get information about customers that enter your buildings. Using our code an our hardware, you can access information to your visitors.
    DESC
    
    s.homepage         = 'https://github.com/Xyberfocus/GreetSolutionsSDKiOS.git'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'greetSolutions' => 'xyberfocus@gmail.com' }
    s.source           = { :git => 'https://github.com/Xyberfocus/GreetSolutionsSDKiOS.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.ios.deployment_target = '11.0'
    s.swift_version = '4.0'
    
    s.source_files = 'GreetSolutions/Classes/**/*'
    
    # s.resource_bundles = {
    #   'GreetSolutions' => ['GreetSolutions/Assets/*.png']
    # }
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
    s.frameworks = 'UIKit','NetworkExtension','CoreLocation'
    s.dependency 'EstimoteProximitySDK'
    s.dependency 'PromiseKit', '~> 6.0'
   
end
