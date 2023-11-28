platform :ios, '13.0'

target 'PodsTester' do
  use_frameworks!
  pod 'Alamofire'
  pod 'Kingfisher', '~> 7.0'
  pod 'SwiftyTesseract', '~> 3.1.3'
  pod 'TensorFlowLiteSwift', '~> 2.7.0'
  pod 'PureLiveSDK', :git => 'https://gitlab.com/purelive/purelive-ios-sdk.git' , :tag => '6.4.0.1'
  pod 'SwiftMessages'
  pod 'lottie-ios'

end


post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end 
