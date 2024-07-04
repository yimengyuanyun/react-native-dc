# react-native-dc.podspec

require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-dc"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-dc
                   DESC
  s.homepage     = "https://github.com/github_account/react-native-dc"
  # brief license entry:
  s.license      = "MIT"
  # optional - use expanded license entry instead:
  # s.license    = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "Your Name" => "yourname@email.com" }
  s.platforms    = { :ios => "12.4" }
  s.source       = { :git => "https://github.com/github_account/react-native-dc.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,c,cc,cpp,m,mm,swift}"
  s.requires_arc = true

  s.dependency "React"
  # s.dependency 'Protobuf', '3.3.0'
  # ...
  # s.dependency "..."

  # 内置frameworks路径
  s.vendored_frameworks = 'Dcapi.xcframework'
  # s.preserve_path = '${PODS_ROOT}/..'

  # 设置framework的查找路径
  s.pod_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => "$(PODS_ROOT)/**",
    'OBJC_ARC' => 'NO'
  }
end

