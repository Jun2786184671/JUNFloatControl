#
# Be sure to run `pod lib lint JUNFloatControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JUNFloatControl'
  s.version          = '0.1.1'
  s.summary          = 'A float control that attaches to the edge of the window'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Jun Ma/JUNFloatControl'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jun Ma' => 'maxinchun5@gmail.com' }
  s.source           = { :git => 'https://github.com/Jun2786184671/JUNFloatControl.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'JUNFloatControl/Classes/**/*'
  
   s.resource_bundles = {
     'JUNFloatControl' => ['JUNFloatControl/Assets/Image/*.png']
   }

  s.public_header_files = 'JUNFloatControl/Classes/JUNFloatControl.h', 'JUNFloatControl/Classes/Config/JUNFloatControlConfig.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
