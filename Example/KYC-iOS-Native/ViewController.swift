//
//  ViewController.swift
//  KYC-iOS-Native
//
//  Created by faceki on 01/04/2022.
//  Copyright (c) 2022 faceki. All rights reserved.
//

import UIKit
import FACEKI_BLAZE_IOS

class ViewController: UIViewController {

    private let verificationLink = "52dad9b8-1139-4e09-xxxx-b9c825d2f8cc"
    private let selfieGuideURL = "https://your-domain.com/assets/selfie-guide.gif"
    private let cardGuideURL = "https://your-domain.com/assets/card-guide.gif"
    private let termsURL = "https://your-domain.com/terms"
    private let primaryThemeColor = "#38B34A"
    private let textThemeColor = "#111111"
    @IBOutlet weak var poweredByLogoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        poweredByLogoImageView.image = sdkLogoImage()
        poweredByLogoImageView.contentMode = .scaleAspectFit
        poweredByLogoImageView.clipsToBounds = true
    }
    
    func onComplete(data: [AnyHashable: Any]) {
        print("SDK completed successfully")

        if let dataObject = data["result"] as? [AnyHashable: Any] {
            print("Request ID: \(dataObject["requestId"] ?? "missing")")
            print("Decision: \(dataObject["decision"] ?? "missing")")
        }
    }

    func onRedirectBack(data: [AnyHashable: Any]) {
        // Called when the SDK returns control to your app after a successful redirect.
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

    func onCancel() {
        print("SDK flow cancelled by the user")
        // Called when the customer exits the SDK using the cancel action.
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

    private func hexColor(_ hex: String) -> UIColor {
        var cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleaned = cleaned.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&rgb)

        return UIColor(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }

    private func sdkLogoImage() -> UIImage? {
        let frameworkBundle = Bundle(for: Logger.self)
        if let bundlePath = frameworkBundle.path(forResource: "Resources", ofType: "bundle"),
           let resourcesBundle = Bundle(path: bundlePath) {
            if let image = UIImage(named: "logo", in: resourcesBundle, compatibleWith: nil) {
                return image
            }
        }

        if let image = UIImage(named: "logo", in: frameworkBundle, compatibleWith: nil) {
            return image
        }

        if let url = frameworkBundle.url(forResource: "logo", withExtension: "png") {
            return UIImage(contentsOfFile: url.path)
        }

        return nil
    }

    @IBAction func captueACtion(_ sender: Any) {
        // Provide the optional guide assets if your backend has them.
        // If these are nil, the SDK falls back to its bundled defaults.
        let smManagerVC = Logger.initiateSMSDK(
            verificationLink: verificationLink,
            setOnComplete: onComplete,
            redirectBack: onRedirectBack,
            selfieImageUrl: selfieGuideURL,
            cardGuideUrl: cardGuideURL,
            termsAndConditionsUrl: termsURL,
            onCancel: onCancel,
            primaryButtonColor: hexColor(primaryThemeColor),
            textColor: hexColor(textThemeColor),
            headingColor: hexColor(primaryThemeColor),
            cameraPageTitleColor: hexColor(primaryThemeColor)
        )

        navigationController?.pushViewController(smManagerVC, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

