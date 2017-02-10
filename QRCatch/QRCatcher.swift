//
//  QRCatcher.swift
//  QRCatch
//
//  Created by Saqib Omer on 09/02/2017.
//  Copyright © 2017 kaboomlab. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

protocol QrCatchedCodeDelegate: class {
    func fetchecodedString(code : String)
}


class QRCatcher: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
//    var isPermissionGranted : Bool!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    let cameraMediaType = AVMediaTypeVideo
    
    // Supported Code Types
    let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypePDF417Code,
                              AVMetadataObjectTypeQRCode]
    
    // QrCatcher Delegate
    
    weak var delegate:QrCatchedCodeDelegate?
    
    var catchedCode = ""
    
    // MARK: - Check for Camera Permission
    
    func isCameraPermissionGranted() -> Bool {
        
        
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: cameraMediaType)
        
        var status = false
        
        switch cameraAuthorizationStatus {
        case .denied: status = false
        case .authorized: status = true
        case .restricted: status = false
            
        case .notDetermined: AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { response in
                if response {
                    status = true
                    
                } else {
                    status = false
                
                }
            }
        }
        
        return status
    }
    
    
    
    // MARK: - Start Capturing
    
    func  startCamera(sourceView : UIView) {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = sourceView.layer.bounds
            sourceView.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                sourceView.addSubview(qrCodeFrameView)
                sourceView.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate Methods
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            catchedCode =  "No Code Found"
            delegate?.fetchecodedString(code: catchedCode)
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                catchedCode =  metadataObj.stringValue
                delegate?.fetchecodedString(code: catchedCode)
                
            }
        }
    }
    
    
    
}
