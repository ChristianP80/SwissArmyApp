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
    
    override func viewDidDisappear(_ animated: Bool) {
        locationManager.stopUpdatingHeading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.startUpdatingHeading()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        UIView.animate(withDuration: 0.5) {
            let rotation: Double = newHeading.magneticHeading * 3.14159 / 180;
            let latitude = (self.locationManager.location?.coordinate.latitude)!
            let longitude = (self.locationManager.location?.coordinate.longitude)!
            let dms = self.coordinatesToDMS(latitude: latitude, longitude: longitude)
            let altitude = (self.locationManager.location?.altitude)!
            self.degreeLabel.text = "\(Int(newHeading.magneticHeading))°"
            self.latitudeLabel.text = "\(dms.latitude)"
            self.longitudeLabel.text = "\(dms.longitude)"
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
    
    func coordinatesToDMS(latitude: Double, longitude: Double) -> (latitude: String, longitude: String) {
        let latDegrees = abs(Int(latitude))
        let latMinutes = abs(Int((latitude * 3600).truncatingRemainder(dividingBy: 3600) / 60))
        let latSeconds = Double(abs((latitude * 3600).truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60)))
        
        let lonDegrees = abs(Int(longitude))
        let lonMinutes = abs(Int((longitude * 3600).truncatingRemainder(dividingBy: 3600) / 60))
        let lonSeconds = Double(abs((longitude * 3600).truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60) ))
        
        return (String(format:"%d° %d' %.2f\" %@", latDegrees, latMinutes, latSeconds, latitude >= 0 ? "N" : "S"),
                String(format:"%d° %d' %.2f\" %@", lonDegrees, lonMinutes, lonSeconds, longitude >= 0 ? "E" : "W"))
    }
}

