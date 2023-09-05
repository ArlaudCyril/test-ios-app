# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Lyber' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Lyber
	pod 'Algorithm'
  pod 'IQKeyboardManagerSwift'
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'SwiftEntryKit'
	pod 'StripeApplePay'
	
#  pod 'OTPFieldView'
  pod 'ADCountryPicker'
  pod 'CountryPickerView'
  pod 'FlagPhoneNumber'
  pod 'MultiProgressView'
  pod 'Charts'
  pod 'DropDown'
  pod 'SDWebImage'
	pod 'SDWebImageSVGKitPlugin'
  pod 'SVGKit'
  pod "ESPullToRefresh"
  pod "ExpandableLabel"
  pod 'Branch'
  pod 'lottie-ios'
  pod 'NVActivityIndicatorView'
  pod 'SwiftyGif'
  pod 'SwiftySRP'
  pod 'JWTDecode'
  pod 'Socket.IO-Client-Swift'
  pod 'Starscream'
	post_install do |installer|
		installer.generated_projects.each do |project|
			project.targets.each do |target|
				target.build_configurations.each do |config|
					config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
				end
			end
		end
	end

end
