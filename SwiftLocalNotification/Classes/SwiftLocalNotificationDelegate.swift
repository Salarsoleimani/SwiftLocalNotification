//
//  SwiftLocalNotificationDelegate.swift
//  SwiftLocalNotification
//
//  Created by Salar Soleimani on 2020-04-03.
//  Copyright © 2020 SaSApps.ca All rights reserved.
//

import UserNotifications

class SwiftLocalNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
  let didRecieveResponse: (UNNotificationResponse) -> Void
  let didRecieveNotificationInApp: (UNNotification) -> Void

  init(didRecieveResponse: (@escaping (UNNotificationResponse) -> Void), didRecieveNotificationInApp: (@escaping (UNNotification) -> Void)) {
    self.didRecieveResponse = didRecieveResponse
    self.didRecieveNotificationInApp = didRecieveNotificationInApp
  }
  
  public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    didRecieveResponse(response)
  }
  public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    didRecieveNotificationInApp(notification)
  }
}
