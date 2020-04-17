//
//  UNNotificationRequestExtensions.swift
//  SwiftLocalNotification
//
//  Created by Salar Soleimani on 2020-04-01.
//  Copyright © 2020 SaSApps.ca All rights reserved.
//

import UserNotifications

public extension UNNotificationRequest {
  func asSwiftLocalNotification() -> SwiftLocalNotificationModel {
    let id = self.identifier
    let content = self.content
    var fireDate: Date?
    if let date = content.userInfo[SwiftLocalNotificationModel.dateKey] as? Date {
      fireDate = date
    }
    var repeating: RepeatingInterval = .none
    if let repeatingString = content.userInfo[SwiftLocalNotificationModel.repeatingKey] as? String {
      repeating = RepeatingInterval(rawValue: repeatingString) ?? .none
    }
    let badge = Int(exactly: content.badge ?? 0) ?? 0
    var soundName: String?
    if let soundNameString = content.userInfo[SwiftLocalNotificationModel.soundNameKey] as? String {
      soundName = soundNameString != "" ? soundNameString : nil
    }
    let sasNotif = SwiftLocalNotificationModel(title: content.title, body: content.body, subtitle: content.subtitle, date: fireDate ?? Date(), repeating: repeating, identifier: id, soundName: soundName, badge: badge)
    sasNotif.setAllUserInfo(content.userInfo)
    sasNotif.category = content.categoryIdentifier
    return sasNotif
  }
}
