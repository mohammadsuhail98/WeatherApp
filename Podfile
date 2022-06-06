# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'WeatherApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WeatherApp
  
  pod 'Alamofire', '4.9.1'  

  target 'WeatherAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'WeatherAppUITests' do
    # Pods for testing
  end

end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
        config.build_settings['ENABLE_BITCODE'] = 'YES'
      end
    end
end
