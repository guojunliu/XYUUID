Pod::Spec.new do |s|
  s.name             = 'XYUUID'
  s.version          = '1.0.0'
  s.summary          = 'XYUUID 1.0.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
XYUUID IDFA 1.0.0
                       DESC

  s.homepage         = 'https://github.com/guojunliu/XYUUID'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "steve" => "909476821@qq.com" }
  s.source           = { :git => 'https://github.com/guojunliu/XYUUID.git', :tag => s.version }

  s.ios.deployment_target = '9.0'

  s.source_files = 'XYUUID/XYUUID/*'
  
  valid_archs = ['armv7', 'armv7s', 'x86_64', 'arm64']
  s.xcconfig = {
    'VALID_ARCHS' =>  valid_archs.join(' '),
  }

end
