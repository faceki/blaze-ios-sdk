#
# Be sure to run `pod lib lint KYC-iOS-Native.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FACEKI-BLAZE-IOS'
  s.version          = '3.0.0'
  s.summary          = 'iOS SDK For FACEKI EKYC Blaze 3.0'
  s.description      = "FACEKI Blazw eKYC & Facial Recognition system, iOS SDK for verifying the user with their document and selfie"
  s.homepage         = 'https://github.com/faceki/blaze-ios-sdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'faceki' => 'tech@faceki.com' }
  s.source           = { :git => 'https://github.com/faceki/blaze-ios-sdk.git', :tag => s.version.to_s }
  s.swift_version = '5.0'
  s.ios.deployment_target = '13.0'
  s.source_files = 'KYC-iOS-Native/Classes/**/*'
  s.resources = 'KYC-iOS-Native/Assets/**'
  s.frameworks = 'UIKit', 'AVFoundation'
  s.dependency 'lottie-ios'
  
  
end
