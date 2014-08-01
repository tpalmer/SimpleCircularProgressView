Pod::Spec.new do |s|
  s.name         = "CircularProgressView"
  s.version      = "0.0.1"
  s.summary      = "Circular Progress View"
  s.description  = "An animated circular progress view."
  s.homepage     = "https://github.com/tpalmer/CircularProgressView"
  s.license      = 'MIT'
  s.author       = { "Travis Palmer" => "palmer.travis@gmail.com" }
  s.source       = { :git => "https://github.com/tpalmer/CircularProgressView.git", :tag => "0.0.1" }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.ios.source_files = 'Classes/ios'
end
