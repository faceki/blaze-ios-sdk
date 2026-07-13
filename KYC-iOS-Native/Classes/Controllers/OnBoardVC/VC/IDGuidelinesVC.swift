//
//  IDGuidelinesVC.swift
//  ScanDocument
//
//

import UIKit
import ImageIO

class IDGuidelinesVC: UIViewController {
    
    //MARK: -Instance Method
    class func idGiudlinesVc() -> IDGuidelinesVC {
        return UIStoryboard(name: "MainFACEKI", bundle: frameworkImageBundle).instantiateViewController(withIdentifier: "IDGuidelinesVC") as! IDGuidelinesVC
    }
    
    @IBOutlet weak var guideImage : UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var subtitleLabel : UILabel!
    @IBOutlet weak var readyButton : UIButton!
    @IBOutlet weak var backButton : UIButton!

    
    //MARK: -Properties
    var model : ResultModel?
    var isCardSelected : Bool?
    var isPassportSelected : Bool?
    var isDrivingLicenseSelected : Bool?

    private func log(_ message: String) {
        print("[FACEKI-IDGUIDE] \(message)")
    }
    
    //MARK: -LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                   overrideUserInterfaceStyle = .light
               }

        applyStandardScreenBackground()
        styleHeading(
            titleLabel: titleLabel,
            subtitleLabel: subtitleLabel,
            title: "Lets Start",
            subtitle: "Follow these guidelines before you capture your document."
        )
        stylePrimaryActionButton(readyButton, title: "NEXT")
        styleBackButton(backButton)
        addTopCancelButton(target: self, action: #selector(didTapCancel))
        addPoweredByFooter(anchoredAbove: readyButton)

        log("viewDidLoad")
        log("Faceki_cardGuideUrl = \(Faceki_cardGuideUrl ?? "nil")")
        log("framework bundle = \(frameworkImageBundle.bundlePath)")
        log("assets bundle = \(sdkAssetsBundle.bundlePath)")
        
        if let guideUrlString = Faceki_cardGuideUrl,
           !guideUrlString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           let url = URL(string: guideUrlString) {
            log("Using remote guide URL")
            downloadImage(from: url)
        } else {
            log("No guide URL found, loading fallback GIF")
            loadFallbackGuideGif()
        }
    }
    
    //MARK: -Actions
    @IBAction private func didTapReady(_ sender : UIButton) {
        let vc = ScanDocumentVC.scanDocument()
        vc.model = self.model
        vc.isCardSelected = self.isCardSelected
        vc.isPassportSelected = self.isPassportSelected
        vc.isDrivingLicenseSelected = self.isDrivingLicenseSelected
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func didTapBack(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func didTapCancel() {
        cancelSDKFlow()
    }
    
    
    private func downloadImage(from url: URL) {
        log("Downloading image from URL: \(url.absoluteString)")
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let http = response as? HTTPURLResponse {
                self.log("Download HTTP status: \(http.statusCode)")
            }
            if let error = error {
                self.log("Download error: \(error.localizedDescription)")
            }
            guard let data = data, let image = UIImage(data: data) else {
                self.log("Download succeeded but data could not decode as UIImage. Falling back to GIF.")
                DispatchQueue.main.async {
                    self.loadFallbackGuideGif()
                }
                return
            }

            self.log("Remote image decoded. bytes=\(data.count) size=\(image.size.width)x\(image.size.height)")

            DispatchQueue.main.async {
                self.guideImage.image = image
            }
        }.resume()
    }

    private func loadFallbackGuideGif() {
        if playGif(named: "qjejkS") {
            log("GIF fallback is playing")
            return
        }

        guideImage.image = UIImage(named: "ex-id-card.png", in: sdkAssetsBundle, compatibleWith: nil)
    }

    private func playGif(named name: String) -> Bool {
        guard let source = gifSource(named: name) else { return false }

        let frameCount = CGImageSourceGetCount(source)
        guard frameCount > 0 else { return false }

        var frames: [UIImage] = []
        var duration: TimeInterval = 0

        for index in 0..<frameCount {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, index, nil) else { continue }
            frames.append(UIImage(cgImage: cgImage))
            duration += gifFrameDuration(from: source, at: index)
        }

        guard !frames.isEmpty else { return false }
        if duration <= 0 { duration = Double(frames.count) * 0.1 }
        guideImage.stopAnimating()
        guideImage.animationImages = frames
        guideImage.animationDuration = duration
        guideImage.animationRepeatCount = 0
        guideImage.image = frames.first
        guideImage.startAnimating()
        return true
    }

    private func gifSource(named name: String) -> CGImageSource? {
        let candidateBundles = uniqueBundles([
            sdkAssetsBundle,
            frameworkImageBundle,
            Bundle.main
        ] + Bundle.allBundles + Bundle.allFrameworks)

        for bundle in candidateBundles {
            log("Searching bundle: \(bundle.bundlePath)")
            if let directURL = bundle.url(forResource: name, withExtension: "gif"),
               let source = CGImageSourceCreateWithURL(directURL as CFURL, nil) {
                log("Found GIF (direct): \(directURL.path)")
                return source
            }

            if let assetsURL = bundle.url(forResource: name, withExtension: "gif", subdirectory: "Assets"),
               let source = CGImageSourceCreateWithURL(assetsURL as CFURL, nil) {
                log("Found GIF (Assets subdir): \(assetsURL.path)")
                return source
            }

            if let resourceURL = bundle.resourceURL,
               let enumerator = FileManager.default.enumerator(at: resourceURL, includingPropertiesForKeys: nil) {
                for case let fileURL as URL in enumerator {
                    if fileURL.lastPathComponent.lowercased() == "\(name.lowercased()).gif",
                       let source = CGImageSourceCreateWithURL(fileURL as CFURL, nil) {
                        log("Found GIF (recursive): \(fileURL.path)")
                        return source
                    }
                }
            }
        }

        log("GIF not found in any searched bundle")
        return nil
    }

    private func uniqueBundles(_ bundles: [Bundle]) -> [Bundle] {
        var seen = Set<String>()
        var unique: [Bundle] = []

        for bundle in bundles {
            let key = bundle.bundlePath
            if seen.contains(key) { continue }
            seen.insert(key)
            unique.append(bundle)
        }

        return unique
    }

    private func animatedImageFromGif(named name: String) -> UIImage? {
        guard let source = gifSource(named: name) else {
            return nil
        }

        let frameCount = CGImageSourceGetCount(source)
        guard frameCount > 0 else { return nil }

        var images: [UIImage] = []
        var duration: TimeInterval = 0

        for index in 0..<frameCount {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, index, nil) else { continue }
            let frameDuration = gifFrameDuration(from: source, at: index)
            duration += frameDuration
            images.append(UIImage(cgImage: cgImage))
        }

        if duration <= 0 { duration = Double(frameCount) * 0.1 }
        return UIImage.animatedImage(with: images, duration: duration)
    }

    private func gifFrameDuration(from source: CGImageSource, at index: Int) -> TimeInterval {
        let defaultDuration: TimeInterval = 0.1
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [CFString: Any],
              let gifInfo = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any] else {
            return defaultDuration
        }

        let unclamped = gifInfo[kCGImagePropertyGIFUnclampedDelayTime] as? Double
        let clamped = gifInfo[kCGImagePropertyGIFDelayTime] as? Double
        let duration = unclamped ?? clamped ?? defaultDuration
        return duration > 0.011 ? duration : defaultDuration
    }
    
}
