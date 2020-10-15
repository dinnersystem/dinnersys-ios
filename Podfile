# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'DinnerSystem' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'SwiftGifOrigin', '~> 1.7.0'
  pod 'LicensePlist'
  pod 'Alamofire'
  pod 'Firebase/Core'
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging', :inhibit_warnings => true
  pod 'Firebase/Crashlytics'
  pod 'ReachabilitySwift'
  pod 'TrueTime'
  pod 'RSBarcodes_Swift', '~> 5.1.0'
  pod 'Protobuf', :inhibit_warnings => true
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
