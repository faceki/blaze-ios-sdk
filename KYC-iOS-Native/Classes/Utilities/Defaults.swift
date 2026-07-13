//
//  Defaults.swift
//  ScanDocument
//
//  Created by FACEKI on 15/01/2024.
//
class Defaults {
    static let shared = Defaults()
    private init() {}
    func setToken(token: String) {
        UserDefaults.standard.set(token, forKey: "token")
    }
    func getToken() -> String {
        UserDefaults.standard.string(forKey: "token") ?? ""
    }
}

var Faceki_workflowId = ""
var Faceki_verificationLink = ""
var Faceki_selfieImageUrl: String?
var Faceki_cardGuideUrl: String?
var Faceki_termsAndConditionsUrl: String?

let Faceki_defaultPrimaryButtonColor = UIColor(red: 0.96, green: 0.71, blue: 0.16, alpha: 1.0)
let Faceki_defaultTextColor = UIColor.black
let Faceki_defaultHeadingColor = UIColor.black

var Faceki_primaryButtonColor: UIColor = Faceki_defaultPrimaryButtonColor
var Faceki_textColor: UIColor = Faceki_defaultTextColor
var Faceki_headingColor: UIColor = Faceki_defaultHeadingColor
var Faceki_cameraPageTitleColor: UIColor = Faceki_defaultPrimaryButtonColor


let frameworkImageBundle = Bundle(for: Logger.self)
let pathImage = frameworkImageBundle.path(forResource: "Resources", ofType: "bundle")
let resourcesBundleImg: Bundle? = {
    guard let pathImage = pathImage else { return nil }
    return Bundle(url: URL(fileURLWithPath: pathImage))
}()

let sdkAssetsBundle: Bundle = resourcesBundleImg ?? frameworkImageBundle

var facekiOnComplete: ((_ date: [AnyHashable:Any]) -> ())?
var FacekiredirectBack: (() -> ())?
var FacekiOnCancel: (() -> ())?
