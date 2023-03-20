#
# Be sure to run `pod lib lint w3bstream.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'w3bstream'
  s.version          = '0.9.1'
  s.summary          = 'A short description of w3bstream.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.homepage         = 'https://github.com/machinefi/w3bstream-ios-sdk'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zanyfly' => 'zanyfly@126.com' }
  s.source           = { :git => 'https://github.com/machinefi/w3bstream-ios-sdk', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'w3bstream/Classes/**/*'
  
  # s.resource_bundles = {
  #   'w3bstream' => ['w3bstream/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Starscream', '~> 4.0.0'
  s.dependency 'SwiftKeychainWrapper'
  s.dependency 'BigInt.swift'
  s.dependency 'CryptoSwift'
end
