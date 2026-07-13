//
//  SuccessFailureVC.swift
//  ScanDocument
//
//

import UIKit

class SuccessFailureVC: UIViewController {
    
    //MARK: -Instance Method
    class func successFailureVc() -> SuccessFailureVC {
        return UIStoryboard(name: "MainFACEKI", bundle: frameworkImageBundle).instantiateViewController(withIdentifier: "SuccessFailureVC") as! SuccessFailureVC
    }
    
    //MARK: -Outlets
    @IBOutlet weak var lottieAnimationView : UIView!
    @IBOutlet weak var statusTitleLabel : UILabel!
    @IBOutlet weak var statusSubtitleLabel : UILabel!
    
    //MARK: -Properties
    var decision : String?
    
    //MARK: -LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                   overrideUserInterfaceStyle = .light
               }
        applyTheme()
        if let decision {
            self.loadAnimation()
            if decision == "ACCEPTED" {
                statusTitleLabel.text = "Successful"
                statusSubtitleLabel.text = "Your identity verification successful"
            } else {
                statusTitleLabel.text = "Failed"
                statusSubtitleLabel.text = "Your identity verification failed"
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.finishFlow()
            }
        }
    }
    
    //MARK: -Methods
    private func applyTheme() {
        view.backgroundColor = .white
        statusTitleLabel.textColor = FacekiThemeColor.heading
        statusTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        statusSubtitleLabel.textColor = FacekiThemeColor.textSecondary
        statusSubtitleLabel.font = UIFont.systemFont(ofSize: FacekiTypography.headingSubtitle, weight: .regular)
        addPoweredByFooter()
    }

    private func loadAnimation(){
        let animationView = LottieAnimationView(name: self.decision == "ACCEPTED" ? "lottieSuccess.json" : "lottieFail.json", bundle: frameworkImageBundle)
        animationView.frame = lottieAnimationView.bounds
        lottieAnimationView.addSubview(animationView)
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.9
        animationView.play()
    }

    private func finishFlow() {
        if let redirect = FacekiredirectBack {
            redirect()
            return
        }

        navigationController?.popToRootViewController(animated: true)
    }
    
}
