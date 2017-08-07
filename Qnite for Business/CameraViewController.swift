//
//  CameraViewController.swift
//  Qnite for Business
//
//  Created by Francesco Virga on 2017-06-27.
//  Copyright © 2017 Francesco Virga. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase
import SVProgressHUD

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var scannerLabelView: UIView!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var venue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        if let venueName = FacebookUser.Instance.pageName {
            self.venue = venueName
        }
        
        initScanner()
        captureSession?.startRunning()
        view.bringSubview(toFront: messageLabel)
        view.bringSubview(toFront: scannerLabelView)
        initQRframe()
        
    }
    
    func initScanner() {
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        do {
            let input = try AVCaptureDeviceInput.init(device: captureDevice)
            captureSession = AVCaptureSession() // Initialize the captureSession object
            captureSession?.addInput(input) // Set the input device on the capture session
        }
        catch {
            print(error)
        }
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
    }
    
    func initQRframe() {
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubview(toFront: qrCodeFrameView!)
    }
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code detected"
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject // Get the metadata object.
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if let rawQRdata = metadataObj.stringValue {
                let QRdata = rawQRdata.components(separatedBy: ",")
                let facebookID: String = QRdata[0]
                let QRSerialKey: String = QRdata[1]
                
                // Compare QR data with Firebase and show appropriate messages
            
                DBProvider.Instance.eventRef.child(FacebookUser.Instance.pageId!).child(Constants.Instance.getDateInDBFormat()).child(FIR_EVENT_DATA.USERS_ATTENDING).child(facebookID).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
   
                    if let data = snapshot.value as? [String: Any] {
                        if (data[FIR_EVENT_DATA.DID_SCAN] as? Bool) == false {
                            self.captureSession?.stopRunning()
                            
                            //start activity indicator
                            
                            if let FIRserialKey = data[FIR_EVENT_DATA.COVER_ID] as? String {
                                if FIRserialKey == QRSerialKey {
                                    self.messageLabel.text = FIRserialKey
                                    
                                    DBProvider.Instance.eventRef.child(FacebookUser.Instance.pageId!).child(Constants.Instance.getDateInDBFormat()).child(FIR_EVENT_DATA.USERS_ATTENDING).child(facebookID).child(FIR_EVENT_DATA.DID_SCAN).setValue(true)
                                    
                                    DBProvider.Instance.usersRef.child(facebookID).child("name").observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
                                        
                                        
                                        
                                        if let name = snapshot.value as? String {
                                            self.showSuccess(name: name)
                                        }
                                        else {
                                            self.showSuccess(name: "No name found")
                                        }
                                    }) 
                                }
                                else { // code does not match
                                    self.showError(status: "QR code does not have a valid match")
                                }
                            }
                        }
                        else {
                            // code has already been scanned
                            self.showError(status: "QR code has already been used")
                        }
                        
                        
                    }
                }
            }
        }
        
        
    }
    
    func showError(status: String) {
        
        // stop activity indicator
        
        self.messageLabel.text = "QR code has already been used"
        captureSession?.stopRunning()
        SVProgressHUD.setFadeInAnimationDuration(0.2)
        SVProgressHUD.setFadeOutAnimationDuration(0.2)
        SVProgressHUD.showError(withStatus: status)
        SVProgressHUD.dismiss(withDelay: 1) {
            self.qrCodeFrameView?.frame = CGRect.zero
            self.messageLabel.text = "No QR code detected"
            self.captureSession?.startRunning()
        }
    }
    
    func showSuccess(name: String) {
        
        // stop activity indicator
        
        SVProgressHUD.setFadeInAnimationDuration(0.2)
        SVProgressHUD.setFadeOutAnimationDuration(0.2)
        SVProgressHUD.showSuccess(withStatus: "\(name)")
        SVProgressHUD.dismiss(withDelay: 1) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
