
Pod::Spec.new do |s|

  s.name         = "MLSSlider"
  s.version      = "0.0.1"
  s.summary      = "slider"
  s.description  = "a litter slider"
  s.homepage     = "https://github.com/Minlison/MLSSlider"
  s.license      = "MIT"
  s.author             = { "MinLison" => "yuanhang.1991@icloud.com" }
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/Minlison/MLSSlider.git", :tag => "#{s.version}" }
  s.source_files  = "MLSSlider/MLSSlider.*"
  s.public_header_files = "MLSSlider/MLSSlider.h"

end
