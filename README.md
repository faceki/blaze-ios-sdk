```markdown
# FACEKI-BLAZE-IOS SDK

## Overview

The FACEKI-BLAZE-IOS SDK is an iOS framework developed by Faceki, providing advanced eKYC (Electronic Know Your Customer) and Facial Recognition capabilities for iOS applications. This SDK enables seamless identity verification using document and selfie verification.

## Installation

### CocoaPods

To integrate FACEKI-BLAZE-IOS SDK into your Xcode project using CocoaPods, add the following lines to your `Podfile`:

```ruby
target 'YourProjectName' do
  pod 'FACEKI-BLAZE-IOS', '~> 3.0.0'
end
```

Then, run the following command:

```bash
$ pod install
```

### Manual Installation

You can also manually integrate the FACEKI-BLAZE-IOS SDK into your project. Download the SDK from [GitHub releases](https://github.com/faceki/blaze-ios-sdk/releases) and follow the instructions provided in the documentation.

#### Permission

Add the following usage descriptions to your Info.plist 

```
<key>NSCameraUsageDescription</key>
<string>For taking photos for kyc</string>

```


## Usage

### Callbacks

Implement the following callbacks to handle the SDK responses:


Callback that will recieve the response back from the API for data level information https://docs.faceki.com

```swift

func onComplete(data:[AnyHashable:Any]){
    print("API Response")
    print(type(of: data))

    if let dataObject = data["result"] as? [AnyHashable: Any]{
        print(dataObject["requestId"]!)
        print(dataObject["decision"]!)

    }
    
}

// Redirect After Result Screen

func onRedirectBack() {
    DispatchQueue.main.async {
        // Perform UI work here
        self.navigationController?.popToRootViewController(animated: true)
    }
}
```

### Initialization

```swift
import FACEKI_BLAZE_IOS

class YourViewController: UIViewController {

    @IBAction func captureAction(_ sender: Any) {
        let smManagerVC = Logger.initiateSMSDK(
            setClientID: "yourClientId",
            setClientSecret: "yourClientSecret",
            workflowId:"yourworkflowID",
            setOnComplete: onComplete,
            redirectBack: onRedirectBack,
            selfieImageUrl: nil,
            cardGuideUrl: nil
        )
        navigationController?.pushViewController(smManagerVC, animated: true)
    }

    // ... (rest of your ViewController code)

}
```



## Requirements

- Swift 5.0
- iOS 13.0 and later

## License

FACEKI-BLAZE-IOS SDK is released under the [MIT License](LICENSE)