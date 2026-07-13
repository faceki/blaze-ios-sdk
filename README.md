# FACEKI-BLAZE-IOS

FACEKI-BLAZE-IOS is an iOS eKYC SDK for document capture and selfie verification.

This guide is written for fast, production-safe integration.

## Requirements

- iOS 15.0+
- Swift 5+
- A valid FACEKI verification link generated from your backend

## Install with CocoaPods

Add this to your Podfile:

```ruby
target 'YourAppTarget' do
  pod 'FACEKI-BLAZE-IOS', '~> 3.3'
end
```

Install pods:

```bash
pod install
```

Open the .xcworkspace file after installation.

## Add required permission

In Info.plist:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access for identity verification.</string>
```

## Import and launch the SDK

```swift
import UIKit
import FACEKI_BLAZE_IOS

final class YourViewController: UIViewController {

    @IBAction func startKYC(_ sender: UIButton) {
        let sdkVC = Logger.initiateSMSDK(
            verificationLink: "YOUR_VERIFICATION_LINK",
            setOnComplete: onComplete,
            redirectBack: onRedirectBack,
            selfieImageUrl: nil,
            cardGuideUrl: nil,
            termsAndConditionsUrl: "https://your-domain.com/terms",
            onCancel: onCancel,
            primaryButtonColor: UIColor(red: 0.96, green: 0.71, blue: 0.16, alpha: 1.0),
            textColor: .black,
            headingColor: .black,
            cameraPageTitleColor: UIColor(red: 0.96, green: 0.71, blue: 0.16, alpha: 1.0)
        )

        navigationController?.pushViewController(sdkVC, animated: true)
        // Alternative:
        // present(sdkVC, animated: true)
    }

    func onComplete(data: [AnyHashable: Any]) {
        print("FACEKI response: \(data)")

        if let result = data["result"] as? [AnyHashable: Any] {
            let requestId = result["requestId"]
            let decision = result["decision"]
            print("requestId: \(String(describing: requestId))")
            print("decision: \(String(describing: decision))")
        }
    }

    func onRedirectBack() {
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

    func onCancel() {
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
```

## API reference

Current initializer:

```swift
public static func initiateSMSDK(
    verificationLink: String,
    setOnComplete: Any,
    redirectBack: Any,
    selfieImageUrl: String?,
    cardGuideUrl: String?,
    termsAndConditionsUrl: String? = nil,
    onCancel: Any? = nil,
    primaryButtonColor: UIColor? = nil,
    textColor: UIColor? = nil,
    headingColor: UIColor? = nil,
    cameraPageTitleColor: UIColor? = nil
) -> UIViewController
```

Parameter details:

- verificationLink: Required FACEKI verification link from your backend.
- setOnComplete: Completion callback receiving SDK/API result payload.
- redirectBack: Called by SDK at flow completion exit.
- selfieImageUrl: Optional custom selfie guide image URL.
- cardGuideUrl: Optional custom document guide image URL.
- termsAndConditionsUrl: Optional URL shown on consent screen.
- onCancel: Optional callback called when user taps cancel.
- primaryButtonColor: Optional primary action button color.
- textColor: Optional general text color.
- headingColor: Optional heading text color.
- cameraPageTitleColor: Optional camera page title color.

## Callback behavior

- onComplete is used to return verification response data.
- onCancel is used for explicit user cancellation.
- redirectBack is used by SDK for final flow return.

Best practice: keep callback navigation on the main thread.

## UI and asset behavior

- If cardGuideUrl is empty or fails, SDK uses packaged fallback assets.
- If selfieImageUrl is empty or fails, SDK uses packaged fallback assets.
- Terms link is shown only when termsAndConditionsUrl is provided.


## Production Recommeded Guidelines

- Generate verificationLink on your backend per session.
- Do not hardcode sensitive values in app binaries.
- Validate callback payloads defensively.
- Handle all decisions from result payload, including non-accepted outcomes.
- Keep user messaging clear for camera permission and network failures.
- Test on real devices for camera quality and performance.
- Verify your custom colors against accessibility contrast.

## Troubleshooting

- Camera not opening:
  - Confirm NSCameraUsageDescription exists.
  - Confirm camera permission is granted.
- SDK does not proceed:
  - Check internet connectivity.
  - Ensure verificationLink is valid and not expired.
- Terms link not visible:
  - Ensure termsAndConditionsUrl is a non-empty valid URL string.
- Guide image not showing:
  - Verify remote URL is reachable.
  - If remote fails, fallback asset should display automatically.