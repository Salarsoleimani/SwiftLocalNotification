//
//  SwiftLocalNotificationCategory.swift
//  SASLocalNotification
//
//  Created by Salar Soleimani on 2020-04-01.
//  Copyright © 2020 SaSApps.ca All rights reserved.
//

import UserNotifications
/// A wrapper class for creating a Category
@available(iOS 10.0, *)
public class SwiftLocalNotificationCategory {
  /// Holds the actions you want available for this category type
  private var actions = [UNNotificationAction]()
  
  /// Hold the actual cateogry
  internal var categoryInstance: UNNotificationCategory?
  
  /// Holds the identifier of the category type
  var identifier: String
  
  public init (categoryIdentifier: String, actions: [UNNotificationAction] = [UNNotificationAction]()) {
    identifier = categoryIdentifier
    self.actions = actions
  }
  
  @available(iOS 11.0, *)
  public func addActionButton(identifier: String, title: String, actionOptions: UNNotificationActionOptions = [UNNotificationActionOptions.foreground], categoryOptions: UNNotificationCategoryOptions = [.hiddenPreviewsShowTitle]) {
    let action = UNNotificationAction(identifier: identifier, title: title, options: actionOptions)
    
    actions.append(action)
    categoryInstance = UNNotificationCategory(identifier: self.identifier, actions: self.actions, intentIdentifiers: [], options: categoryOptions)
  }
  
  public func set() {
    var notificationCategories = Set<UNNotificationCategory>()
    if let categoryInstance = categoryInstance {
      notificationCategories.insert(categoryInstance)
    }
    UNUserNotificationCenter.current().setNotificationCategories(notificationCategories)
  }
}
