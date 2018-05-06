//
//  AddAlarmViewController.swift
//  SwissArmyApp
//
//  Created by Christian Persson on 2018-04-27.
//  Copyright © 2018 Christian Persson. All rights reserved.
//

import UIKit

protocol addAlarmDelegate {
    func addAlarm(alarm : Alarm)
}

class AddAlarmViewController: UIViewController {

    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var addAlarmButton: UIButton!
    @IBOutlet weak var alarmTitel: UITextField!
    @IBOutlet weak var alarmBody: UITextField!
  
    var alarm = Alarm()
    var delegate : addAlarmDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func datePicked(_ sender: UIDatePicker) {
        
        alarm.dateAndTimeOfAlarm = sender.date
        print("pickers time and date: \(alarm.dateAndTimeOfAlarm)")
        
    }
    
//    override func touchesBegan(_: Set<UITouch>, with: UIEvent?){
//        alarmTitel.resignFirstResponder()
//    }
    
    @IBAction func addAlarmButton(_ sender: UIButton) {
        print("Selected date: \(alarm.dateAndTimeOfAlarm)")
        let date = Date()
        if (alarm.dateAndTimeOfAlarm) < date {
            let monthsToAdd = 0
            let daysToAdd = 1
            let yearsToAdd = 0
            
            var dateComponent = DateComponents()
            dateComponent.month = monthsToAdd
            dateComponent.day = daysToAdd
            dateComponent.year = yearsToAdd
            
            let newTime = Calendar.current.date(byAdding: dateComponent, to: (alarm.dateAndTimeOfAlarm))
            alarm.dateAndTimeOfAlarm = newTime!
            print("picker value less than current date, new date \(alarm.dateAndTimeOfAlarm)")
        }
//        alarm.title = alarmTitel.text
        delegate?.addAlarm(alarm: alarm)
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}
