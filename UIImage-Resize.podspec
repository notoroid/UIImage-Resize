Pod::Spec.new do |s|
  s.name         = "UIImage+Resize"
  s.version      = "0.0.1"
  s.summary      = "UIImage + Resize is a middleware that provides a resize function for UIImage using CoreImage."

  s.description  = <<-DESC
                   
UIImage + Resize is a middleware that provides a resize function for UIImage using CoreImage. - UIImage+Resize はCoreImage を使ったUIImageのためにリサイズ機能を提供するミドルウェアです。
                   DESC

  s.homepage     = "https://github.com/notoroid/UIImage-Resize"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "notoroid" => "noto@irimasu.com" }
  s.social_media_url   = "http://twitter.com/notoroid"

  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/notoroid/UIImage-Resize", :tag => "v0.0.1" }

  s.source_files  = "Lib/**/*.{h,m}"
  s.public_header_files = "Lib/**/*.h"

  s.requires_arc = true
end
