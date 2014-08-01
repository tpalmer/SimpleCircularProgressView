Pod::Spec.new do |s|
  s.name         = "SimpleCircularProgressView"
  s.version      = "0.0.1"
  s.summary      = "An Easy to use Circular Progress View"
  s.description  = "An animated circular progress view."
  s.homepage     = "https://github.com/tpalmer/SimpleCircularProgressView"
  s.license      = 'MIT'
  s.author       = { "Travis Palmer" => "palmer.travis@gmail.com" }
  s.source       = { :git => "https://github.com/tpalmer/SimpleCircularProgressView.git", :tag => "0.0.1" }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.ios.source_files = 'Classes/ios'
end
