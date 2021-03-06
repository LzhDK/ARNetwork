#
# Be sure to run `pod lib lint ARNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ARNetwork'
  s.version          = '0.1.0'
  s.summary          = 'A network framework in combination with HTTP and data cache. (AFNetworking+Realm)'
  s.description      = <<-DESC
                        A network framework in combination with HTTP and data cache. (AFNetworking+Realm)
                       DESC
  s.homepage         = 'https://github.com/dklinzh/ARNetwork'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniel' => 'linzhdk@gmail.com' }
  s.source           = { :git => 'https://github.com/dklinzh/ARNetwork.git', :tag => s.version.to_s }
  s.ios.deployment_target = '7.0'
  s.source_files = 'ARNetwork/Classes/**/*.{h,m}'
  s.dependency 'AFNetworking', '~> 3.1'
  s.dependency 'Realm', '~> 2.1'
  s.prefix_header_file = 'ARNetwork/Classes/ARNetwork-Prefix.pch'
end
