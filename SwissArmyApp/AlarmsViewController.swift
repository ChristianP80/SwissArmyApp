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
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alarmsTableView.delegate = self
        alarmsTableView.dataSource = self
        alarmsTableView.reloadData()
        UNUserNotificationCenter.current().delegate = self
        loadAlarms()
        animateAlarmTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animateAlarmTable()
        loadAlarms()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addAlarm(alarm: Alarm) {
        alarms.append(alarm)
        saveAlarms()
        alarmsTableView.reloadData()
    }
    
    func saveAlarms() {
        try! defaults.set(PropertyListEncoder().encode(alarms), forKey: "savedAlarms")
    }
    
    func loadAlarms() {

        if let data = defaults.object(forKey: "savedAlarms") as? Data {
            if let alarmsList = try? PropertyListDecoder().decode([Alarm].self, from: data){
                alarms = alarmsList
            }
        }
        print("View did load:")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = alarmsTableView.dequeueReusableCell(withIdentifier: "alarmCell") as! AlarmTableViewCell
        cell.cellView.layer.cornerRadius = (cell.frame.height) / 3
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateToTime = dateFormatter.string(from: alarms[indexPath.row].dateAndTimeOfAlarm)
        cell.cellLabel.text = "\(dateToTime)"
        alarms[indexPath.row].alarmIdentifier = indexPath.row
        scheduleNotification(at: alarms[indexPath.row].dateAndTimeOfAlarm, requestIdentifier: alarms[indexPath.row].alarmIdentifier)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["alarmNotification\(alarms[indexPath.row].alarmIdentifier)"])
            alarms.remove(at: indexPath.row)
            alarmsTableView.deleteRows(at: [indexPath], with: .fade)
        }
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
        
        completionHandler([.alert, .sound])
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
             //let alarm = response.notification.request.content.userInfo["theAlarm"]
            scheduleNotification(at: newDate, requestIdentifier: alarms[0].alarmIdentifier)
        }
        if response.actionIdentifier == "Snooze3" {
            let newdate = Date(timeInterval: 60, since: Date())
            print("Nytt alarm satt till \(newdate)")
            scheduleNotification(at: newdate, requestIdentifier: alarms[0].alarmIdentifier)
        }
        completionHandler()
    }
    
    func animateAlarmTable() {
        alarmsTableView.reloadData()
        
        let cells = alarmsTableView.visibleCells
        let tableHeight: CGFloat = alarmsTableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for cell in cells {
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
}
