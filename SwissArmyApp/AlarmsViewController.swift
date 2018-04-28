//
//  AlarmViewController.swift
//  SwissArmyApp
//
//  Created by Christian Persson on 2018-04-16.
//  Copyright © 2018 Christian Persson. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, addAlarmDelegate, UNUserNotificationCenterDelegate  {

    @IBOutlet weak var addAlarmButton: UIButton!
    @IBOutlet weak var alarmsTableView: UITableView!
    
    var alarms : [Alarm] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alarmsTableView.delegate = self
        alarmsTableView.dataSource = self
        alarmsTableView.reloadData()
        UNUserNotificationCenter.current().delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addAlarm(alarm: Alarm) {
        alarms.append(alarm)
        alarmsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = alarmsTableView.dequeueReusableCell(withIdentifier: "alarmCell")
        cell?.textLabel?.text = "\(alarms[indexPath.row].dateAndTimeOfAlarm)"
        alarms[indexPath.row].alarmIdentifier = indexPath.row
        scheduleNotification(at: alarms[indexPath.row].dateAndTimeOfAlarm, requestIdentifier: alarms[indexPath.row].alarmIdentifier)
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addAlarm" {
            let destinationVC = segue.destination as! AddAlarmViewController
            destinationVC.delegate = self
        }
    }
    
    func scheduleNotification(at date: Date, requestIdentifier: Int) {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Alarm, Alarm, Alarm"
        content.body = "Wake up you lazy MF!"
        content.sound = UNNotificationSound.init(named: "Siren_Noise-KevanGC-1337458893.wav")
        content.categoryIdentifier = "snoozeCategry"
        
        if let path = Bundle.main.path(forResource: "wakeup", ofType: "png") {
            let url = URL(fileURLWithPath: path)
            do {
                let attachment = try UNNotificationAttachment(identifier: "wakeup", url: url, options: nil)
                content.attachments = [attachment]
            } catch {
                print("The attachment was not loaded.")
            }
        }
        let request = UNNotificationRequest(identifier: "alarmNotification\(requestIdentifier)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("We have an error: \(error)")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.badge, .alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "Snooze1" {
            
            let newDate = Date(timeInterval: 300, since: Date())
            print("Nytt alarm satt till \(newDate)")
            scheduleNotification(at: newDate, requestIdentifier: alarms[0].alarmIdentifier)
        }
        if response.actionIdentifier == "Snooze2" {
            let newDate = Date(timeInterval: 600, since: Date())
            print("Nytt alarm satt till \(newDate)")
            scheduleNotification(at: newDate, requestIdentifier: alarms[0].alarmIdentifier)
        }
        if response.actionIdentifier == "Snooze3" {
            let newdate = Date(timeInterval: 60, since: Date())
            print("Nytt alarm satt till \(newdate)")
            scheduleNotification(at: newdate, requestIdentifier: alarms[0].alarmIdentifier)
        }
        completionHandler()
    }
    
    

    



}
