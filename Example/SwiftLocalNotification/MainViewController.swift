//
//  ViewController.swift
//  SwiftLocalNotification
//
//  Created by salarsoleimani on 04/11/2020.
//  Copyright (c) 2020 salarsoleimani. All rights reserved.
//

import UIKit
import SwiftLocalNotification

class MainViewController: UIViewController {
  
  @IBOutlet weak var notificationsTableView: UITableView!

  // Sample location base notification
  // You should turn on the background mode capabality for location
  // Also you should get the user location permission for this
  let sampleLocationNotification = SwiftLocalNotificationModel(identifier: UUID().uuidString, title: "locationTest", body: "Test body", subtitle: "Test subtitle", region: nil, notifyOnExit: true, notifyOnEntry: true, soundName: nil, badge: 10, repeats: true)
  
  // Sample notification with soundName (just drag and drop your sound to project and write it here with the extention for example: "sound.mp3") and badge (default badge is 1)
  let sampleNotification = SwiftLocalNotificationModel(title: "asd", body: "asd", subtitle: nil, date: Date().addingTimeInterval(6), repeating: .none, identifier: "", soundName: nil, badge: 5)
  
  var localNotificationScheduler: SwiftLocalNotification!
  var notifications = [SwiftLocalNotificationModel]() {
    didSet {
      notificationsTableView.reloadData()
    }
  }
  lazy var formatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "HH:mm:ss"
    return df
  }()
  let cellId = "cellId"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    localNotificationScheduler = SwiftLocalNotification(delegate: self, notificationPermissionOptions: nil)
    notificationsTableView.dataSource = self
    notificationsTableView.delegate = self
    notificationsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    notifications = localNotificationScheduler.getAllScheduledNotifications()
  }
  
  @IBAction func requestButtonPressed(_ sender: Any) {
    localNotificationScheduler.requestPermission { (permission) in
      switch permission {
        case .authorized: print("authorized")
        case .denied: print("denied")
        case .disabled: print("disabled")
        case .notDetermined: print("notDetermined")
      }
    }
  }
  @IBAction func scheduleSampleNotificationButtonPressed(_ sender: Any) {
    // handle the actions in UNUserNotificationCenterDelegate
    let sampleNot = SwiftLocalNotificationModel(title: "testsimple", body: "testSimple", date: Date().next(seconds: 6), repeating: .minute)
    let snoozeAction = UNNotificationAction(identifier: "snoozeAction", title: "Snooze in 2 minutes", options: [.authenticationRequired, .foreground])
    let category = SwiftLocalNotificationCategory(categoryIdentifier: "snooze", actions: [snoozeAction])
    category.set(forNotifications: sampleNot)

    // if result is not nil then notification is scheduled correctly
    _ = localNotificationScheduler.schedule(notification: sampleNot)
    notifications = localNotificationScheduler.getAllScheduledNotifications()
  }
  @IBAction func scheduleDailyNotificationButtonPressed(_ sender: Any) {
    // if result is not nil then notification is scheduled correctly
    _ = localNotificationScheduler.scheduleDaily(notifications: sampleNotification, fromTime: Date(), toTime: Date().next(minutes: 1), howMany: 20)
    notifications = localNotificationScheduler.getAllScheduledNotifications()
  }
  @IBAction func scheduleNotificationsButtonPressed(_ sender: Any) {
    let sampleNotification1 = SwiftLocalNotificationModel(title: "testSimple1", body: "testSimple1", date: Date(), repeating: .daily)
    let sampleNotification2 = SwiftLocalNotificationModel(title: "testSimple2", body: "testSimple2", date: Date(), repeating: .daily)
    
    _ = localNotificationScheduler.scheduleDaily(notifications: [sampleNotification1, sampleNotification2], fromTime: Date().next(seconds: 1), toTime: Date().next(minutes: 2))
    notifications = localNotificationScheduler.getAllScheduledNotifications()
  }
  @IBAction func cancelAllNotificationButtonPressed(_ sender: Any) {
    localNotificationScheduler.cancelAllNotifications()
    notifications = localNotificationScheduler.getAllScheduledNotifications()
  }
}

extension MainViewController: UNUserNotificationCenterDelegate {
  // handle the notification actions here
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    if response.actionIdentifier == "snoozeAction" {
      print("snooze action clicked for notification \(response.notification.asSwiftLocalNotification().identifier)")
    }
  }
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    print("did recieve notification in the app ")
    notifications = localNotificationScheduler.getAllScheduledNotifications()
  }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notifications.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    cell.textLabel?.text = notifications[indexPath.row].identifier
    if let date = notifications[indexPath.row].userInfo[SwiftLocalNotificationModel.dateKey] as? Date {
      cell.detailTextLabel?.text = formatter.string(from: date)
    }
    return cell
  }
}
