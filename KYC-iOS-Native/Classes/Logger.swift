//
//  Logger.swift
//  MyCocoaPodLibraryBps
//

import Foundation
import UIKit

public class Logger {
        
    func privateMethod(){
        print("Private")
    }
    
    public static func initiateSMSDK( verificationLink: String, workflowId: String ,setOnComplete:(Any),redirectBack:(Any),selfieImageUrl:String?,cardGuideUrl:String?) -> UIViewController {
     
        Faceki_verificationLink = verificationLink
        Faceki_workflowId = workflowId
        facekiOnComplete = setOnComplete as? ([AnyHashable:Any]) -> ()
        if selfieImageUrl != nil {
            Faceki_selfieImageUrl = selfieImageUrl!
            }
        if cardGuideUrl != nil {
            Faceki_cardGuideUrl = cardGuideUrl!
            }
        FacekiredirectBack = redirectBack as? () -> ()
        
        let frameworkImageBundle = Bundle(for: Logger.self)
        let VC = UIStoryboard(name: "MainFACEKI", bundle: frameworkImageBundle).instantiateViewController(withIdentifier: "OnBoardingViewController")
        VC.modalTransitionStyle = .crossDissolve
        VC.modalPresentationStyle = .overCurrentContext
//        VC.paramsSet = params
//        VC.delegateSm = delegate
        
        return VC
    }
    
}
