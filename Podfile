# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'amrk' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for amrk

  pod 'Alamofire', '~> 5.0.0-rc.2'
  pod 'SwifterSwift', '5.0.0'
  pod 'IQKeyboardManagerSwift', '6.3.0'
  pod 'SVProgressHUD', '2.2.5'
  pod 'iOSDropDown', '0.3.4'
  pod 'DZNEmptyDataSet'
  pod 'SDWebImage', '~> 4.0'
  pod "TTGSnackbar", '1.10.5'
  pod 'FSPagerView', '0.8.2'
  pod 'BEMCheckBox', '1.4.1'
  pod 'MOLH', '1.4.3'
  pod 'Cosmos', '~> 23.0'
  pod 'SwiftLocation', '4.1.0'
  pod 'ActionSheetPicker-3.0'
  pod 'SwiftMessages'
  pod 'YPImagePicker', '4.2.0'
  pod 'GoogleMaps', '~> 3.9.0'
  pod 'GooglePlaces'
  pod 'FSCalendar', '2.8.2'
#  pod 'Firebase/Analytics'
#  pod 'Firebase/Messaging'
  pod 'MRCountryPicker', '~> 0.0.8'

end

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
        end
    end
end
