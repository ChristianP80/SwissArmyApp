//
//  CompassViewController.swift
//  SwissArmyApp
//
//  Created by Christian Persson on 2018-04-30.
//  Copyright © 2018 Christian Persson. All rights reserved.
//

import UIKit
import CoreLocation

class CompassViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var compassImageView: UIImageView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 1
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingHeading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let rotation: Double = newHeading.magneticHeading * 3.14159 / 180;
        self.compassImageView.transform = CGAffineTransform(rotationAngle: CGFloat(-rotation))
    }

}
