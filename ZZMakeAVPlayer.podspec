#
# Be sure to run `pod lib lint ZZMakeAVPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZZMakeAVPlayer'
  s.version          = '1.0.2'
  s.summary          = '一个简单的视频播放工具'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  一个简单的视频播放工具，可以横竖屏，可以调节进度，可以调节亮度，可以查看目录并选择，可以单次、顺序、循环播放，方便简单。
                       DESC

  s.homepage         = 'https://github.com/UserZhangXiaoZhe/ZZMakeAVPlayer'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'UserZhangXiaoZhe' => 'zaihuishou223@163.com' }
  s.source           = { :git => 'https://github.com/UserZhangXiaoZhe/ZZMakeAVPlayer.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'ZZMakeAVPlayer/Classes/**/*'
  s.resource = 'ZZMakeAVPlayer/ZZMakePlayerResources.bundle'
  # s.resource_bundles = {
  #   'ZZMakeAVPlayer' => ['ZZMakeAVPlayer/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
