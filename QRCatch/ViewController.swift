//
//  ViewController.swift
//  QRCatch
//
//  Created by Saqib Omer on 18/01/2017.
//  Copyright © 2017 kaboomlab. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, QrCatchedCodeDelegate {
    
    

    // Properties
    @IBOutlet weak var codeLabel: UILabel!

    let qrCatch = QRCatcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if qrCatch.isCameraPermissionGranted() {
            print("Permission Granted")
            qrCatch.startCamera(sourceView: self.view)
            qrCatch.delegate = self
        }
        else {
            
            print("Camera Permission Invalid")
        }
        
        view.bringSubview(toFront: codeLabel)
        codeLabel.text = "No Code Found"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

    // MARK: - QRCatchedCode Delegate
    
    func fetchecodedString(code: String){
        print(code)
        codeLabel.text = code
    }
    

}

