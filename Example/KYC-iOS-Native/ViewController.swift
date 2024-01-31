//
//  ViewController.swift
//  KYC-iOS-Native
//
//  Created by faceki on 01/04/2022.
//  Copyright (c) 2022 faceki. All rights reserved.
//

import UIKit
import FACEKI_BLAZE_IOS

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func onComplete(data:[AnyHashable:Any]){
        print("API Response")
        print(type(of: data))

        if let dataObject = data["result"] as? [AnyHashable: Any]{
            print(dataObject["requestId"]!)
            print(dataObject["decision"]!)

        }
     
    }
    func onRedirectBack(){
        DispatchQueue.main.async {
           // UI work here
            self.navigationController?.popToRootViewController(animated: true)

        }

        
    }
    @IBAction func captueACtion(_ sender: Any) {
        
        // Example Usage for FACEKI SDK
        let smManagerVC = Logger.initiateSMSDK(setClientID : "clientid", setClientSecret: "clientSecret", workflowId: "workflowID", setOnComplete:onComplete,redirectBack: onRedirectBack,selfieImageUrl: nil,cardGuideUrl: nil)
        navigationController?.pushViewController(smManagerVC, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

