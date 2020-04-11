//
//  SwiftLocalNotificationInterface.swift
//  SwiftLocalNotification
//
//  Created by Salar Soleimani on 2020-04-03.
//  Copyright © 2020 SaSApps.ca All rights reserved.
//

import Foundation

public protocol SwiftLocalNotificationInterface {
  var permissionStatus: PermissionStatus { get }
  
  func requestPermission() -> PermissionStatus

  func getAllScheduledNotifications() -> [SwiftLocalNotificationModel]
  func getAllDeliveredNotifications() -> [SwiftLocalNotificationModel]
  func getScheduled(notificationId id: String) -> SwiftLocalNotificationModel?
  func getDelivered(notificationId id: String) -> SwiftLocalNotificationModel?
  func getScheduledNotificationsCount() -> Int
  
  func schedule(notification notif: SwiftLocalNotificationModel) -> String?
  func reSchedule(notification notif: SwiftLocalNotificationModel) -> String?
  func scheduleDaily(notifications notif: SwiftLocalNotificationModel, fromTime: Date, toTime: Date, howMany: Int) -> [String]?
  func scheduleDaily(notifications notifs: [SwiftLocalNotificationModel], fromTime: Date, toTime: Date) -> [String]?
  func schedule(notification notif: SwiftLocalNotificationModel, fromDate: Date, toDate: Date, interval: TimeInterval) -> String?
  func push(notification notif: SwiftLocalNotificationModel, secondsLater seconds: TimeInterval, repeats: Bool) -> String?
    
  func setApplicationBadge(_ option: BadgeOption, value: Int)
    
  func cancelAllNotifications()
  func cancel(notificationIds: String...)
  func cancel(notificationIds: [String])
}
