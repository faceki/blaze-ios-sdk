import UIKit

class OnBoardingViewController: UIViewController {
    
    //MARK: -Outlets
    @IBOutlet weak var lottieAnimationView : UIView!
    @IBOutlet weak var facekiLogo : UIImageView!

    //MARK: -lifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                   overrideUserInterfaceStyle = .light
               }
        
        addPoweredByFooter()
    }
    
    override func viewWillAppear(_ animated: Bool){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadAnimation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getTokenApiCall()
    }
    
    //MARK: -Methods
    private func presetHomeVC(){
        DispatchQueue.main.async {
            let vc = ViewController.viewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func loadAnimation(){
        let animationView = LottieAnimationView(name: "lottieFirstLoading.json", bundle: frameworkImageBundle)
        animationView.frame = lottieAnimationView.bounds
        lottieAnimationView.addSubview(animationView)
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.play()
    }
    
    private func getTokenApiCall(){
        Task {
            do{
    
         
                self.presetHomeVC()
            } catch {
                Utility.showAlertWithOk(title: "Error", message: "An error Occurred, try again later.")
            }
        }
    }
}
