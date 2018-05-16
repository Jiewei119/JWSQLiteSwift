#
# Be sure to run `pod lib lint JWSQLiteSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JWSQLiteSwift'
  s.version          = '0.1.1'
  s.summary          = '一个使用Swift语言实现的轻量级SQLite数据库访问库封装，基于FMDB。'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
一个使用Swift语言实现的轻量级SQLite数据库访问库封装，基于FMDB。支持两种使用方式：1、通过使用词典\数组访问数据库；2、通过自定义实体访问数据库。
                       DESC

  s.homepage         = 'https://github.com/jiewei119/JWSQLiteSwift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jiewei119' => '810337170@qq.com' }
  s.source           = { :git => 'https://github.com/jiewei119/JWSQLiteSwift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'JWSQLiteSwift/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JWSQLiteSwift' => ['JWSQLiteSwift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'Foundation'
  # s.dependency 'AFNetworking', '~> 2.3'
s.frameworks = 'Foundation'
s.dependency 'FMDB', '~> 2.7.2'
end
