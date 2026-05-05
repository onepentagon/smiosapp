# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'Smartility' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for Smartility
  pod 'SideMenu'
  pod 'MaterialComponents/Cards'
  pod 'Presentr'
  pod 'PhoneCountryCodePicker'
  pod 'LTHRadioButton'
  pod 'DropDown'
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  pod 'BrightFutures'
  pod 'PhoneNumberKit', '~> 3.3'
  pod 'Alamofire', '~> 5.2'
  pod "GSImageViewerController"
  pod 'Kingfisher'
  pod "KRActivityIndicatorView"
  pod "KRProgressHUD"
  pod 'ReachabilitySwift'
  pod "SwiftSpinner"
  pod 'Toast-Swift', '~> 5.0.1'
  pod 'SkeletonView'
  pod 'lottie-ios'

end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
               target.build_configurations.each do |config|
                   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
   config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
                 end
             end
         end
     end
