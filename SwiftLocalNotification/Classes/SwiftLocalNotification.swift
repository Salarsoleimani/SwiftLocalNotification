//
//  SwiftLocalNotification.swift
//  SwiftLocalNotification
//
//  Created by Salar Soleimani on 2020-04-01.
//  Copyright © 2020 SaSApps.ca All rights reserved.
//

import UserNotifications
import UIKit

@available(iOS 10.0, *)
public class SwiftLocalNotification: NSObject, SwiftLocalNotificationInterface {
  
  public var permissionStatus: PermissionStatus {
    return permission.status
  }
  
  private let notificationCenter: UNUserNotificationCenter
  private let permission: SwiftLocalNotificationPermission
  
  public init(delegate: UNUserNotificationCenterDelegate? = nil, notificationPermissionOptions: UNAuthorizationOptions = [.alert, .badge, .sound]) {
    self.notificationCenter = UNUserNotificationCenter.current()
    self.notificationCenter.delegate = delegate
    self.permission = SwiftLocalNotificationPermission(options: notificationPermissionOptions)
  }
  
  public init(didRecieveResponse: (@escaping (UNNotificationResponse) -> Void), didRecieveNotificationInApp: (@escaping (UNNotification) -> Void), notificationPermissionOptions: UNAuthorizationOptions = [.alert, .badge, .sound]) {
    self.notificationCenter = UNUserNotificationCenter.current()
    self.notificationDelegate = SwiftLocalNotificationDelegate(didRecieveResponse: didRecieveResponse, didRecieveNotificationInApp: didRecieveNotificationInApp)
    self.notificationCenter.delegate = self.notificationDelegate
    self.permission = SwiftLocalNotificationPermission(options: notificationPermissionOptions)
  }
  
  private var notificationDelegate: SwiftLocalNotificationDelegate?
  
  
  
  public func getAllDeliveredNotifications() -> [SwiftLocalNotificationModel] {
    let semaphore = DispatchSemaphore(value: 0)
    var notifications = [SwiftLocalNotificationModel]()
    
    notificationCenter.getDeliveredNotifications { (notifs) in
      notifications = notifs.map{$0.asSwiftLocalNotification()}
      semaphore.signal()
    }
    _ = semaphore.wait(timeout: .distantFuture)
    return notifications
  }
  
  public func getAllScheduledNotifications() -> [SwiftLocalNotificationModel] {
    let semaphore = DispatchSemaphore(value: 0)
    var notifications = [SwiftLocalNotificationModel]()
    
    notificationCenter.getPendingNotificationRequests { (notifs) in
      notifications = notifs.map{$0.asSwiftLocalNotification()}
      semaphore.signal()
    }
    
    _ = semaphore.wait(timeout: .distantFuture)
    return notifications
  }
  
  public func getDelivered(notificationId id: String) -> SwiftLocalNotificationModel? {
    let allDeliveredNotifications = getAllDeliveredNotifications()
    let notif = allDeliveredNotifications.filter{$0.identifier == id}
    if let notif = notif.first {
      return notif
    }
    return nil
  }
  
  public func getScheduled(notificationId id: String) -> SwiftLocalNotificationModel? {
    let allScheduledNotifications = getAllScheduledNotifications()
    let notifs = allScheduledNotifications.filter{$0.identifier == id}
    if let notif = notifs.first {
      return notif
    }
    return nil
  }
  
  public func getScheduledNotificationsCount() -> Int {
    let semaphore  = DispatchSemaphore(value: 0)
    var count: Int = 0
    
    notificationCenter.getPendingNotificationRequests { (notifs) in
      count = notifs.count
      semaphore.signal()
    }
    
    _ = semaphore.wait(timeout: .distantFuture)
    return count
  }
  
  public func schedule(notification notif: SwiftLocalNotificationModel) -> String? {
    let scheduledNotifCount = getScheduledNotificationsCount()
    if scheduledNotifCount < maximumScheduledNotifications {
      return internalSchedule(notification: notif, trigger: nil)
    }
    return nil
  }
  
  public func reSchedule(notification notif: SwiftLocalNotificationModel) -> String? {
    cancel(notificationIds: notif.identifier ?? "")
    return schedule(notification: notif)
  }
  
  public func scheduleDaily(notifications notif: SwiftLocalNotificationModel, fromTime: Date, toTime: Date, howMany: Int) -> [String]? {
    notif.repeatInterval = .daily
    notif.region = nil
    let todayFromDate = Date.getTodaysDateFor(timeString: fromTime.getTimeString())
    let todayToDate = Date.getTodaysDateFor(timeString: toTime.getTimeString())
    let differenceSeconds = todayToDate.timeIntervalSince(todayFromDate)
    var notifIds: [String]?
    if differenceSeconds > 0 {
      notifIds = [String]()
      let intervalBetween = differenceSeconds / TimeInterval(howMany)
      for i in 0...howMany - 1 {
        notif.fireDate = todayFromDate.addingTimeInterval(intervalBetween * TimeInterval(i))
        let notifId = schedule(notification: notif)
        notifIds!.append(notifId ?? "")
        if i == howMany - 1 {
          return notifIds
        }
      }
    }
    return notifIds
  }
  
  public func scheduleDaily(notifications notifs: [SwiftLocalNotificationModel], fromTime: Date, toTime: Date) -> [String]? {
    let todayFromDate = Date.getTodaysDateFor(timeString: fromTime.getTimeString())
    let todayToDate = Date.getTodaysDateFor(timeString: toTime.getTimeString())
    let differenceSeconds = abs(todayFromDate.timeIntervalSince(todayToDate))
    var notifIds: [String]? = nil
    if differenceSeconds > 0 {
      let intervalBetween = differenceSeconds / TimeInterval(notifs.count)
      var i = 0
      notifIds = [String]()
      for notif in notifs {
        notif.repeatInterval = .daily
        notif.region = nil
        notif.fireDate = todayFromDate.addingTimeInterval(intervalBetween * TimeInterval(i))
        i += 1
        let notifId = schedule(notification: notif)
        notifIds!.append(notifId ?? "")
        if i == notifs.count - 1 {
          return notifIds
        }
      }
    }
    return notifIds
  }
  
  public func schedule(notification notif: SwiftLocalNotificationModel, fromDate: Date, toDate: Date, interval: TimeInterval) -> String? {
    var i = 0
    notif.region = nil
    while fromDate.addingTimeInterval(interval * TimeInterval(i)) < toDate {
      i += 1
      let fireDate = fromDate.addingTimeInterval(interval * TimeInterval(i))
      notif.fireDate = fireDate
      return schedule(notification: notif)
    }
    return nil
  }
  
  public func push(notification notif: SwiftLocalNotificationModel, secondsLater seconds: TimeInterval, repeats: Bool) -> String? {
    notif.region = nil
    notif.fireDate = Date()
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: repeats)
    let scheduledNotifCount = getScheduledNotificationsCount()
    if scheduledNotifCount < maximumScheduledNotifications {
      return internalSchedule(notification: notif, trigger: trigger)
    }
    return nil
  }
  
  public func setApplicationBadge(_ option: BadgeOption, value: Int) {
    switch option {
    case .reset:
      UIApplication.shared.applicationIconBadgeNumber = 0
    case .increase:
      UIApplication.shared.applicationIconBadgeNumber += value
    case .decrease:
      UIApplication.shared.applicationIconBadgeNumber -= value
    }
  }
  public func requestPermission() -> PermissionStatus {
    let semaphore = DispatchSemaphore(value: 0)
    var status: PermissionStatus = .notDetermined
    
    permission.requestNotifications { (newStatus) in
      status = newStatus
    }
    
    _ = semaphore.wait(timeout: .distantFuture)
    return status
  }
  
  public func cancelAllNotifications() {
    notificationCenter.removeAllPendingNotificationRequests()
  }
  
  public func cancel(notificationIds: String...) {
    notificationCenter.removePendingNotificationRequests(withIdentifiers: notificationIds)
  }
  
  public func cancel(notificationIds: [String]) {
    notificationCenter.removePendingNotificationRequests(withIdentifiers: notificationIds)
  }
  
  internal func internalSchedule(notification: SwiftLocalNotificationModel, trigger trig: UNNotificationTrigger?) -> String? {
    var trigger: UNNotificationTrigger
    if let notifRegion = notification.region {
      trigger = UNLocationNotificationTrigger(region: notifRegion, repeats: notification.repeats)
    } else {
      let fireDate = notification.fireDate ?? Date()
      trigger = UNCalendarNotificationTrigger(dateMatching: fireDate.convertToDateComponent(repeatInterval: notification.repeatInterval), repeats: notification.repeats)
    }
    if let trig = trig {
      trigger = trig
    }
    let content = UNMutableNotificationContent()
    content.title = notification.title ?? ""
    content.body = notification.body ?? ""
    content.subtitle = notification.subtitle ?? ""
    
    content.sound = notification.soundName != nil ? UNNotificationSound(named: UNNotificationSoundName( notification.soundName!)) : UNNotificationSound.default
    if !(notification.attachments == nil) { content.attachments = notification.attachments! }
    if !(notification.category == nil) { content.categoryIdentifier = notification.category! }
    content.userInfo = notification.userInfo
    
    notification.localNotificationRequest = UNNotificationRequest(identifier: notification.identifier!, content: content, trigger: trigger)
    
    let semaphore = DispatchSemaphore(value: 0)
    var notificationId: String?
    
    notificationCenter.add(notification.localNotificationRequest!, withCompletionHandler: { (error) in
      if let err = error {
        print("error on setting the local notification\(err)")
        notificationId = nil
        semaphore.signal()
      } else {
        notificationId = notification.identifier
        semaphore.signal()
      }
    })
    _ = semaphore.wait(timeout: .distantFuture)
    return notificationId
  }
}
