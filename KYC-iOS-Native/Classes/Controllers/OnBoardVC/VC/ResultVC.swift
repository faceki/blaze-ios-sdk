//
//  ResultVC.swift
//  ScanDocument
//
//

import UIKit

class ResultVC: UIViewController {
    
    //MARK: -Instance Method
    class func resultVc() -> ResultVC {
        return UIStoryboard(name: "MainFACEKI", bundle: frameworkImageBundle).instantiateViewController(withIdentifier: "ResultVC") as! ResultVC
    }
    
    //MARK: -Outlets
    @IBOutlet weak var lottieAnimationView : UIView!
    
    var imagesData : [(imageName: String, imageData: Data)]?
    var model : ResultModel?
    
    //MARK: -lifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                   overrideUserInterfaceStyle = .light
               }
        self.kycVerificationApiCall(imagesData: self.imagesData!, urlString: "https://sdk.faceki.com/api/v3/kyc_verification")
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadAnimation()
        }
    }
    
    //MARK: -Methods
    private func loadAnimation(){
        let animationView = LottieAnimationView(name: "lottieLoading.json", bundle: frameworkImageBundle)
        animationView.frame = lottieAnimationView.bounds
        lottieAnimationView.addSubview(animationView)
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.9
        animationView.play()
    }
    
    private func presentFinalVC(decision : String){
        let vc = SuccessFailureVC.successFailureVc()
        vc.decision = decision
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func kycVerificationApiCall(imagesData : [(imageName: String, imageData: Data)], urlString : String) {
        
        Task {
            do {
                let data = try await Request.shared.uploadMultipleImages(KYCVerification.self, method: .post, imageDatas: self.imagesData!, url: urlString, params: ["workflowId": Faceki_workflowId], authToken: Defaults.shared.getToken())
             
                self.presentFinalVC(decision: data.result?.decision ?? "")
            } catch {
                self.presentFinalVC(decision: "")
            }
        }
        
    }
}
