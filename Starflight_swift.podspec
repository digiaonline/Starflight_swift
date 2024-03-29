#
# Be sure to run `pod lib lint Starflight_swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Starflight_swift'
  s.version          = '0.1.4'
  s.summary          = 'A Library to include Starflight into iOS swift applications'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
'A Library to include Starflight into iOS swift applications. This is developed in swift 4.2.'
DESC

  s.homepage         = 'https://github.com/StarcutFinland/Starflight_swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ankushkushwaha' => 'ankush.kushwaha@starcut.com' }
  s.source           = { :git => 'https://github.com/StarcutFinland/Starflight_swift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Starflight_swift/Classes/**/*'
  s.swift_version = '4.2'
  # s.resource_bundles = {
  #   'Starflight_swift' => ['Starflight_swift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
