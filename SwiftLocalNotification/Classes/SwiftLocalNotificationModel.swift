//
//  SwiftLocalNotification.swift
//  SwiftLocalNotification
//
//  Created by Salar Soleimani on 2020-04-01.
//  Copyright © 2020 SaSApps.ca All rights reserved.
//

import UserNotifications
import CoreLocation

///Sas Local Notification
@available(iOS 10.0, *)
public class SwiftLocalNotificationModel: NSObject {
  ///Contains the internal instance of the notification request
  internal var localNotificationRequest: UNNotificationRequest?
  
  ///Holds the repeat interval of the notification with Enum Type Repeats
  var repeatInterval: RepeatingInterval = .none
  
  ///Holds the body of the message of the notification
  fileprivate(set) public var body: String?
  
  ///Holds the title of the message of the notification
  fileprivate(set) public var title: String?
  
  ///Holds the subtitle of the message of the notification
  fileprivate(set) public var subtitle: String?
  
  ///Holds name of the music file of the notification
  fileprivate(set) public var soundName: String?
  
  ///Holds the date that the notification will be first fired
  fileprivate(set) public var fireDate: Date?
  
  ///Know if a notification repeats from this value
  fileprivate(set) public var repeats: Bool = false
  
  ///Hold the identifier of the notification to keep track of it
  fileprivate(set) public var identifier: String
  
  ///Number to display on the application icon.
  fileprivate(set) public var badge: Int?
  
  ///Hold the attachments for the notifications
  public var attachments: [UNNotificationAttachment]?
  
  ///Hold the category of the notification if you want to set one
  public var category: String?
  
  ///If it is a region based notification then you can access the notification
  var region: CLRegion?
  
  /// The status of the notification.
  internal(set) public var isScheduled: Bool = false
  
  /// A dictionary that holds additional information.
  private(set) public var userInfo: [AnyHashable : Any]!
  
  /// A key that holds the identifier of the notification which; stored in the `userInfo` property.
  public static let identifierKey: String = "SwiftLocalNotificationIdentifierKey"
  
  /// A key that holds the date of the notification; stored in the `userInfo` property.
  public static let dateKey: String = "SwiftLocalNotificationDateKey"
  
  /// A key that holds the repeating of the notification; stored in the `userInfo` property.
  public static let repeatingKey: String = "SwiftLocalNotificationRepeatingKey"
  
  /// A key that holds the repeating of the notification; stored in the `userInfo` property.
  public static let soundNameKey: String = "SwiftLocalNotificationSoundNameKey"
  
  enum CodingKeys: String, CodingKey {
    case localNotificationRequest
    case repeatInterval
    case body
    case title
    case subtitle
    case soundName
    case fireDate
    case repeats
    case identifier
    case region
    case attachments
    case badge
    case launchImageName
    case category
    case userInfo
    case isScheduled
  }
  
  public init(title: String, body: String, subtitle: String? = "", date: Date, repeating: RepeatingInterval, identifier: String = UUID().uuidString, soundName: String? = nil, badge: Int? = 1) {
    self.body = title
    self.title = body
    self.subtitle = subtitle
    self.fireDate = date
    self.repeatInterval = repeating
    self.identifier = identifier == "" ? UUID().uuidString : identifier
    self.soundName = soundName
    self.badge = badge
    self.repeats = repeating == .none ? false : true
    self.userInfo = [
      SwiftLocalNotificationModel.identifierKey : identifier,
      SwiftLocalNotificationModel.dateKey : date,
      SwiftLocalNotificationModel.repeatingKey: repeating.rawValue,
      SwiftLocalNotificationModel.soundNameKey: soundName ?? ""
    ]
  }
  
  /// Region based notification
  /// Default notifyOnExit and notifyOnEntry is
  public init(identifier: String = UUID().uuidString, title: String, body: String, subtitle: String = "", region: CLRegion?, notifyOnExit: Bool = true, notifyOnEntry: Bool = true, soundName: String? = nil, badge: Int = 1, repeats: Bool = false) {
    self.body = body
    self.title = title
    self.subtitle = subtitle
    self.identifier = identifier == "" ? UUID().uuidString : identifier
    self.region = region
    self.soundName = soundName
    self.repeats = repeats
    region?.notifyOnExit = notifyOnExit
    region?.notifyOnEntry = notifyOnEntry
    self.userInfo = [
      SwiftLocalNotificationModel.identifierKey : identifier,
      SwiftLocalNotificationModel.dateKey : Date(),
      SwiftLocalNotificationModel.soundNameKey: soundName ?? ""
    ]
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let repeatString = try container.decode(String.self, forKey: .repeatInterval)
    self.repeatInterval = RepeatingInterval(rawValue: repeatString)!
    self.title = try container.decodeIfPresent(String.self, forKey: .title)
    self.body = try container.decodeIfPresent(String.self, forKey: .body)
    self.subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
    self.soundName =  try container.decode(String.self, forKey: .soundName)
    self.fireDate = try container.decodeIfPresent(Date.self, forKey: .fireDate)
    self.repeats = try container.decode(Bool.self, forKey: .repeats)
    self.identifier = try container.decode(String.self, forKey: .identifier)
    self.badge = try container.decodeIfPresent(Int.self, forKey: .badge)
    self.category = try container.decodeIfPresent(String.self, forKey: .category)
    self.isScheduled = try container.decode(Bool.self, forKey: .isScheduled)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(repeatInterval.rawValue, forKey: CodingKeys.repeatInterval)
    try container.encode(title, forKey: .title)
    try container.encode(body, forKey: .body)
    try container.encode(subtitle, forKey: .subtitle)
    try container.encode(soundName, forKey: .soundName)
    try container.encode(fireDate, forKey: .fireDate)
    try container.encode(repeats, forKey: .repeats)
    try container.encode(identifier, forKey: .identifier)
    try container.encode(badge, forKey: .badge)
    try container.encode(category, forKey: .category)
    try container.encode(isScheduled, forKey: .isScheduled)
  }

  /// Adds a value to the specified key in the `userInfo` property. Note that the value is not added if the key is equal to the `identifierKey` or `dateKey`.
  ///
  /// - Parameters:
  ///   - value: The value to set.
  ///   - key: The key to set the value of.
  public func setUserInfo(value: Any, forKey key: AnyHashable) {
    if let keyString = key as? String {
      if (keyString == SwiftLocalNotificationModel.identifierKey || keyString == SwiftLocalNotificationModel.dateKey) {
        return
      }
    }
    self.userInfo[key] = value
  }
  
  public func setAllUserInfo(_ with: [AnyHashable : Any]) {
    self.userInfo = with
  }
  /// Removes the value of the specified key. Note that the value is not removed if the key is equal to the `identifierKey` or `dateKey`.
  ///
  /// - Parameter key: The key to remove the value of.
  public func removeUserInfoValue(forKey key: AnyHashable) {
    if let keyString = key as? String {
      if (keyString == SwiftLocalNotificationModel.identifierKey || keyString == SwiftLocalNotificationModel.dateKey) {
        return
      }
    }
    self.userInfo.removeValue(forKey: key)
  }
  
  public func updateFireDate(_ fireDate: Date) {
    self.fireDate = fireDate
  }
  public override var description: String {
    var result  = ""
    result += "SwiftLocalNotification: \(String(describing: self.identifier))\n"
    result += "\tTitle: \(title ?? "no title")\n"
    
    result += "\tBody: \(self.body ?? "nobody")\n"
    result += "\tFires at: \(String(describing: self.fireDate))\n"
    result += "\tUser info: \(String(describing: self.userInfo))\n"
    if let badge = self.badge {
      result += "\tBadge: \(badge)\n"
    }
    result += "\tSound name: \(self.soundName ?? "defualt soundName")\n"
    result += "\tRepeats every: \(self.repeatInterval.rawValue)\n"
    result += "\tScheduled: \(self.isScheduled)"
    
    return result
  }
}

extension SwiftLocalNotificationModel {
  public static func == (lhs: SwiftLocalNotificationModel, rhs: SwiftLocalNotificationModel) -> Bool {
    return lhs.identifier == rhs.identifier
  }
  public static func <(lhs: SwiftLocalNotificationModel, rhs: SwiftLocalNotificationModel) -> Bool {
    return lhs.fireDate?.compare(rhs.fireDate ?? Date()) == ComparisonResult.orderedAscending
  }
}
