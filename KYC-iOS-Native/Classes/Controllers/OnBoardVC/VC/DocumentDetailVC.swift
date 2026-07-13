//
//  DocumentDetailVC.swift
//  ScanDocument
//
//

import UIKit

class DocumentDetailVC: UIViewController {
    
    //MARK: -Instance Method
    class func documentDetailVc() -> DocumentDetailVC {
        return UIStoryboard(name: "MainFACEKI", bundle: frameworkImageBundle).instantiateViewController(withIdentifier: "DocumentDetailVC") as! DocumentDetailVC
    }
    
    //MARK: -Outlets
    @IBOutlet weak var checkMarkButton : UIButton!
    @IBOutlet weak var frontPicLabel : UILabel!
    @IBOutlet weak var backPicLabel : UILabel!
    @IBOutlet weak var passportFrontLabel : UILabel!
    @IBOutlet weak var drivingLicenseFrontLabel : UILabel!
    @IBOutlet weak var drivingLicenseBackLabel : UILabel!
    
    @IBOutlet weak var idFrontNumberLabel : UILabel!
    @IBOutlet weak var idBackNumberLabel : UILabel!
    @IBOutlet weak var passportNumberLabel : UILabel!
    @IBOutlet weak var dlFrontNumberLabel : UILabel!
    @IBOutlet weak var dlBackNumberLabel : UILabel!
    @IBOutlet weak var selfieNumberLabel : UILabel!
    
    @IBOutlet weak var frontPicView : UIView!
    @IBOutlet weak var backPicView : UIView!
    @IBOutlet weak var passportFrontView : UIView!
    @IBOutlet weak var drivingLicenseFrontView : UIView!
    @IBOutlet weak var drivingLicenseBackView : UIView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var subtitleLabel : UILabel!
    @IBOutlet weak var nextButton : UIButton!
    @IBOutlet weak var stepsStackView : UIStackView!
    @IBOutlet weak var backButton : UIButton!
    @IBOutlet weak var checkmarkTitleLabel : UILabel!
    
    
    //MARK: -Properties
    var isMarkChecked = false
    var params : [String : Any] = [:]
    
    var idCardSelected : Bool?
    var isPassportSelected : Bool?
    var isDrivingLicenseSelected : Bool?
    var model : ResultModel?
    private var termsButton: UIButton?
    
    //MARK: -LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
                   overrideUserInterfaceStyle = .light
               }
        
        if self.model?.document_optional ?? false {
            
            if self.idCardSelected ?? false {
                backPicView.isHidden = false
                frontPicView.isHidden = false
                frontPicLabel.text = "Picture of your ID Card Front"
                backPicLabel.text = "Picture of your ID Card Back"
                
                passportFrontView.isHidden = true
                drivingLicenseBackView.isHidden = true
                drivingLicenseFrontView.isHidden = true
                
                idFrontNumberLabel.text = "1"
                idBackNumberLabel.text = "2"
                
            } else if self.isPassportSelected ?? false {
                backPicView.isHidden = true
                frontPicView.isHidden = false
                frontPicLabel.text = "Picture of your Passport Front"
                
                passportFrontView.isHidden = true
                drivingLicenseBackView.isHidden = true
                drivingLicenseFrontView.isHidden = true
                
                passportNumberLabel.text = "1"
                
            }  else if self.isDrivingLicenseSelected ?? false {
                backPicView.isHidden = false
                frontPicView.isHidden = false
                frontPicLabel.text = "Picture of your Driving License Front"
                backPicLabel.text = "Picture of your Driving License Back"
                
                passportFrontView.isHidden = true
                drivingLicenseBackView.isHidden = true
                drivingLicenseFrontView.isHidden = true
                
                dlFrontNumberLabel.text = "1"
                dlBackNumberLabel.text = "2"
            }
            selfieNumberLabel.text = "3"
        } else {
            var number = 1
            if isTypeAllowed(type: .idCard) {
                idFrontNumberLabel.text = String(describing: number)
                number += 1
                idBackNumberLabel.text = String(describing: number)
                number += 1
            }
            if isTypeAllowed(type: .passport) {
                passportNumberLabel.text = String(describing: number)
                number += 1
            }
            if isTypeAllowed(type: .drivingLicense) {
                dlFrontNumberLabel.text = String(describing: number)
                number += 1
                dlBackNumberLabel.text = String(describing: number)
                number += 1
            }
            selfieNumberLabel.text = String(describing: number)
            
            backPicView.isHidden = !isTypeAllowed(type: .idCard)
            frontPicView.isHidden = !isTypeAllowed(type: .idCard)
            frontPicLabel.text = "Picture of your ID Card Front"
            backPicLabel.text = "Picture of your ID Card Back"
            
            passportFrontView.isHidden = !isTypeAllowed(type: .passport)
            passportFrontLabel.text = "Picture of your Passport Front"
            
            drivingLicenseBackView.isHidden = !isTypeAllowed(type: .drivingLicense)
            drivingLicenseFrontView.isHidden = !isTypeAllowed(type: .drivingLicense)
            drivingLicenseFrontLabel.text = "Picture of your Driving License Front"
            drivingLicenseBackLabel.text = "Picture of your Driving License Back"
        }
        
        
        checkMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
        applyDesignStyle()
        
    }

    private func applyDesignStyle() {
        applyStandardScreenBackground()
        styleHeading(
            titleLabel: titleLabel,
            subtitleLabel: subtitleLabel,
            title: "Confirm your identity",
            subtitle: "We’ll ask for your ID and a selfie. It’s quick and secure, and trusted by millions of users worldwide."
        )
        stylePrimaryActionButton(nextButton, title: "NEXT")
        styleBackButton(backButton)
        addTopCancelButton(target: self, action: #selector(didTapCancel))
        addPoweredByFooter(anchoredAbove: nextButton)

        stepsStackView.spacing = 24
        let stepViews = stepsStackView.arrangedSubviews
        for row in stepViews {
            row.backgroundColor = .clear
            row.layer.cornerRadius = 0
            for constraint in row.constraints {
                if constraint.firstAttribute == .height {
                    constraint.constant = 64
                }
            }

            for subview in row.subviews {
                if let label = subview as? UILabel {
                    if label == idFrontNumberLabel || label == idBackNumberLabel || label == passportNumberLabel || label == dlFrontNumberLabel || label == dlBackNumberLabel {
                        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
                        label.textColor = FacekiThemeColor.textPrimary
                    } else if label == selfieNumberLabel {
                        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
                        label.textColor = FacekiThemeColor.textPrimary
                    } else {
                        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
                        label.textColor = FacekiThemeColor.textSecondary
                        label.numberOfLines = 0
                    }
                }

                if let imageView = subview as? UIImageView {
                    imageView.backgroundColor = .clear
                    imageView.tintColor = FacekiThemeColor.textPrimary
                }
            }
        }

        selfieNumberLabel.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        selfieNumberLabel.textColor = FacekiThemeColor.textPrimary

        for subview in passportFrontView.subviews {
            if let label = subview as? UILabel, label == passportFrontLabel {
                label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
                label.numberOfLines = 0
            }
        }

        checkMarkButton.backgroundColor = .clear
        checkMarkButton.setImage(nil, for: .normal)
        checkMarkButton.setTitle(nil, for: .normal)
        checkMarkButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        checkMarkButton.contentHorizontalAlignment = .center
        checkMarkButton.contentVerticalAlignment = .center
        for constraint in checkMarkButton.constraints {
            if constraint.firstAttribute == .width || constraint.firstAttribute == .height {
                constraint.constant = 22
            }
        }
        updateCheckmarkUI()
        checkmarkTitleLabel.textColor = FacekiThemeColor.textSecondary
        checkmarkTitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        setupTermsLinkIfProvided()
    }

    private func updateCheckmarkUI() {
        if #available(iOS 15.0, *) {
            checkMarkButton.configuration = nil
        }

        checkMarkButton.layer.cornerRadius = 0
        checkMarkButton.layer.borderWidth = 1.5
        checkMarkButton.clipsToBounds = true
        checkMarkButton.setImage(nil, for: .normal)
        checkMarkButton.setImage(nil, for: .selected)
        checkMarkButton.setImage(nil, for: .highlighted)
        checkMarkButton.contentEdgeInsets = .zero

        if isMarkChecked {
            checkMarkButton.layer.borderColor = FacekiThemeColor.primaryButtonBackground.cgColor
            checkMarkButton.backgroundColor = .clear
            checkMarkButton.setTitle("✓", for: .normal)
            checkMarkButton.setTitleColor(FacekiThemeColor.primaryButtonBackground, for: .normal)
        } else {
            checkMarkButton.layer.borderColor = UIColor(white: 0.45, alpha: 1.0).cgColor
            checkMarkButton.backgroundColor = .clear
            checkMarkButton.setTitle("", for: .normal)
        }
    }

    private func setupTermsLinkIfProvided() {
        guard let urlString = Faceki_termsAndConditionsUrl,
              !urlString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            termsButton?.removeFromSuperview()
            termsButton = nil
            return
        }

        if termsButton == nil {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.contentHorizontalAlignment = .left
            button.setTitle("Terms & Conditions", for: .normal)
            button.setTitleColor(FacekiThemeColor.primaryButtonBackground, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)

            let title = NSAttributedString(
                string: "Terms & Conditions",
                attributes: [
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: FacekiThemeColor.primaryButtonBackground,
                    .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
                ]
            )
            button.setAttributedTitle(title, for: .normal)
            button.addTarget(self, action: #selector(didTapTermsAndConditions), for: .touchUpInside)

            view.addSubview(button)
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: checkmarkTitleLabel.leadingAnchor),
                button.topAnchor.constraint(equalTo: checkmarkTitleLabel.bottomAnchor, constant: 6)
            ])

            termsButton = button
        }
    }
    func isTypeAllowed(type: DocumentType) -> Bool {
            return self.model?.documents.contains(type.rawValue) == true
        }
    
    //MARK: -Actions
    @IBAction private func didTapCheckMark(_ sender : UIButton ){
        isMarkChecked.toggle()
        updateCheckmarkUI()
    }
    
    @IBAction private func didTapNext(_ sender : UIButton) {
        if isMarkChecked {
            let vc = IDGuidelinesVC.idGiudlinesVc()
            vc.model = self.model
            vc.isCardSelected = self.idCardSelected
            vc.isPassportSelected = self.isPassportSelected
            vc.isDrivingLicenseSelected = self.isDrivingLicenseSelected
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            Utility.showAlertWithOk(title: "Alert", message: "Fill the Above checkmark First.")
        }
    }
    
    @IBAction private func didTapBack(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func didTapCancel() {
        cancelSDKFlow()
    }

    @objc private func didTapTermsAndConditions() {
        guard let urlString = Faceki_termsAndConditionsUrl,
              let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}
