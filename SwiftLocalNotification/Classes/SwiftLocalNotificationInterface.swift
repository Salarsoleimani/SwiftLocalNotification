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
  
  func requestPermission(completion: @escaping (PermissionStatus) -> Void)

  func getAllScheduledNotifications() -> [SwiftLocalNotificationModel]
  func getAllDeliveredNotifications() -> [SwiftLocalNotificationModel]
  func getScheduled(notificationId id: String) -> SwiftLocalNotificationModel?
  func getDelivered(notificationId id: String) -> SwiftLocalNotificationModel?
  func getScheduledNotificationsCount() -> Int
  
  func schedule(notification notif: SwiftLocalNotificationModel) -> String?
  // edit the existing notification
  func reSchedule(notification notif: SwiftLocalNotificationModel) -> String?
  // schedule one daily notification from a specific time for example "08:00" to a specific time and determine to how many times user get the notification
  func scheduleDaily(notifications notif: SwiftLocalNotificationModel, fromTime: Date, toTime: Date, howMany: Int) -> [String]?
  // schedule set of notifications between two specific dates
  func scheduleDaily(notifications notifs: [SwiftLocalNotificationModel], fromTime: Date, toTime: Date) -> [String]?
  // schedule a notification between two specific dates by adding interval after from date
  func schedule(notification notif: SwiftLocalNotificationModel, fromDate: Date, toDate: Date, interval: TimeInterval) -> String?
  // simple push notification
  func push(notification notif: SwiftLocalNotificationModel, secondsLater seconds: TimeInterval) -> String?
  // set the badge of application
  func setApplicationBadge(_ option: BadgeOption, value: Int)
    
  func cancelAllNotifications()
  func cancel(notificationIds: String...)
  func cancel(notificationIds: [String])
}
