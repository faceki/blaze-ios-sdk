import Foundation
import UIKit

enum FacekiTypography {
    static let headingTitle: CGFloat = 22
    static let headingSubtitle: CGFloat = 14
    static let primaryButton: CGFloat = 13
}

enum FacekiThemeColor {
    static var primaryButtonBackground: UIColor { Faceki_primaryButtonColor }
    static var primaryButtonText: UIColor { UIColor.white }
    static var textPrimary: UIColor { Faceki_textColor }
    static var textSecondary: UIColor { Faceki_textColor.withAlphaComponent(0.85) }
    static var heading: UIColor { Faceki_headingColor }
    static var cameraPageTitle: UIColor { Faceki_cameraPageTitleColor }
}

class Utility {
    
    class func showAlertWithOk(title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }
}

public extension UIViewController{
    var activityIndicatorTag: Int { return 999999 }
    func startActivityIndicator(
        style: UIActivityIndicatorView.Style = .medium,
        location: CGPoint? = nil) {
            let loc = location ?? self.view.center
            DispatchQueue.main.async {
                let activityIndicator = UIActivityIndicatorView(style: style)
                activityIndicator.tag = self.activityIndicatorTag
                if #available(iOS 13.0, *) {
                    activityIndicator.color = UIColor(hexString: "#C0C0C0")
                } else {
                    activityIndicator.color = UIColor(hexString: "#C0C0C0")
                }
                activityIndicator.center = loc
                activityIndicator.hidesWhenStopped = true
                activityIndicator.startAnimating()
                self.view.addSubview(activityIndicator)
            }
        }
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            if let activityIndicator = self.view.subviews.filter(
                { $0.tag == self.activityIndicatorTag}).first as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    }

    func applyStandardScreenBackground() {
        view.backgroundColor = .white
    }

    func stylePrimaryActionButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.setImage(nil, for: .normal)
        button.backgroundColor = FacekiThemeColor.primaryButtonBackground
        button.setTitleColor(FacekiThemeColor.primaryButtonText, for: .normal)
        button.tintColor = FacekiThemeColor.primaryButtonText
        button.layer.cornerRadius = 14
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: FacekiTypography.primaryButton, weight: .bold)
        button.titleLabel?.adjustsFontSizeToFitWidth = false
        normalizePrimaryButtonLayout(button)
    }

    func normalizePrimaryButtonLayout(_ button: UIButton) {
        let safe = view.safeAreaLayoutGuide
        var hasLeading = false
        var hasTrailing = false
        var hasBottom = false

        for c in button.constraints where c.firstAttribute == .width || c.firstAttribute == .height {
            if c.firstAttribute == .height {
                c.constant = 56
            }
            if c.firstAttribute == .width {
                c.isActive = false
            }
        }

        for c in view.constraints {
            let hasButton = (c.firstItem as? UIButton) === button || (c.secondItem as? UIButton) === button
            guard hasButton else { continue }

            if c.firstAttribute == .width || c.secondAttribute == .width {
                c.isActive = false
                continue
            }

            if c.firstAttribute == .top || c.secondAttribute == .top ||
                c.firstAttribute == .centerY || c.secondAttribute == .centerY {
                c.isActive = false
                continue
            }

            if c.firstAttribute == .leading || c.secondAttribute == .leading {
                hasLeading = true
                if c.firstItem === button {
                    c.constant = 25
                } else if c.secondItem === button {
                    c.constant = 25
                }
            }

            if c.firstAttribute == .trailing || c.secondAttribute == .trailing {
                hasTrailing = true
                if c.firstItem === button {
                    c.constant = -25
                } else if c.secondItem === button {
                    c.constant = 25
                }
            }

            if c.firstAttribute == .bottom || c.secondAttribute == .bottom {
                hasBottom = true
                if c.firstItem === button {
                    c.constant = -20
                } else if c.secondItem === button {
                    c.constant = 20
                }
            }
        }

        if !hasLeading {
            button.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 25).isActive = true
        }
        if !hasTrailing {
            button.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -25).isActive = true
        }
        if !hasBottom {
            button.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -20).isActive = true
        }

        if !button.constraints.contains(where: { $0.firstAttribute == .height }) {
            button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        }
    }

    func styleBackButton(_ button: UIButton) {
        button.tintColor = FacekiThemeColor.textPrimary
    }

    @discardableResult
    func addPoweredByFooter(anchoredAbove button: UIButton? = nil) -> UIView {
        if let button {
            for constraint in view.constraints {
                let hasButton = (constraint.firstItem as? UIButton) === button || (constraint.secondItem as? UIButton) === button
                guard hasButton else { continue }

                if constraint.firstAttribute == .bottom || constraint.secondAttribute == .bottom {
                    constraint.isActive = false
                }
            }
        }

        let footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.backgroundColor = .clear

        let poweredByLabel = UILabel()
        poweredByLabel.translatesAutoresizingMaskIntoConstraints = false
        poweredByLabel.text = "Powered by"
        poweredByLabel.textColor = FacekiThemeColor.textSecondary
        poweredByLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)

        let logoView = UIImageView()
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.contentMode = .scaleAspectFit
        logoView.image = sdkPoweredByLogoImage()

        let stackView = UIStackView(arrangedSubviews: [poweredByLabel, logoView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 6

        footerView.addSubview(stackView)
        view.addSubview(footerView)

        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: footerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: footerView.trailingAnchor, constant: -16),

            logoView.widthAnchor.constraint(equalToConstant: 74),
            logoView.heightAnchor.constraint(equalToConstant: 22),

            footerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -12),
            footerView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            footerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 28)
        ])

        if let button {
            NSLayoutConstraint.activate([
                button.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: -12)
            ])
        }

        return footerView
    }

    private func sdkPoweredByLogoImage() -> UIImage? {
        let bundlesToSearch: [Bundle] = {
            if let bundlePath = frameworkImageBundle.path(forResource: "Resources", ofType: "bundle"),
               let resourcesBundle = Bundle(path: bundlePath) {
                return [resourcesBundle, frameworkImageBundle, Bundle.main]
            }

            return [frameworkImageBundle, Bundle.main]
        }()

        for bundle in bundlesToSearch {
            if let image = UIImage(named: "logo", in: bundle, compatibleWith: nil) {
                return image
            }

            if let url = bundle.url(forResource: "logo", withExtension: "png"),
               let image = UIImage(contentsOfFile: url.path) {
                return image
            }

            if let resourceURL = bundle.resourceURL,
               let enumerator = FileManager.default.enumerator(at: resourceURL, includingPropertiesForKeys: nil) {
                for case let fileURL as URL in enumerator {
                    if fileURL.lastPathComponent.lowercased() == "logo.png",
                       let image = UIImage(contentsOfFile: fileURL.path) {
                        return image
                    }
                }
            }
        }

        return nil
    }

    func styleHeading(titleLabel: UILabel, subtitleLabel: UILabel, title: String, subtitle: String) {
        titleLabel.text = title
        titleLabel.textColor = FacekiThemeColor.heading
        titleLabel.font = UIFont.systemFont(ofSize: FacekiTypography.headingTitle, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.lineBreakMode = .byWordWrapping

        subtitleLabel.text = subtitle
        subtitleLabel.textColor = FacekiThemeColor.textSecondary
        subtitleLabel.font = UIFont.systemFont(ofSize: FacekiTypography.headingSubtitle, weight: .regular)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .left
        subtitleLabel.adjustsFontSizeToFitWidth = false
        subtitleLabel.lineBreakMode = .byWordWrapping
    }

    func styleSelectionCard(_ view: UIView) {
        view.backgroundColor = UIColor(white: 0.75, alpha: 0.24)
        view.layer.cornerRadius = 8
    }

    @discardableResult
    func addTopCancelButton(target: Any, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = FacekiThemeColor.textPrimary
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.addTarget(target, action: action, for: .touchUpInside)
        view.addSubview(button)

        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: safe.topAnchor, constant: 8),
            button.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -15),
            button.widthAnchor.constraint(equalToConstant: 34),
            button.heightAnchor.constraint(equalToConstant: 34)
        ])

        return button
    }

    @discardableResult
    func requireInternetConnection() -> Bool {
        guard Reachability.isConnectedToNetwork() else {
            Utility.showAlertWithOk(
                title: "No Internet Connection",
                message: "Please check your internet connection and try again."
            )
            return false
        }
        return true
    }

    func cancelSDKFlow() {
        if let onCancel = FacekiOnCancel {
            onCancel()
            return
        }

        if let redirect = FacekiredirectBack {
            redirect()
            return
        }

        if let nav = navigationController {
            nav.popToRootViewController(animated: true)
            return
        }

        dismiss(animated: true)
    }
}
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
