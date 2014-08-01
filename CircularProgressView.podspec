Pod::Spec.new do |s|
  s.name         = "CircularProgressView"
  s.version      = "1.0.0"
  s.summary      = "Circular Progress View"
  s.description  = "An animated circular progress view."
  s.homepage     = "https://github.com/tpalmer/CircularProgressView"
  s.license      = 'MIT'
  s.author       = { "Travis Palmer" => "palmer.travis@gmail.com" }
  s.source       = { :git => "https://github.com/tpalmer/CircularProgressView.git", :tag => "1.0.0" }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Classes'
end
