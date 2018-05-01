//
//  CompassViewController.swift
//  SwissArmyApp
//
//  Created by Christian Persson on 2018-04-30.
//  Copyright © 2018 Christian Persson. All rights reserved.
//

import UIKit
import CoreLocation
import AudioToolbox

class CompassViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var compassImageView: UIImageView!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countyLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var cityName : String?
    var countyName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 1
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingHeading()
        
        if CLLocationManager.locationServicesEnabled()
        {
            switch(CLLocationManager.authorizationStatus())
            {
            case .authorizedAlways, .authorizedWhenInUse:
                print("Authorized.")
                let latitude: CLLocationDegrees = (locationManager.location?.coordinate.latitude)!
                let longitude: CLLocationDegrees = (locationManager.location?.coordinate.longitude)!
                let location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                    if error != nil {
                        return
                    } else if let country = placemarks?.first?.country,
                        let city = placemarks?.first?.locality,
                        let county = placemarks?.first?.administrativeArea{
                        print(country)
                        print(county)
                        self.cityName = city
                        self.cityLabel.text = self.cityName
                        self.countyName = county
                        self.countyLabel.text = self.countyName
                    }
                    else {
                    }
                })
                break
            case .notDetermined:
                print("Not determined.")
                break
                
            case .restricted:
                print("Restricted.")
                break
            case .denied:
                print("Denied.")
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        UIView.animate(withDuration: 0.5) {
            let rotation: Double = newHeading.magneticHeading * 3.14159 / 180;
            let latitude = (self.locationManager.location?.coordinate.latitude)!
            let longitude = (self.locationManager.location?.coordinate.longitude)!
            let altitude = (self.locationManager.location?.altitude)!
            self.degreeLabel.text = "\(Int(newHeading.magneticHeading))°"
            self.latitudeLabel.text = "\(latitude)"
            self.longitudeLabel.text = "\(longitude)"
            self.altitudeLabel.text = "\(Int(altitude)) meters höjd"
            self.compassImageView.transform = CGAffineTransform(rotationAngle: CGFloat(-rotation))
            
            if Int(newHeading.magneticHeading) == 0 ||
                Int(newHeading.magneticHeading) == 90 ||
                Int(newHeading.magneticHeading) == 180 ||
                Int(newHeading.magneticHeading) == 270{
                self.vibrate()
            }
        }
    }
    
    func vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}

