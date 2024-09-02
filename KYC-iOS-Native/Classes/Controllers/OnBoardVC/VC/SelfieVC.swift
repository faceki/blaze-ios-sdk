//
//  SelfieVC.swift
//  ScanDocument
//
//

import UIKit
import AVFoundation
import AudioToolbox

class SelfieVC: UIViewController, AVCapturePhotoCaptureDelegate {
    
    //MARK: -Instance Method
    class func selfieVc() -> SelfieVC {
        return UIStoryboard(name: "MainFACEKI", bundle: frameworkImageBundle).instantiateViewController(withIdentifier: "SelfieVC") as! SelfieVC
    }
    
    //MARK: -Outlets
    @IBOutlet weak var overLayView: UIView!
    @IBOutlet weak var overLayView2: UIView!
    @IBOutlet weak var captureView: UIView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var safeAreaView : UIView!
    @IBOutlet weak var overlayImage : UIImageView!
    
    
    
    // MARK: - Properties
    var idCardFrontImg : UIImage?
    var idCardBackImg : UIImage?
    var passportFrontImg : UIImage?
    var drivingLicenseFrontImg : UIImage?
    var drivingLicenseBackImg : UIImage?
    
    var model : ResultModel?
    var imagesData : [(imageName: String, imageData: Data)]?
    var isCardSelected : Bool?
    var isPassportSelected : Bool?
    var isDrivingLicenseSelected : Bool?
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice: AVCaptureDevice?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    //MARK: -lifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                   overrideUserInterfaceStyle = .light
               }
        self.configureCam()
        navigationController?.navigationBar.isHidden = true
        
    }
    
    //MARK: -Actions
    @IBAction private func didTapBack(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        stopActivityIndicator()
        if let imageData = photo.fileDataRepresentation() {
            if let capturedImage = UIImage(data: imageData) {
                
                /// ToDO
                if let selfieImgData = capturedImage.convertImageToJPEGData() {
                    
                    if (self.model?.document_optional ?? false) {
                        var docFrontData : Data?
                        var docBackData : Data?
                        
                        if self.isCardSelected ?? false,
                           let idCardFrontImgData = self.idCardFrontImg?.scale(newWidth: 640).convertImageToJPEGData(),
                           let idCardBackImgData = self.idCardBackImg?.scale(newWidth: 640).convertImageToJPEGData() {
                            docFrontData = idCardFrontImgData
                            docBackData = idCardBackImgData
                        } else if self.isPassportSelected ?? false,
                                  let passportFrontImgData = self.passportFrontImg?.scale(newWidth: 640).convertImageToJPEGData() {
                            docFrontData = passportFrontImgData
                            docBackData = passportFrontImgData
                        } else if self.isDrivingLicenseSelected ?? false,
                                  let drivingLicenseFrontImgData = self.drivingLicenseFrontImg?.scale(newWidth: 640).convertImageToJPEGData(),
                                  let drivingLicenseBackImgData = self.drivingLicenseBackImg?.scale(newWidth: 640).convertImageToJPEGData() {
                            docFrontData = drivingLicenseFrontImgData
                            docBackData = drivingLicenseBackImgData
                        }
                        guard let docBackData,
                              let docFrontData else {return}
                        self.imagesData = [
                            (imageName: "selfie", imageData: selfieImgData),
                            (imageName: "document_1_front", imageData: docFrontData),
                            (imageName: "document_1_back", imageData: docBackData)
                        ]
                        
                    } else {
                        if let selfieImgData = capturedImage.convertImageToJPEGData() {
                            self.imagesData = [(imageName: "selfie", imageData: selfieImgData)]
//                            if self.isTypeAllowed(type: .idCard),
//                               let idCardFrontImgData = self.idCardFrontImg?.scale(newWidth: 640).convertImageToJPEGData(),
//                               let idCardBackImgData = self.idCardBackImg?.scale(newWidth: 640).convertImageToJPEGData() {
//                                self.imagesData?.append(contentsOf: [(imageName: "document_1_front", imageData: idCardFrontImgData),
//                                                                     (imageName: "document_1_back", imageData: idCardBackImgData)])
//                            }
//                            if self.isTypeAllowed(type: .passport),
//                               let passportFrontImgData = self.passportFrontImg?.scale(newWidth: 640).convertImageToJPEGData() {
//                                self.imagesData?.append(contentsOf: [(imageName: "document_2_front", imageData: passportFrontImgData),
//                                                                     (imageName: "document_2_back", imageData: passportFrontImgData)])
//                            }
//                            if self.isTypeAllowed(type: .drivingLicense),
//                               let drivingLicenseFrontImgData = self.drivingLicenseFrontImg?.scale(newWidth: 640).convertImageToJPEGData(),
//                               let drivingLicenseBackImgData = self.drivingLicenseBackImg?.scale(newWidth: 640).convertImageToJPEGData(){
//                                self.imagesData?.append(contentsOf: [(imageName: "document_3_front", imageData: drivingLicenseFrontImgData),
//                                                                     (imageName: "document_3_back", imageData: drivingLicenseBackImgData)])
//                            }
                            
                            var imagesByType: [DocumentType: [(imageName: String, imageData: Data)]] = [:]

                            if self.isTypeAllowed(type: .idCard),
                               let idCardFrontImgData = self.idCardFrontImg?.scale(newWidth: 640).convertImageToJPEGData(),
                               let idCardBackImgData = self.idCardBackImg?.scale(newWidth: 640).convertImageToJPEGData() {
                                   imagesByType[.idCard] = [
                                       (imageName: "idCard_front", imageData: idCardFrontImgData),
                                       (imageName: "idCard_back", imageData: idCardBackImgData)
                                   ]
                            }

                            if self.isTypeAllowed(type: .passport),
                               let passportFrontImgData = self.passportFrontImg?.scale(newWidth: 640).convertImageToJPEGData() {
                                   imagesByType[.passport] = [
                                       (imageName: "passport_front", imageData: passportFrontImgData),
                                       (imageName: "passport_back", imageData: passportFrontImgData)
                                   ]
                            }

                            if self.isTypeAllowed(type: .drivingLicense),
                               let drivingLicenseFrontImgData = self.drivingLicenseFrontImg?.scale(newWidth: 640).convertImageToJPEGData(),
                               let drivingLicenseBackImgData = self.drivingLicenseBackImg?.scale(newWidth: 640).convertImageToJPEGData() {
                                   imagesByType[.drivingLicense] = [
                                       (imageName: "drivingLicense_front", imageData: drivingLicenseFrontImgData),
                                       (imageName: "drivingLicense_back", imageData: drivingLicenseBackImgData)
                                   ]
                            }
                            for (index, (documentType, images)) in imagesByType.enumerated() {
                                print("Index: \(index)")
                                print("Document Type: \(documentType)")

                                for (imageName, imageData) in images {
                                    print("  Image Name: \(imageName)")
                                                  
                                    if imageName.contains("back") {
                                        print("    This image contains 'back'")
                                        self.imagesData?.append(contentsOf: [
                                            (imageName: "document_\(index + 1)_back", imageData: imageData)
                                        ])
                                    }else{
                                        
                                        self.imagesData?.append(contentsOf: [
                                            (imageName: "document_\(index + 1)_front", imageData: imageData)
                                        ])    
                                        
                                        
                                        
                                    }
                                    // Use imageData as needed (e.g., upload to server, display in UI, etc.)
                                }
                            }

               
                            
                            
                        }
                    }
                }
                
                let vc = ResultVC.resultVc()
                vc.imagesData = self.imagesData
                vc.model = self.model
                self.navigationController?.pushViewController(vc, animated: true)

            }
        }
    }
    
    func isTypeAllowed(type: DocumentType) -> Bool {
            return self.model?.documents.contains(type.rawValue) == true
        }
    
    private func configureDevice() {
        let _: NSErrorPointer = nil
        if let device = captureDevice {
            do {
                try captureDevice!.lockForConfiguration()
                
            } catch _ as NSError {
            }
            
            device.unlockForConfiguration()
        }
        
    }
    
    private func beginSession() {
        configureDevice()
        var err: NSError? = nil
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession.addInput(deviceInput)
        } catch let error as NSError {
            err = error
        }
        
        if err != nil {
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.frame = view.layer.bounds
        
        view.layer.addSublayer(previewLayer!)
        
        overLayView.frame = view.layer.bounds
        overLayView2.frame = view.layer.bounds
        safeAreaView.frame = view.layer.bounds
        overlayImage.frame = view.layer.bounds
        
        view.addSubview(overlayImage)
        view.addSubview(overLayView)
        view.addSubview(overLayView2)
        view.addSubview(safeAreaView)

        
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
    }
    
    @IBAction func capturePhoto(_ sender : UIButton) {
        DispatchQueue.main.async {[weak self] in
            guard let self else { return}
            startActivityIndicator(style: .large)
        }
        
        guard let capturePhotoOutput = capturePhotoOutput else { return }
        
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.flashMode = .auto
        
        if let videoConnection = capturePhotoOutput.connection(with: .video) {
            capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
        } else {
            print("No active and enabled video connection")
        }
    }
    
    private func configureCam() {
        capturePhotoOutput = AVCapturePhotoOutput()
        
        if let capturePhotoOutput = capturePhotoOutput {
            if captureSession.canAddOutput(capturePhotoOutput) {
                captureSession.addOutput(capturePhotoOutput)
            }
        }
        
        captureSession.sessionPreset = AVCaptureSession.Preset.photo  // Updated for iOS 15
        
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front)
        let devices = discoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.front {
                captureDevice = device
                if captureDevice != nil {
                    print("Capture device found")
                    beginSession()
                }
            }
        }
    }
    
}

extension UIImage {
    func convertImageToJPEGData() -> Data? {
        return self.jpegData(compressionQuality: 0.8)
    }
}
