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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        
        
        do {
            let input = try AVCaptureDeviceInput.init(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
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
        
        // Start video capture.
        captureSession?.startRunning()
        
        // Move the message label to the top view
        view.bringSubview(toFront: messageLabel)
        view.bringSubview(toFront: scannerLabelView)
        
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
        
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubview(toFront: qrCodeFrameView!)
        
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if let rawQRdata = metadataObj.stringValue {
                let QRdata = rawQRdata.components(separatedBy: ",")
                
                //messageLabel.text = metadataObj.stringValue
                
                
                // check with FIR if embedded code matches any entries
                // code should be embedded with facebook id and some random serial key. Code will go look under the facebook id of the user in the database
                let facebookID: String = QRdata[0]
                let QRSerialKey: String = QRdata[1]
                
                
                DBProvider.Instance.usersRef.child(facebookID).child("Cover").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
                    if let data = snapshot.value as? [String: Any] {
                        if (data["Scanned"] as? Bool) == false {
                            if let FIRserialKey = data["Serial"] as? String {
                                if FIRserialKey == QRSerialKey {
                                    self.messageLabel.text = "Serial Key \(FIRserialKey) confirmed!"
                                    DBProvider.Instance.usersRef.child(facebookID).child("Cover").child("Scanned").setValue(true)
                                    self.showSuccess(name: "Francesco Virga")
                                    
                                }
                                else {
                                    self.showError(status: "QR code does not match")
                                    self.messageLabel.text = "QR code does not match"
                                }
                            }
                        }
                        else {
                            // code has already been scanned
                            self.showError(status: "QR code has already been scanned. Serial Key: \(String(describing: QRSerialKey))")
                            self.messageLabel.text = "QR code has already been scanned. Serial Key: \(String(describing: QRSerialKey))"
                        }
                    }
                }
            }
        }
        
        
    }
    
    func showError(status: String) {
        
        captureSession?.stopRunning()
        SVProgressHUD.setFadeInAnimationDuration(0.3)
        SVProgressHUD.setFadeOutAnimationDuration(0.3)
        SVProgressHUD.showError(withStatus: status)
        SVProgressHUD.dismiss(withDelay: 1.5) {
            self.captureSession?.startRunning()
        }
    }
    
    
    func showSuccess(name: String) {
        
        captureSession?.stopRunning()
        SVProgressHUD.setFadeInAnimationDuration(0.3)
        SVProgressHUD.setFadeOutAnimationDuration(0.3)
        SVProgressHUD.showSuccess(withStatus: "\(name)")
        
        SVProgressHUD.dismiss(withDelay: 1.5) {
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}
