//
//  RepeatingInterval.swift
//  SwiftLocalNotification
//
//  Created by Salar Soleimani on 2020-04-01.
//  Copyright © 2020 SaSApps.ca All rights reserved.
//

import Foundation

let maximumScheduledNotifications = 64

// UserDefaults for authorizing permission
struct Defaults {
  @UserDefault("permission.requestedNotifications", defaultValue: false)
  static var requestedNotifications: Bool
}
