import Foundation
import UIKit

public class Logger {

    public static func initiateSMSDK(
        verificationLink: String,
        setOnComplete: (Any),
        redirectBack: (Any),
        selfieImageUrl: String?,
        cardGuideUrl: String?,
        termsAndConditionsUrl: String? = nil,
        onCancel: Any? = nil,
        primaryButtonColor: UIColor? = nil,
        textColor: UIColor? = nil,
        headingColor: UIColor? = nil,
        cameraPageTitleColor: UIColor? = nil
    ) -> UIViewController {
     
        Faceki_verificationLink = verificationLink
        facekiOnComplete = setOnComplete as? ([AnyHashable:Any]) -> ()
        Faceki_selfieImageUrl = selfieImageUrl
        Faceki_cardGuideUrl = cardGuideUrl
        Faceki_termsAndConditionsUrl = termsAndConditionsUrl
        FacekiredirectBack = redirectBack as? () -> ()
        FacekiOnCancel = onCancel as? () -> ()
        Faceki_primaryButtonColor = primaryButtonColor ?? Faceki_defaultPrimaryButtonColor
        Faceki_textColor = textColor ?? Faceki_defaultTextColor
        Faceki_headingColor = headingColor ?? Faceki_defaultHeadingColor
        Faceki_cameraPageTitleColor = cameraPageTitleColor ?? Faceki_primaryButtonColor
        
        let frameworkImageBundle = Bundle(for: Logger.self)
        let VC = UIStoryboard(name: "MainFACEKI", bundle: frameworkImageBundle).instantiateViewController(withIdentifier: "ViewController")
        VC.modalTransitionStyle = .crossDissolve
        VC.modalPresentationStyle = .overCurrentContext
        return VC
    }
    
}
