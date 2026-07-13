import UIKit

class ViewController: UIViewController {
    
    //MARK: -Instance Method
    class func viewController() -> ViewController {
        return UIStoryboard(name: "MainFACEKI", bundle: frameworkImageBundle).instantiateViewController(withIdentifier: "ViewController") as! ViewController
    }
    
    //MARK: -Outlets
    @IBOutlet weak var lottieAnimationView : UIView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var subtitleLabel : UILabel!
    @IBOutlet weak var nextButton : UIButton!
    
    //MARK: -Properties
    var allowSingle : Bool?
    var viewModel = HomeViewModel()
    
    //MARK: -lifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                   overrideUserInterfaceStyle = .light
               }

        applyStandardScreenBackground()
        styleHeading(
            titleLabel: titleLabel,
            subtitleLabel: subtitleLabel,
            title: "Lets Verify Your Identity",
            subtitle: "We’ll ask for your ID and a selfie. It’s quick and secure."
        )
        stylePrimaryActionButton(nextButton, title: "NEXT")
        addTopCancelButton(target: self, action: #selector(didTapCancel))
        addPoweredByFooter(anchoredAbove: nextButton)

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadAnimation()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool){
    }
    
    //MARK: -Actions
    @IBAction private func didTapNext(_ sender : UIButton) {
        guard requireInternetConnection() else { return }
        self.startActivityIndicator()
        self.getDocumentRulesApiCall()
    }

    @objc private func didTapCancel() {
        cancelSDKFlow()
    }
    
    //MARK: -Methods
    private func loadAnimation(){
        let animationView = LottieAnimationView(name: "lottieGuidance.json", bundle: frameworkImageBundle)
//        let animationView = LottieAnimationView(name: "lottieGuidance.json")
        animationView.frame = lottieAnimationView.bounds
        lottieAnimationView.addSubview(animationView)
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.7
        animationView.play()
    }
    
    private func getDocumentRulesApiCall(){
        Task {
            do{
                let result = try await viewModel.workflowRulesApiCall()
//                result.data?.allowSingle = true
//                result.data?.allowedKycDocuments = [DocumentType.idCard.rawValue,DocumentType.passport.rawValue,DocumentType.drivingLicense.rawValue]
                self.stopActivityIndicator()
                if let allowSingle = result.result?.document_optional {
                    if allowSingle {
                        let vc = DocumentSelectionVC.documentSelectionVc()
                        vc.model = result.result
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vc = DocumentDetailVC.documentDetailVc()
                        vc.model = result.result
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
                Faceki_workflowId = result.result?.workflowId ?? ""
                
            } catch {
                self.stopActivityIndicator()
                if let serviceError = error as? ServiceError,
                   case .noInternetConnection = serviceError {
                    Utility.showAlertWithOk(title: "No Internet Connection", message: "Please check your internet connection and try again.")
                    return
                }
                Utility.showAlertWithOk(title: "Error", message: "An error Occurred, try again later.")
            }
        }
    }
    
    
}

