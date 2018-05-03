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
    @IBOutlet weak var torchOnOffSwitch: UISwitch!
    
    var device = AVCaptureDevice.default(for: AVMediaType.video)
    var flashLightOn : Bool = false
    var currentValue : Float = 0.0
    var roundedValue : Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        torchOnOffSwitch.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)

        flashLightOn = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func torchOnOffChanged(_ sender: UISwitch) {
        
        if torchOnOffSwitch.isOn == false {
            flashLightOn = false
            setFlashStrength(lightStrength: 0.0)
            flashlightSlider.value = 0
        } else {
            flashLightOn = true
            setFlashStrength(lightStrength: 1)
            flashlightSlider.value = 1
        }
    }
    
    @IBAction func flashlightSliderChanged(_ sender: UISlider) {
        
        currentValue = Float(sender.value)
        
        if (currentValue >= 0.1) {
            flashLightOn = true
            torchOnOffSwitch.isOn = true
            let twoDecimalValue = (String(format: "%.1f", currentValue))
            print(twoDecimalValue)
            roundedValue = (twoDecimalValue as NSString).floatValue
            
            print("torchValue = \(roundedValue)")
            setFlashStrength(lightStrength: roundedValue)
        } else {
            flashLightOn = false
            setFlashStrength(lightStrength: 0.0)
            torchOnOffSwitch.isOn = false
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
                        print("crash!!!")
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
                flashNotSupported()
            }
        } else {
            flashNotSupported()
        }
    }
    
    func flashNotSupported() {
        
        let alert = UIAlertController(title: "Unsupported Device", message: "Torch/flash is not supported on this device!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
