//
//  AlarmViewController.swift
//  SwissArmyApp
//
//  Created by Christian Persson on 2018-04-16.
//  Copyright © 2018 Christian Persson. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController {
    
    @IBOutlet weak var DateAndTimePicker: UIDatePicker!
    @IBOutlet weak var addAlarmButton: UIButton!
    
    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDir = paths.firstObject as! String
        print("Path to the Documents directory\n\(documentsDir)")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPickDateAndTime(_ sender: UIDatePicker) {
        
        selectedDate = sender.date
        
    }
    @IBAction func addButtonPressed(_ sender: UIButton) {
        print("Selected date: \(selectedDate)")
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.scheduleNotification(at: selectedDate)
    }
    

    



}
