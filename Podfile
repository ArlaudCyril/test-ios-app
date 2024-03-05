# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def sharedpods
    pod 'Algorithm'
    pod 'IQKeyboardManagerSwift'
    pod 'Alamofire'
    pod 'SwiftyJSON'
    pod 'SwiftEntryKit'
    pod 'StripeApplePay'
    pod 'GooglePlaces'
    pod 'AppsFlyerFramework'
    pod 'ADCountryPicker'
    pod 'CountryPickerView'
    pod 'FlagPhoneNumber'
    pod 'MultiProgressView'
    pod 'Charts'
    pod 'DropDown'
    pod 'SDWebImage'
    pod 'SDWebImageSVGKitPlugin'
    pod 'SVGKit'
    pod 'ESPullToRefresh'
    pod 'ExpandableLabel'
    pod 'Branch'
    pod 'lottie-ios'
    pod 'NVActivityIndicatorView'
    pod 'SwiftyGif'
    pod 'SwiftySRP'
    pod 'JWTDecode'
    pod 'Socket.IO-Client-Swift'
    pod 'Starscream'
end


target 'Lyber dev' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  sharedpods

end


target 'Lyber prod' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  sharedpods

end

# For expandableLabel library. Keep the minimum version to 13
post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end
