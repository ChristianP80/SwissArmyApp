//
//  FlashlightViewController.swift
//  SwissArmyApp
//
//  Created by Christian Persson on 2018-04-15.
//  Copyright © 2018 Christian Persson. All rights reserved.
//

import UIKit
import AVFoundation

class FlashlightViewController: UIViewController {

    @IBOutlet weak var flashlightSlider: UISlider!
    
    var device = AVCaptureDevice.default(for: AVMediaType.video)
    var flashLightOn : Bool = false
    var currentValue : Float = 0.0
    var roundedValue : Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        flashLightOn = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func flashlightSliderChanged(_ sender: UISlider) {
        
        currentValue = Float(sender.value)
        
        if (currentValue >= 0.1) {
            flashLightOn = true
            let twoDecimalValue = (String(format: "%.1f", currentValue))
            print(twoDecimalValue)
            roundedValue = (twoDecimalValue as NSString).floatValue
            
            print("torchValue = \(roundedValue)")
            setFlashStrength(lightStrength: roundedValue)
        } else {
            flashLightOn = false
            setFlashStrength(lightStrength: 0.0)
        }
        

        
    }
    
    func setFlashStrength(lightStrength : Float) {
     
        if((device) != nil){
            if((device?.hasFlash)! && (device?.hasTorch)!){
                if flashLightOn {
                    do {
                        try device?.lockForConfiguration()
                        try device?.setTorchModeOn(level: lightStrength)
                        device?.unlockForConfiguration()
                        print("Activated Torch")
                    }
                    catch {
                        print(error)
                    }
                } else {
                    do {
                        print("krashar här")
                        try device?.lockForConfiguration()
                        device?.torchMode = .off
                        device?.unlockForConfiguration()
                        print("Deactivated Torch")
                    }
                    catch {
                        print(error)
                    }
                }
            } else {
                
                //noFlashAvailable()
            }
        } else {
            //noFlashAvailable()
        }

    }
    
    
}
