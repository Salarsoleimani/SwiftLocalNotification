//
//  SwiftLocalNotificationPermission.swift
//  SwiftLocalNotification
//
//  Created by Salar Soleimani on 2020-04-01.
//  Copyright © 2020 SaSApps.ca All rights reserved.
//

import UserNotifications

final class SwiftLocalNotificationPermission {
  private let options: UNAuthorizationOptions
  
  public init(options: UNAuthorizationOptions) {
    self.options = options
  }
  
  public typealias Callback = (PermissionStatus) -> Void
  
  /// The permission status.
  public var status: PermissionStatus {
    return statusNotifications
  }
  var statusNotifications: PermissionStatus {
    if Defaults.requestedNotifications {
      return synchronousStatusNotifications
    }
    
    return .notDetermined
  }
  var callback: Callback?
  
  func callbacks(_ with: PermissionStatus) {
    DispatchQueue.main.async { [callback, status] in
      callback?(status)
    }
  }
  
  func requestNotifications(_ callback: Callback) {
    UNUserNotificationCenter.current().requestAuthorization(options: options) { [callbacks, statusNotifications] granted, error in
      Defaults.requestedNotifications = true
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        callbacks(statusNotifications)
      }
    }
  }
  
  private var synchronousStatusNotifications: PermissionStatus {
    let semaphore = DispatchSemaphore(value: 0)
    
    var status: PermissionStatus = .notDetermined
    
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      switch settings.authorizationStatus {
      case .authorized: status = .authorized
      case .denied: status = .denied
      case .notDetermined: status = .notDetermined
      case .provisional: status = .authorized
      @unknown default: status = .notDetermined
      }
      
      semaphore.signal()
    }
    
    _ = semaphore.wait(timeout: .distantFuture)
    
    return status
  }
}
