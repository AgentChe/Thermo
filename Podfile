platform :ios, ‘12.0’
inhibit_all_warnings!
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

target 'Thermo' do
  pod 'NotificationBannerSwift'
  pod 'Kingfisher'
  
  pod 'RushSDK', :git => "https://github.com/AgentChe/RushSDK.git"
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
    end
  end
end
