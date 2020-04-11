//
//  UNNotificationRequestExtensions.swift
//  SwiftLocalNotification
//
//  Created by Salar Soleimani on 2020-04-01.
//  Copyright © 2020 SaSApps.ca All rights reserved.
//

import UserNotifications

extension UNNotificationRequest {
  func asSwiftLocalNotification() -> SwiftLocalNotificationModel {
    let id = self.identifier
    let content = self.content
    var fireDate: Date?
    if let trigger = self.trigger as? UNCalendarNotificationTrigger {
      fireDate = trigger.nextTriggerDate()
    }
    if let trigger = self.trigger as? UNTimeIntervalNotificationTrigger {
      fireDate = trigger.nextTriggerDate()
    }
    var repeating: RepeatingInterval = .none
    if let trigger = self.trigger, trigger.repeats, let userInfo = content.userInfo as? [String: String], let repeatingString = userInfo[SwiftLocalNotificationModel.repeatingKey] {
      repeating = RepeatingInterval(rawValue: repeatingString) ?? .none
    }
    let badge = Int(exactly: content.badge ?? 0) ?? 0
    let sasNotif = SwiftLocalNotificationModel(title: content.title, body: content.body, date: fireDate ?? Date(), repeating: repeating, identifier: id, subtitle: content.subtitle, soundName: nil, badge: badge)
    sasNotif.setAllUserInfo(content.userInfo)

    sasNotif.category = content.categoryIdentifier
    return sasNotif
  }
}
