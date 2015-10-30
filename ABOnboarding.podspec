#
# Be sure to run `pod lib lint ABOnboarding.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ABOnboarding"
  s.version          = "0.1.0"
  s.summary          = "App on-boarding made easy for the iPhone"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                       DESC

  s.homepage         = "https://github.com/ale0xB/ABOnboarding"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Alex Benito" => "alex@avrora.io" }
  s.source           = { :git => "https://github.com/ale0xB/ABOnboarding.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/ale0xB'

  s.platform     = :ios, '8.2'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*', 'Pod/Categories/**/*'
  s.resource_bundles = {
    'ABOnboarding' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h', 'Pod/Categories/**/*'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
end
