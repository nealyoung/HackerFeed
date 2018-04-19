platform :ios, '10.0'

target 'HackerFeed' do
  pod 'DACircularProgress'
  pod 'FCUtilities', :git => 'https://github.com/marcoarment/FCUtilities.git'
  pod 'libHN', :git => 'https://github.com/nealyoung/libHN.git'
  pod 'MCSwipeTableViewCell', inhibit_warnings: true
  pod 'NYAlertViewController'
  pod 'NYSegmentedControl'
  pod 'PBWebViewController'
  pod 'SSPullToRefresh'
  pod 'SVProgressHUD'
  pod 'SVPullToRefresh', :git => 'https://github.com/samvermette/SVPullToRefresh.git'
  pod 'TTTAttributedLabel'
  pod 'ZFDragableModalTransition'
end

target 'HackerFeedTests' do

end

target 'Share Extension' do
  pod 'libHN', :git => 'https://github.com/nealyoung/libHN.git'
  pod 'MCSwipeTableViewCell', inhibit_warnings: true
  pod 'NYSegmentedControl'
  pod 'SVProgressHUD'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'SVProgressHUD'
            target.build_configurations.each do |config|
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << 'SV_APP_EXTENSIONS'
            end
        end
    end
end
