#
# Be sure to run `pod lib lint LogConsole.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LogConsole'
  s.version          = '0.1.0'
  s.summary          = 'A handy debugging log console tool.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A handy log console tool that can output information to the console, file, and display a small console tool in App.
                       DESC

  s.homepage         = 'https://github.com/Joe0708/LogConsole'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Joe' => 'joesir7@foxmail.com' }
  s.source           = { :git => 'https://github.com/Joe0708/LogConsole.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files     = 'LogConsole/Classes/**/*'

  s.resources        = 'LogConsole/Assets/*.png'

  s.resource_bundles = {
    'LogConsole' => ['LogConsole/Assets/*.png']
  }

end