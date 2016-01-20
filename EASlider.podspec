Pod::Spec.new do |s|
  s.name         = "EASlider"
  s.version      = "0.1"
  s.summary      = "A slider control like font slider in iPhone\'s Settings.app"
  s.description  = <<-DESC
  A slider control like font slider in iPhone\'s Settings.app
                   DESC
  s.homepage     = "https://github.com/fdddf/EASlider.git"
  s.license      = "MIT"
  s.author       = { "Yongliang Wang" => "viporg@126.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/fdddf/EASlider.git", :tag => "#{s.version}" }
  s.source_files  = "EASlider/Classes/**/*.{h,m}"
  #s.exclude_files = "Classes/Exclude"
  # s.public_header_files = "Classes/**/*.h"
  s.requires_arc = true
end
