# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Buzzy' do
 
 use_frameworks!
 pod 'UCZProgressView'
 
pod 'GBInfiniteScrollView', '~> 1.8'

pod 'Parse', '~>1.15.3'
pod 'pop', '~> 1.0'
pod 'DateTools'
pod 'FormatterKit'
pod 'TTTAttributedLabel'
pod 'MCUIColorUtils', '~> 1.0.0'
pod 'SIAlertView'
pod 'SHSPhoneComponent'
pod 'FCOverlay', '~>1.0.1'
pod 'SAMSoundEffect'
pod 'NSDate+Helper'
pod 'HCSStarRatingView', '~> 1.4.2'
#pod 'JSQSystemSoundPlayer', '~> 2.0'
#pod 'JSQMessagesViewController'

pod 'ParseUI'
pod 'FBSDKCoreKit'
pod 'FBSDKLoginKit'
pod 'FBSDKShareKit'

pod 'GoogleMaps'


pod 'HTCopyableLabel'


pod 'MMPopupView', '~> 1.7.2'



pod 'SHSPhoneComponent'
pod 'libPhoneNumber-iOS', '~> 0.8'

pod 'Intercom'

pod 'SloppySwiper'


#pod 'ParseLiveQuery'

pod 'LLSimpleCamera'

pod 'AKPickerView'

pod 'PBJVideoPlayer'

pod 'ZFDragableModalTransition'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end


end
