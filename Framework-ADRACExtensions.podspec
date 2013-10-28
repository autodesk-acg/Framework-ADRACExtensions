#
# Be sure to run `pod spec lint Framework-ADRACExtensions.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|

  s.name                = "Framework-ADRACExtensions"
  s.version             = "0.0.1"
  s.summary             = "ReactiveCocoa extensions for Apple iOS frameworks."
  s.description         = <<-DESC
                           Framework-ADRACExtensions is an iOS 6.0+ static library with several ReactiveCocoa extensions
                           for the standard iOS frameworks. 
                          DESC
  s.homepage            = "https://github.com/autodesk-acg/Framework-ADRACExtensions"
  s.license             = 'MIT License'
  s.author              = { "Kent Wong" => "kent.wong@autodesk.com" }
  s.source              = { :git => "https://github.com/autodesk-acg/Framework-ADRACExtensions.git" }
  s.platform            = :ios, '6.0'
        
  s.source_files        = 'Source/ADRACExtensions/*.{h,m}'
  s.ios.frameworks      = 'AssetsLibrary', 'Foundation', 'CoreData'
  s.requires_arc        = true

  s.dependency 'ReactiveCocoa', '~> 2.1.4'
end
